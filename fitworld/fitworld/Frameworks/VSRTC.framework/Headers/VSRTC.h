//
//  VSRTC.h
//  VSVideo
//
//  Created by pliu on 27/05/2018.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VSRoomUser;
@class VSMedia;
@class VSVideoRender;
@class VSChat;

typedef NS_ENUM(NSInteger, VSAudioMode) {
  VS_AUDIO_VOIP,
  VS_AUDIO_MUSIC,
  VS_AUDIO_MUSIC_RAW,
  VS_AUDIO_STEREO_PLAYBACK,
};

@protocol VSRTCDelegate <NSObject>
- (void)onRoomEntry:(NSInteger)memberCount;

- (void)onSessionInit:(VSRoomUser*)session;
- (void)onSessionUpdate:(VSRoomUser*)session;
- (void)onSessionError:(int)errCode andDesc:(NSString *)errMsg;
- (void)onSessionQuit;

- (void)onRoomInfoRefresh:(NSString*)data;

- (void)onMemberJoin:(VSRoomUser*)user;
- (void)onMemberUpdate:(VSRoomUser*)user;
- (void)onMemberLeave:(VSRoomUser*)user;

- (void)onAppMessage:(NSString*)msg;

- (void)onMediaServiceReady;
- (void)onMediaServiceDisconnect;
- (void)onMediaServiceLost;

@end

#define VSV_EXPORT __attribute__((visibility("default")))

VSV_EXPORT
@interface VSRTC : NSObject
+(NSString*)version;
+(int)versionNumber;
+(instancetype) sharedInstance;

- (instancetype)init NS_UNAVAILABLE;
- (void)startup:(NSString*)logUri;
- (void)shutdown;
- (void)setObserver:(id<VSRTCDelegate>)observer;
- (NSString*)eventId;
- (NSInteger)entryMemberCount;

- (void)joinStreaming:(NSString*)vrfUrl completion:(void (^)(NSError *error))block;
- (void)leaveStreaming;

- (void)joinRoomWithApiKey:(NSString*)apiKey
                 andTenant:(NSString*)tenantId
                  andEvent:(NSString*)eventId
                    andRms:(NSString*)rmsUrl
                    andVrx:(NSString*)vrxUrl
                    andIls:(NSString*)ilsUrl
                    andVsu:(NSString*)vsuUrl
                   andUser:(NSString*)userId
                andDisplay:(NSString*)nickName
                 andExtend:(NSDictionary*)info
                  asViewer:(BOOL)isViewer
            andMemberLimit:(NSInteger)memberLimit
                completion:(void (^)(NSError *error))block;
- (void)leaveRoom;

- (BOOL)getMediaServiceMode;
- (void)setMediaServiceMode:(BOOL)isManual;
- (void)connectMediaService:(NSString*)mediaUrl host:(NSString*)entry room:(NSInteger)roomNumber;
- (void)disconnectMediaService;

- (NSString*)getDnsConfigDump;
- (void)applyExternDnsConfigWithVrfHost:(NSString*)vrfHost andUri:(NSString*)uri andUser:(NSString*)user andPwd:(NSString*)pwd andPort:(NSString*)port andOriginIp:(NSString*)originIp andTargetIp:(NSString*)targetIp;
- (void)resetExternDnsConfig;

- (void)configAudioMode:(VSAudioMode)mode andUseSpeaker:(BOOL)use;
- (int)audioSendBitrate;
- (void)setAudioSendBitrate:(int)bitrate;

- (void)updateStream:(NSString*)streamId andCourseStream:(NSString*)courseStreamId;
- (void)updateMicState:(BOOL)mute;
- (void)updateCameraState:(BOOL)blind;
- (void)updateNickName:(NSString*)name;
- (void)updateCustomExtendData:(NSDictionary*)extData;

- (void)updateMember:(NSString*)userId MicState:(BOOL)mute;
- (void)updateMember:(NSString*)userId CameraState:(BOOL)blind;
- (void)updateMember:(NSString*)userId CustomExtendData:(NSDictionary*)extData;

- (void)updateRoomInfo:(NSString*)data;

- (void)sendMessage:(NSString*)msgContent toUser:(NSString*)userId;

- (void)kickUser:(NSString*)userId;

- (NSString*)getRoomId;
- (NSString*)getRoomInfo;
- (NSString*)getRoomAddition;
- (VSRoomUser*)getSession;
- (NSArray*)getMemberList;
- (VSRoomUser*)getMember:(NSString*)uId;

- (VSMedia *)CreateCaptureMediaWithPosition:(BOOL)front andSize:(CGSize)size andFramerate:(int)fps;
- (void)DestroyCaptureMedia;
- (VSMedia *)CreateScreenMedia;
- (void)DestroyScreenMedia;
- (VSMedia *)CreateFileMedia:(NSString *)filePath;
- (void)DestroyFileMedia;

- (VSMedia *)CreateRemoteMedia:(NSString*)streamId;
- (VSMedia *)FindRemoteMedia:(NSString*)streamId;
- (VSMedia *)FindRemoteMediaById:(uint64_t)mediaId;
- (void)DestroyRemoteMedia:(uint64_t)mediaId;
- (NSInteger)remoteMediaCount;

- (VSMedia *)CreateStreamingMedia:(NSString*)mountId;
- (void)DestroyStreamingMedia:(uint64_t)mediaId;

- (void)DestroyAllMedia;

- (VSVideoRender*)CreateVideoRender;

- (VSChat*)CreateChat;
- (void)DestroyChat;

- (void)fakeException:(BOOL)isObjc;

- (void)startFileLog:(NSString*)logPath;
- (void)stopFileLog;

@end
