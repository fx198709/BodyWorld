#import <Foundation/Foundation.h>

#import "ClassMember+private.h"

#import <VSRTC/VSRTC.h>
#import <VSRTC/VSRoomUser.h>
#import <VSRTC/VSMedia.h>

@interface ClassMember() <VSMediaEventHandler> {
  
}
@property (nonatomic, strong) VSRoomUser* mBaseInfo;

@property (nonatomic, strong) VSMedia* mLocalMedia;
@property (nonatomic, strong) VSMedia* mMainMedia;
@property (nonatomic, strong) VSMedia* mShareMedia;
@end

@implementation ClassMember

@synthesize mBaseInfo;
@synthesize mLocalMedia;
@synthesize mMainMedia;
@synthesize mShareMedia;

- (id)initWith:(VSRoomUser*)user {
  self = [super init];
  mBaseInfo = [user copy];
  return self;
}

- (void)syncInfo:(ClassMember*)member {
  mBaseInfo = [member.mBaseInfo copy];
  if (mLocalMedia != nil) {
    [mLocalMedia EnableVideo:![self isCameraBlind]];
    [mLocalMedia EnableAudio:![self isMicMuted]];
  }
}

- (VSRoomUser*)copyInfo {
  return [mBaseInfo copy];
}

- (NSString *)userId {
  return mBaseInfo.userId;
}

- (NSString *)nickName {
  NSString *nickName = mBaseInfo.custom[@"internal"][@"nickName"];
  return nickName;
}

- (BOOL)isCameraBlind {
  return mBaseInfo.blind;
}

- (BOOL)isMicMuted {
  return mBaseInfo.muted;
}

- (BOOL)isHandup {
  NSNumber *handsUp = mBaseInfo.custom[@"extend"][@"handsUp"];
  return handsUp.boolValue;
}

- (BOOL)isHost {
  NSString *role = mBaseInfo.custom[@"extend"][@"room_active_role"];
  if ([role isEqualToString:@"host"]) {
    return YES;
  }
  return NO;
}

- (BOOL)isGuest {
  NSString *role = mBaseInfo.custom[@"extend"][@"room_active_role"];
  if ([role isEqualToString:@"guest"]) {
    return YES;
  }
  return NO;
}

- (BOOL)isViewer {
  NSString *role = mBaseInfo.custom[@"extend"][@"room_active_role"];
  if ([role isEqualToString:@"viewer"]) {
    return YES;
  }
  return NO;
}

- (ClassGroup)group {
  if ([self isViewer]) {
    return CLASS_GROUP_VIEWER;
  }
  
  if ([self isHost]) {
    NSNumber *v2peer = mBaseInfo.custom[@"extend"][@"video2playout"];
    if (v2peer.boolValue) {
      return CLASS_GROUP_HOST_ONAIR;
    }
    return CLASS_GROUP_HOST;
  }
  
  if ([self isGuest]) {
    NSNumber *v2peer = mBaseInfo.custom[@"extend"][@"video2playout"];
    if (v2peer.boolValue) {
      return CLASS_GROUP_GUEST_ONAIR;
    }
    return CLASS_GROUP_GUEST;
  }
  
  return CLASS_GROUP_VIEWER;
}

- (BOOL)hasStream {
  return [mBaseInfo hasStream];
}

- (BOOL)hasShareStream {
  return [mBaseInfo hasSecondStream];
}

- (BOOL)isSharing {
  return mShareMedia != nil;
}

- (void)openLocalMedia {
  if (mLocalMedia != nil) {
    return;
  }
  mLocalMedia = [[VSRTC sharedInstance] CreateCaptureMediaWithPosition:YES andSize:CGSizeMake(960, 540) andFramerate:30];
  [mLocalMedia SetEventHandler:self];
  [mLocalMedia OpenWithVideo:TRUE andAudio:TRUE];
  [mLocalMedia Publish:NO streamBitrate:500 stramLabel:mBaseInfo.userId];
}

- (void)closeLocalMedia {
  if (mLocalMedia == nil) {
    return;
  }
  [mLocalMedia Close];
  mLocalMedia = nil;
  [[VSRTC sharedInstance] DestroyCaptureMedia];
}

- (void)enableLocalVideo:(BOOL)enable {
  if (mLocalMedia == nil) {
    return;
  }
  BOOL isBlind = !enable;
  [[VSRTC sharedInstance] updateCameraState:isBlind];
}

- (BOOL)isLocalVideoEnable {
  if (mLocalMedia == nil) {
    return NO;
  }
  return [mLocalMedia isVideoEnable];
}

- (void)enableLocalAudio:(BOOL)enable {
  if (mLocalMedia == nil) {
    return;
  }
  BOOL isMute = !enable;
  [[VSRTC sharedInstance] updateMicState:isMute];
}

- (BOOL)isLocalAudioEnable {
  if (mLocalMedia == nil) {
    return NO;
  }
  return [mLocalMedia isAudioEnable];
}

- (void)checkStream {
  BOOL needCloseOld = NO;
  BOOL needOpen = NO;

  if (![self isHost]) {
    needCloseOld = YES;
  } else if ([mBaseInfo hasStream]) {
    if (mMainMedia == nil) {
      needOpen = YES;
    } else if (![mMainMedia.stream_id isEqualToString:mMainMedia.stream_id]) {
      needCloseOld = YES;
      needOpen = YES;
    }
  } else {
    needCloseOld = YES;
  }

  if (needCloseOld && mMainMedia != nil) {
    [mMainMedia Close];
    [[VSRTC sharedInstance] DestroyRemoteMedia:mMainMedia.mid];
    mMainMedia = nil;
  }
  if (needOpen) {
    mMainMedia = [[VSRTC sharedInstance] CreateRemoteMedia:mBaseInfo.streamId];
    [mMainMedia SetEventHandler:self];
    [mMainMedia OpenWithVideo:TRUE andAudio:TRUE];
    [mMainMedia Subscribe];
  }
}

- (void)checkShareStream:(BOOL)allowShare {
  BOOL needCloseOld = NO;
  BOOL needOpen = NO;
  
  if ([self group] != CLASS_GROUP_HOST_ONAIR && [self group] != CLASS_GROUP_GUEST_ONAIR) {
    needCloseOld = YES;
  } else if ([mBaseInfo hasSecondStream]) {
    if (mShareMedia == nil) {
      needOpen = YES;
    } else if (![mShareMedia.stream_id isEqualToString:mShareMedia.stream_id]) {
      needCloseOld = YES;
      needOpen = YES;
    }
  } else {
    needCloseOld = YES;
  }
  
  if (!allowShare) {
    needOpen = NO;
  }
  
  if (needCloseOld && mShareMedia != nil) {
    [mShareMedia Close];
    [[VSRTC sharedInstance] DestroyRemoteMedia:mShareMedia.mid];
    mShareMedia = nil;
  }
  
  if (needOpen) {
    mShareMedia = [[VSRTC sharedInstance] CreateRemoteMedia:mBaseInfo.secondStreamId];
    [mShareMedia SetEventHandler:self];
    [mShareMedia OpenWithVideo:TRUE andAudio:TRUE];
    [mShareMedia Subscribe];
  }
}

- (void)closeStream {
  if (mMainMedia != nil) {
    [mMainMedia Close];
    [[VSRTC sharedInstance] DestroyRemoteMedia:mMainMedia.mid];
    mMainMedia = nil;
  }
}

- (void)closeShareStream {
  if (mShareMedia != nil) {
    [mShareMedia Close];
    [[VSRTC sharedInstance] DestroyRemoteMedia:mShareMedia.mid];
    mShareMedia = nil;
  }
}

- (void)bindLocalVideoRender:(VSVideoRender*)render {
  if (mLocalMedia == nil) {
    return;
  }
  NSInteger oldHandle = mLocalMedia.renderHandle;
  if (oldHandle == -1) {
    [mLocalMedia BindVideoRender:render];
  } else if (oldHandle != render.handle) {
    [mLocalMedia UnbindVideoRender];
    [mLocalMedia BindVideoRender:render];
  } else {
    //NSLog(@"ignore already bind local video render");
  }
}

- (void)unbindLocalVideoRender:(VSVideoRender*)render {
  if (mLocalMedia == nil) {
    return;
  }
  NSInteger oldHandle = mLocalMedia.renderHandle;
  if (oldHandle == render.handle) {
    [mLocalMedia UnbindVideoRender];
  } else {
    NSLog(@"ignore already unbind local video render");
  }
}

- (void)bindMainVideoRender:(VSVideoRender*)render {
  if (mMainMedia == nil) {
    return;
  }
  NSInteger oldHandle = mMainMedia.renderHandle;
  if (oldHandle == -1) {
    [mMainMedia BindVideoRender:render];
  } else if (oldHandle != render.handle) {
    [mMainMedia UnbindVideoRender];
    [mMainMedia BindVideoRender:render];
  } else {
    //NSLog(@"ignore already bind main video render");
  }
}

- (void)unbindMainVideoRender:(VSVideoRender*)render {
  if (mMainMedia == nil) {
    return;
  }
  NSInteger oldHandle = mMainMedia.renderHandle;
  if (oldHandle == render.handle) {
    [mMainMedia UnbindVideoRender];
  } else {
    NSLog(@"ignore already unbind main video render");
  }
}

- (void)bindShareVideoRender:(VSVideoRender*)render {
  if (mShareMedia == nil) {
    return;
  }
  NSInteger oldHandle = mShareMedia.renderHandle;
  if (oldHandle == -1) {
    [mShareMedia BindVideoRender:render];
  } else if (oldHandle != render.handle) {
    [mShareMedia UnbindVideoRender];
    [mShareMedia BindVideoRender:render];
  } else {
    //NSLog(@"ignore already bind share video render");
  }
}

- (void)unbindShareVideoRender:(VSVideoRender*)render {
  if (mShareMedia == nil) {
    return;
  }
  NSInteger oldHandle = mShareMedia.renderHandle;
  if (oldHandle == render.handle) {
    [mShareMedia UnbindVideoRender];
  } else {
    NSLog(@"ignore already unbind share video render");
  }
}

#pragma mark - VSMediaEventHandler

- (void)OnOpening:(VSMedia*)handle {
}

- (void)OnOpened:(VSMedia*)handle {
}

- (void)OnClose:(VSMedia*)handle {
  // [_videoRender clearImage];
}

- (void)OnError:(VSMedia*)handle withError:(NSString *)errDesc {
}

- (void)OnStreamIdle:(VSMedia*)handle {
}

- (void)OnStreamStarting:(VSMedia*)handle {
}

- (void)OnStreamStarted:(VSMedia*)handle withStream:(NSString*)streamId {
  // should not happen
  if (handle.type == VS_MEDIA_REMOTE) {
    return;
  }
  
  if (handle.stream_state == VS_MEDIA_STREAM_IDLE) {
    [[VSRTC sharedInstance] updateStream:@"0" andCourseStream:@"0"];
  } else if (handle.stream_state == VS_MEDIA_STREAM_STARTED) {
    [[VSRTC sharedInstance] updateStream:handle.stream_id andCourseStream:@"0"];
  } else {
    
  }
}

- (void)OnStreamRestarting:(VSMedia*)handle {
}

- (void)OnStreamFailed:(VSMedia*)handle {
}

@end
