#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

#import "ClassRoom.h"
#import "ClassMember.h"
//#import "VSRTC/VSVideoRender.h"
#import <VSRTC/VSVideoRender.h>

#define VRC_URL   @"https://vrc.poc.videosolar.com"

NS_ASSUME_NONNULL_BEGIN

@protocol VConductorClientDelegate <NSObject>
- (void)onJoinRoomLoading;
- (void)onJoinRoomSuccess;
- (void)onJoinRoomFailed:(NSString *)error;
- (void)onLostRoomWithCode:(NSInteger)code andError:(NSString*)err;
- (void)onLeaveRom;

- (void)onRoomUpdate:(ClassRoom*)room;
- (void)onSessionUpdate:(ClassMember*)session withViewerModeChanged:(BOOL)modeChanged;
- (void)onTick;

- (void)showHud:(NSString*)msg withDuration:(NSInteger)delay;
- (void)hideHud;
@end

@interface VConductorClient : NSObject
@property (readonly, strong) NSString* mVrcToken;


+ (instancetype)sharedInstance;
- (id)init NS_UNAVAILABLE;

- (void)initSDK;
- (NSString*)sdkVersion;

- (void)joinwithEntry:(NSString*)vrcUrl andCode:(NSDictionary*)codeDic asViewer:(BOOL)isViewer withDelegate:(id<VConductorClientDelegate>)delegate;
- (void)leave;

- (BOOL)isViewer;
- (BOOL)canSwitchViewerMode;
- (void)requestSwitchViewerMode;
- (NSString*)getViewerUrl;

- (VSVideoRender*)createVideoRender;
- (void)destroyVideoRender:(VSVideoRender*)videoRender;

- (ClassMember*)getMySession; //自己
- (ClassMember*)getHostMember; //老师 / 教练

- (NSInteger)getElapsedSeconds;

- (PlayoutLayoutMode)memberLayoutMode;

- (NSDictionary*)getOnAirMembers;
- (BOOL)isMemberOnAir:(NSString*)userId;

- (void)bindLocalVideoRender:(VSVideoRender*)render;
- (void)unbindLocalVideoRender:(VSVideoRender*)render;

- (void)bindMainVideoRender:(VSVideoRender*)render ofUser:(NSString*)userId;
- (void)unbindMainVideoRender:(VSVideoRender*)render ofUser:(NSString*)userId;
- (void)bindShareVideoRender:(VSVideoRender*)render ofUser:(NSString*)userId;
- (void)unbindShareVideoRender:(VSVideoRender*)render ofUser:(NSString*)userId;

- (void)enableVideo:(BOOL)enable;
- (BOOL)isVideoEnable;
- (void)enableAudio:(BOOL)enable;
- (BOOL)isAudioEnable;

- (void)requestHandup:(BOOL)up;
- (BOOL)isHandup;

- (NSString*)getImGroupId;
@end

NS_ASSUME_NONNULL_END
