#import <Foundation/Foundation.h>

#import "VConductorClient.h"
#import "ChatManager.h"
#import "VSRoomLoader.h"
#import "VSHttpClient.h"
#import "ToolFunc.h"

#import "ClassRoom.h"
#import "ClassMember+private.h"
#import "LocalView.h"

#import <VSRTC/VSRTC.h>
#import <VSRTC/VSRoomUser.h>
#import <VSRTC/VSMedia.h>


@interface VConductorClient() <VSRoomLoaderObserver, VSRTCDelegate> {
  dispatch_source_t mTimer;
}
@property (nonatomic, weak) id<VConductorClientDelegate> mDelegate;
@property (nonatomic, strong) NSString *mUserId;
@property (nonatomic, strong) NSString *mNickName;
@property (nonatomic, assign) BOOL mInitIsViewer;
@property (nonatomic, strong) NSMutableDictionary *mInitRoomInfo;
@property (nonatomic, strong) NSMutableDictionary *mInitExtendInfo;
@property (nonatomic, strong) VSRoomLoader *mRoomLoader;

@property (nonatomic, strong) ClassRoom* mRoom;
@property (nonatomic, strong) ClassMember* mMySession; //自己
@property (nonatomic, strong) ClassMember* mHostMember; //老师
@property (nonatomic, strong) NSMutableDictionary* mGuestMembers; //其他成员

@property (nonatomic, assign) BOOL mDoReport;
@property (nonatomic, assign) BOOL mFirstReport;
@property (nonatomic, assign) UInt64 mLastReportTm;

@end

@implementation VConductorClient

@synthesize mDelegate;
@synthesize mUserId;
@synthesize mNickName;
@synthesize mInitIsViewer;
@synthesize mInitRoomInfo;
@synthesize mInitExtendInfo;
@synthesize mRoomLoader;

@synthesize mRoom;
@synthesize mMySession;
@synthesize mHostMember;
@synthesize mGuestMembers;

@synthesize mDoReport;
@synthesize mFirstReport;
@synthesize mLastReportTm;

+ (instancetype)sharedInstance {
  static VConductorClient * instance;
  if (!instance) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[[self class] alloc] init];
    });
  }
  return instance;
}

- (id)init {
  self = [super init];
  
  return self;
}

- (NSString*)sdkVersion {
  return [VSRTC version];
}

- (void)initSDK {
  [[VSRTC sharedInstance] startup:@"https://stat.content.hkunicom.com:9099"];
  /// [[VSRTC sharedInstance] enableAutoRelay:NO];
  [[VSRTC sharedInstance] configAudioMode:VS_AUDIO_VOIP andUseSpeaker:YES];
  //    NSSetUncaughtExceptionHandler(&getException);
  
  [[VSRTC sharedInstance] setObserver:self];
  
  [self requestMic];
  
  mTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
  dispatch_source_set_timer(mTimer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
  dispatch_source_set_event_handler(mTimer, ^{
    [self internalCheck];
  });
  // 启动任务，GCD计时器创建后需要手动启动
  dispatch_resume(mTimer);
  // 终止定时器
  // dispatch_suspend(mTimer);
  
  [[ChatManager sharedInstance] initSDK];
}

- (void)requestMic {
  AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
  if (audioAuthStatus == AVAuthorizationStatusNotDetermined) {// 未询问用户是否授权
    //第一次询问用户是否进行授权
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
      // CALL YOUR METHOD HERE - as this assumes being called only once from user interacting with permission alert!
      if (granted) {
        //VSAudioMode audioMode = [ConfigManager sharedInstance].audioMode;
        //[[VSRTC sharedInstance] configAudioMode:audioMode andUseSpeaker:YES];
      }
      else {
        // Microphone disabled code
      }
    }];
  } else if(audioAuthStatus == AVAuthorizationStatusRestricted || audioAuthStatus == AVAuthorizationStatusDenied) {// 未授权
    
  } else{// 已授权
    //VSAudioMode audioMode = [ConfigManager sharedInstance].audioMode;
    //[[VSRTC sharedInstance] configAudioMode:audioMode andUseSpeaker:YES];
  }
}

- (void)internalCheck {
  dispatch_async(dispatch_get_main_queue(), ^{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [self.mDelegate onTick];
    });
    NSInteger hostCount = (self->mHostMember != nil) ? 1 : 0;
    NSInteger guestCount = self->mGuestMembers.count;
//    NSLog(@"internalCheck host count = %lu guest count = %lu", hostCount, guestCount);
//    NSLog(@"internalCheck remote media count = %lu", [[VSRTC sharedInstance] remoteMediaCount]);
    
    if (self.mDoReport) {
      [self reportStats];
    }
  });
}

- (void)internalCleanup {
  [mMySession closeLocalMedia];
  
  [[VSRTC sharedInstance] DestroyAllMedia];
  [[VSRTC sharedInstance] DestroyChat];
  
  mMySession = nil;
  mHostMember = nil;
  [mGuestMembers removeAllObjects];
  mRoom = nil;
  
  [[ChatManager sharedInstance] quitChat];
  
  [self stopReport];
}

- (void)startReport {
  mDoReport = YES;
  mFirstReport = YES;
  mLastReportTm = 0;
}

- (void)stopReport {
  mDoReport = NO;
  mFirstReport = NO;
  mLastReportTm = 0;
}

- (void)joinwithEntry:(NSString*)vrcUrl andCode:(NSDictionary*)codeDic asViewer:(BOOL)isViewer withDelegate:(id<VConductorClientDelegate>)delegate {
  mDelegate = delegate;
  
  NSString *eventId = [codeDic objectForKey:@"eid"];
  mNickName = [codeDic objectForKey:@"name"];
  mUserId = [@"ios" stringByAppendingString:[ToolFunc randomStringWithLength:6]];
  
  mInitIsViewer = isViewer;
  
  mInitExtendInfo = [NSMutableDictionary new];
  if (isViewer) {
    mInitExtendInfo[@"room_active_role"] = @"viewer";
  } else {
    mInitExtendInfo[@"room_active_role"] = @"guest";
  }
  mInitExtendInfo[@"label"] = @"common";
  mInitExtendInfo[@"resolution"] = @"1280*720";
  
  mInitExtendInfo[@"video2prepare"] = [NSNumber numberWithBool:NO];
  mInitExtendInfo[@"video2playout"] = [NSNumber numberWithBool:NO];
  mInitExtendInfo[@"video2peer"] = [NSNumber numberWithBool:NO];
  mInitExtendInfo[@"handsUp"] = [NSNumber numberWithBool:NO];
  mInitExtendInfo[@"ioDeviceEnable"] = [NSNumber numberWithInt:1];
  
  mInitRoomInfo = [NSMutableDictionary new];
  mInitRoomInfo[@"remixScreen"] = @"main";
  mInitRoomInfo[@"allowPlayoutPrivateChat"] = [NSNumber numberWithBool:NO];
  mInitRoomInfo[@"hostOnDuty"] = [NSNumber numberWithBool:NO];
  mInitRoomInfo[@"enableRemixImage"] = [NSNumber numberWithBool:NO];
  mInitRoomInfo[@"playoutMode"] = @"free";
  
  dispatch_async(dispatch_get_main_queue(), ^(void) {
    [self.mDelegate onJoinRoomLoading];
  });
  
  mRoomLoader = [[VSRoomLoader alloc] initWithEntry:vrcUrl andEventId:eventId andRoomInfo:mInitRoomInfo andObserver:self];
  [mRoomLoader startLoad];
  
  mGuestMembers = [NSMutableDictionary new];
}

- (void)leave {
  [[VSRTC sharedInstance] leaveRoom];
}

- (BOOL)isViewer {
  if (mMySession == nil) {
    return mInitIsViewer;
  }
  return mMySession.isViewer;
}

- (BOOL)canSwitchViewerMode {
  if (mRoom == nil) {
    return NO;
  }
  return mRoom.supportLive;
}

- (void)requestSwitchViewerMode {
  BOOL curViewerMode = (mMySession != nil) ? mMySession.isViewer : mInitIsViewer;
  
  NSMutableDictionary *newExtendInfo = [NSMutableDictionary new];
  if (curViewerMode) {
    newExtendInfo[@"room_active_role"] = @"guest";
    newExtendInfo[@"video2peer"] = [NSNumber numberWithBool:NO];
    newExtendInfo[@"video2pin"] = [NSNumber numberWithBool:NO];
    newExtendInfo[@"share2peer"] = [NSNumber numberWithBool:NO];
    newExtendInfo[@"handsUp"] = [NSNumber numberWithBool:NO];
    newExtendInfo[@"ioDeviceEnable"] = [NSNumber numberWithInt:1];
  } else {
    newExtendInfo[@"room_active_role"] = @"viewer";
    newExtendInfo[@"video2peer"] = [NSNumber numberWithBool:NO];
    newExtendInfo[@"video2pin"] = [NSNumber numberWithBool:NO];
    newExtendInfo[@"share2peer"] = [NSNumber numberWithBool:NO];
    newExtendInfo[@"handsUp"] = [NSNumber numberWithBool:NO];
    newExtendInfo[@"ioDeviceEnable"] = [NSNumber numberWithInt:0];
  }
  [[VSRTC sharedInstance] updateCustomExtendData:newExtendInfo];
}

- (NSString*)getViewerUrl {
  if (mRoom == nil) {
    return @"";
  }
  return mRoom.liveUrl;
}

- (VSVideoRender*)createVideoRender {
  VSVideoRender *newRender = [[VSRTC sharedInstance] CreateVideoRender];
  return newRender;
}

- (void)destroyVideoRender:(VSVideoRender*)videoRender {
  
}

- (ClassMember*)getMySession {
  return mMySession;
}

- (ClassMember*)getHostMember {
  return mHostMember;
}

- (NSDictionary*)getGustMemberData{
    return mGuestMembers;
}


- (NSInteger)getElapsedSeconds {
  if (mRoom == nil) {
    return 0;
  }
  return mRoom.elapsedSeconds;
}

- (PlayoutLayoutMode)memberLayoutMode {
  if (mRoom == nil) {
    return PLAYOUT_LAYOUT_GRID;
  }
  return mRoom.playoutLayout;
}

- (NSDictionary*)getOnAirMembers {
  NSMutableDictionary *members = [NSMutableDictionary new];
//  if (mHostMember.group == CLASS_GROUP_HOST_ONAIR && mHostMember.hasStream) {
  if ([mHostMember isHost] && mHostMember.hasStream) {
    [members setObject:mHostMember forKey:mHostMember.userId];
  }
  for (ClassMember *guest in mGuestMembers.allValues) {
    if (guest.group == CLASS_GROUP_GUEST_ONAIR && guest.hasStream) {
      [members setObject:guest forKey:guest.userId];
    }
  }
  return members;
}

- (BOOL)isMemberOnAir:(NSString*)userId {
  if (mHostMember != nil && [mHostMember.userId isEqualToString:userId]) {
    return mHostMember.group == CLASS_GROUP_HOST_ONAIR;
  }
  ClassMember *guest = [mGuestMembers objectForKey:userId];
  if (guest == nil) {
    return NO;
  }
  return guest.group == CLASS_GROUP_GUEST_ONAIR;
}

- (void)bindLocalVideoRender:(VSVideoRender*)render {
  [mMySession bindLocalVideoRender:render];
}

- (void)unbindLocalVideoRender:(VSVideoRender*)render {
  [mMySession unbindLocalVideoRender:render];
}

- (void)bindMainVideoRender:(VSVideoRender*)render ofUser:(NSString*)userId {
  if (mHostMember != nil && [mHostMember.userId isEqualToString:userId]) {
    [mHostMember bindMainVideoRender:render];
    return;
  }
  ClassMember *member = [mGuestMembers objectForKey:userId];
  if (member == nil) {
    return;
  }
  [member bindMainVideoRender:render];
}

- (void)unbindMainVideoRender:(VSVideoRender*)render ofUser:(NSString*)userId {
  if (mHostMember != nil && [mHostMember.userId isEqualToString:userId]) {
    [mHostMember unbindMainVideoRender:render];
    return;
  }
  ClassMember *member = [mGuestMembers objectForKey:userId];
  if (member == nil) {
    return;
  }
  [member unbindMainVideoRender:render];
}

- (void)bindShareVideoRender:(VSVideoRender*)render ofUser:(NSString*)userId {
  if (mHostMember != nil && [mHostMember.userId isEqualToString:userId]) {
    [mHostMember bindShareVideoRender:render];
    return;
  }
  ClassMember *member = [mGuestMembers objectForKey:userId];
  if (member == nil) {
    return;
  }
  [member bindShareVideoRender:render];
}

- (void)unbindShareVideoRender:(VSVideoRender*)render ofUser:(NSString*)userId {
  if (mHostMember != nil && [mHostMember.userId isEqualToString:userId]) {
    [mHostMember unbindShareVideoRender:render];
    return;
  }
  ClassMember *member = [mGuestMembers objectForKey:userId];
  if (member == nil) {
    return;
  }
  [member unbindShareVideoRender:render];
}

- (void)enableVideo:(BOOL)enable {
  if (mMySession == nil) {
    return;
  }
  [mMySession enableLocalVideo:enable];
}

- (BOOL)isVideoEnable {
  if (mMySession == nil) {
    return NO;
  }
  return [mMySession isLocalVideoEnable];
}

- (void)enableAudio:(BOOL)enable {
  if (mMySession == nil) {
    return;
  }
  [mMySession enableLocalAudio:enable];
}

- (BOOL)isAudioEnable {
  if (mMySession == nil) {
    return NO;
  }
  return [mMySession isLocalAudioEnable];
}

- (void)requestHandup:(BOOL)up {
#if 0
  if (mMySession == nil) {
    return;
  }
  VSRoomUser *userInfo = [mMySession copyInfo];
  NSMutableDictionary *newCustom = [NSMutableDictionary dictionaryWithDictionary:userInfo.custom];
  newCustom[@"extend"][@"handsUp"] = [NSNumber numberWithBool:up];
  [[VSRTC sharedInstance] updateCustomExtendData:newCustom[@"extend"]];
#else
  NSMutableDictionary *handupReq = [NSMutableDictionary new];
  handupReq[@"type"] = @"hands-up";
  NSMutableDictionary *reqData = [NSMutableDictionary new];
  reqData[@"userId"] = mUserId;
  reqData[@"hand"] = [NSNumber numberWithBool:YES];
  handupReq[@"data"] = reqData;
  [[VSRTC sharedInstance] sendMessage:[ToolFunc jsonMessage:handupReq] toUser:@""];
#endif
}

- (BOOL)isHandup {
  if (mMySession == nil) {
    return NO;
  }
  return [mMySession isHandup];
}

- (NSString*)getImGroupId {
  return [NSString stringWithFormat:@"%@_%@", self.mRoomLoader.mTenantId, self.mRoomLoader.mEventId];
}

#pragma mark - VSRoomLoaderObserver

- (void)OnRoomLoadSuccess:(VSRoomParam*)param {
  [[VSRTC sharedInstance] joinRoomWithApiKey:self.mRoomLoader.mApiKey
                                   andTenant:self.mRoomLoader.mTenantId
                                    andEvent:self.mRoomLoader.mEventId
                                      andRms:self.mRoomLoader.mVrcUrl
                                      andVrx:param.mVrxUrl
                                      andIls:param.mVrsUrl
                                      andVsu:param.mVrfUrl
                                     andUser:mUserId
                                  andDisplay:mNickName
                                   andExtend:mInitExtendInfo
                                    asViewer:mInitIsViewer
                              andMemberLimit:2000
                                  completion:^(NSError *error) {
                                    if (error == nil) {
                                      dispatch_async(dispatch_get_main_queue(), ^(void) {
                                        [self.mDelegate onJoinRoomSuccess];
                                      });
                                      [self.mRoomLoader requestRoomEventInfo];
                                      [self startReport];
                                    } else {
                                      dispatch_async(dispatch_get_main_queue(), ^(void) {
                                        NSString *errStr = [NSString stringWithFormat:@"%@=%ld", error.localizedDescription, (long)error.code];
                                        [self.mDelegate onJoinRoomFailed:errStr];
                                      });
                                    }
                                  }];
  
  [[ChatManager sharedInstance] joinChat:[NSString stringWithFormat:@"%@_%@", self.mRoomLoader.mTenantId, self.mRoomLoader.mEventId] withUserName:mNickName andUserSig:param.mTxImUserSig];
}

- (void)OnRoomLoadFailed:(NSInteger)errCode andDesc:(NSString*)errStr {
  dispatch_async(dispatch_get_main_queue(), ^(void) {
    NSString *errMsg = [NSString stringWithFormat:@"Error %ld:%@", errCode, errStr];
    [self.mDelegate onJoinRoomFailed:errMsg];
  });
}

- (void)OnRoomEventInfoFetched:(NSString*)info {
  if (mRoom == nil) {
    return;
  }
  [mRoom fillEventInfo:info];
  
  dispatch_async(dispatch_get_main_queue(), ^(void) {
    [self.mDelegate onRoomUpdate:self.mRoom];
  });
}

#pragma mark - VSRTCDelegate

- (void) onRoomEntry:(NSInteger)memberCount {
  
}

- (void) onSessionInit:(VSRoomUser*)session {
  ClassMember *mySession = [[ClassMember alloc] initWith:session];
  [self setMySession:mySession];
}

- (void) onSessionUpdate:(VSRoomUser*)session {
  ClassMember *mySession = [[ClassMember alloc] initWith:session];
  [self setMySession:mySession];
}

- (void)onSessionError:(int)status andDesc:(NSString *)msg {
  dispatch_async(dispatch_get_main_queue(), ^(void) {
    [self.mDelegate onLostRoomWithCode:status andError:msg];
  });
  [[VSRTC sharedInstance] leaveRoom];
}

- (void)onSessionQuit {
  [self internalCleanup];
  dispatch_async(dispatch_get_main_queue(), ^(void) {
    [self.mDelegate onLeaveRom];
  });
}

- (void) onMemberJoin:(VSRoomUser*)user {
//    获取一次全部的人员信息
  ClassMember *member = [[ClassMember alloc] initWith:user];
  if ([member isHost]) {
    [self setHostMember:member];
  } else if ([member isGuest]) {
    [self setGuestMember:member];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"GuestMemberChange" object:nil];
  } else {
    
  }
}

//成员信息更新
- (void) onMemberUpdate:(VSRoomUser*)user {
  ClassMember *member = [[ClassMember alloc] initWith:user];
  if ([member isHost]) {
    [self setHostMember:member];
  } else if ([member isGuest]) {
    [self setGuestMember:member];
  } else {
    
  }
}

//有成员离开，处理host 或者member数据  发出人员更新的通知
- (void) onMemberLeave:(VSRoomUser*)user {
  ClassMember *member = [[ClassMember alloc] initWith:user];
  if ([member isHost]) {
    [self clearHostMember:member];
  } else if ([member isGuest]) {
    [self clearGuestMember:member];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GuestMemberChange" object:nil];
  } else {
    
  }
}

- (void)onAppMessage:(NSString*)msg {
  //NSDictionary *msgDic = [ToolFunc dictionaryMessage:msg];
  //NSString *msgType = [msgDic objectForKey:@"type"];
  
}

- (void)onRoomInfoRefresh:(NSString*)data {
  [self setRoomInfo:data];
}

- (void)onMediaServiceReady {
}

- (void)onMediaServiceLost {
}

- (void)onMediaServiceDisconnect {
}

#pragma mark - session check

- (void)setRoomInfo:(NSString*)roomInfo {
  if (mRoom == nil) {
    NSDictionary *roomAddition = [ToolFunc dictionaryMessage:[[VSRTC sharedInstance] getRoomAddition]];
    self.mRoom = [[ClassRoom alloc] initWith:[ToolFunc dictionaryMessage:roomInfo] andAddition:roomAddition];
  } else {
    [mRoom syncInfo:[ToolFunc dictionaryMessage:[[VSRTC sharedInstance] getRoomInfo]]];
  }
  dispatch_async(dispatch_get_main_queue(), ^(void) {
    [self.mDelegate onRoomUpdate:self.mRoom];
  });
}

- (void)setMySession:(ClassMember*)session {
  BOOL currentViewerMode = [self isViewer];
  BOOL viewerModeInit = NO;
  if (mMySession == nil) {
    mMySession = session;
    viewerModeInit = YES;
  } else {
    [mMySession syncInfo:session];
  }
  
  if (viewerModeInit || currentViewerMode != mMySession.isViewer) {
    [self switchViewerMode];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [self.mDelegate onSessionUpdate:self.mMySession withViewerModeChanged:YES];
    });
  } else {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [self.mDelegate onSessionUpdate:self.mMySession withViewerModeChanged:NO];
    });
  }
}

- (void)switchViewerMode {
  if ([self isViewer]) {
    [mMySession closeLocalMedia];
    
    if (mHostMember != nil) {
      [mHostMember closeStream];
      [mHostMember closeShareStream];
      mHostMember = nil;
    }
    for (ClassMember *guest in mGuestMembers.allValues) {
      [guest closeStream];
    }
    [mGuestMembers removeAllObjects];
  } else {
    [mMySession openLocalMedia];
    
    NSArray *members = [[VSRTC sharedInstance] getMemberList];
    for (VSRoomUser *user in members) {
      [self onMemberJoin:user];
    }
  }
}

- (void)setHostMember:(ClassMember*)member {
  if ([self isViewer]) {
    return;
  }
  
  if (mHostMember == nil) {
    mHostMember = member;
  } else {
    [mHostMember syncInfo:member];
  }
  
  [mHostMember checkStream];
  BOOL allowShare = [mRoom isMemeberAllowShare:mHostMember.userId];
  [mHostMember checkShareStream:allowShare];
}

- (void)clearHostMember:(ClassMember*)member {
  if ([self isViewer]) {
    return;
  }
  
  [mHostMember closeStream];
  [mHostMember closeShareStream];
  mHostMember = nil;
}

- (void)setGuestMember:(ClassMember*)member {
  if ([self isViewer]) {
    return;
  }
  
  ClassMember *existMember = [mGuestMembers objectForKey:member.userId];
  if (existMember == nil) {
    [mGuestMembers setObject:member forKey:member.userId];
    existMember = member;
  } else {
    [existMember syncInfo:member];
  }
  
  [existMember checkStream];
  BOOL allowShare = [mRoom isMemeberAllowShare:existMember.userId];
  [existMember checkShareStream:allowShare];
}

- (void)clearGuestMember:(ClassMember*)member {
  if ([self isViewer]) {
    return;
  }
  
  ClassMember *existMember = [mGuestMembers objectForKey:member.userId];
  if (existMember == nil) {
    NSAssert(false, @"Missing exist guest member when clearGuestMember");
    return;
  }
  [existMember closeStream];
  [existMember closeShareStream];
  [mGuestMembers removeObjectForKey:member.userId];
}

- (void)reportStats {
  UInt64 curTm = [[NSDate date] timeIntervalSince1970];
  if ((curTm - mLastReportTm) < 60) {
    return;
  }
  
  NSString *reportEventId = [NSString stringWithFormat:@"%@_%@", mRoomLoader.mTenantId, mRoomLoader.mEventId];
  NSNumber *tmVal = [NSNumber numberWithLongLong:curTm * 1000];
  NSNumber *firstReportVal = [NSNumber numberWithBool:mFirstReport];
  
  NSMutableDictionary *userData = [NSMutableDictionary new];
  [userData setValue:[NSNumber numberWithBool:YES] forKey:@"sAuthorization"];
  [userData setValue:mUserId forKey:@"sUserAccount"];
  [userData setValue:mNickName forKey:@"sUserName"];
  [userData setValue:@"guest" forKey:@"sUserRole"];
  [userData setValue:@"" forKey:@"sUserLevel1"];
  [userData setValue:@"" forKey:@"sUserLevel2"];
  [userData setValue:reportEventId forKey:@"sEventId"];
  [userData setValue:firstReportVal forKey:@"sEventBegin"];             // 首次为true 后面为false
  [userData setValue:@"live" forKey:@"sMediaType"];                   // 写死
  [userData setValue:[NSNumber numberWithInt:0] forKey:@"sWatched"];
  [userData setValue:[NSNumber numberWithInt:60] forKey:@"sWatchedPosition"];
  
  NSMutableDictionary *reportData = [NSMutableDictionary new];
  [reportData setValue:mUserId forKey:@"user_id"];
  [reportData setValue:userData forKey:@"userdata"];
  [reportData setValue:@"" forKey:@"ip"];
  [reportData setValue:@"" forKey:@"area"];
  [reportData setValue:@"terminal" forKey:@"mobie_ios"];            // box_android,mobie_ios,mobie_android
  [reportData setValue:mRoomLoader.mTenantId forKey:@"org_id"];
  [reportData setValue:tmVal forKey:@"tm"];
  
  NSString *reportUrl = @"https://jscnstat.edu.baron.com.cn/vsspb";
  
  [VSHttpClient sendRequestWithUrl:reportUrl andMethod:@"POST" andHeaders:nil andPayload:reportData andCallback:^(BOOL succeed, NSString *response, NSError *error) {
    if (succeed) {
      self.mLastReportTm = curTm;
      self.mFirstReport = NO;
    } else {
      
    }
  }];

}

@end
