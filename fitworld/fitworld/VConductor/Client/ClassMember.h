//
//  ClassMember.h
//  VConductor
//
//  Created by pliu on 20210129.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

#import <VSRTC/VSRoomUser.h>
#import "VSRTC/VSVideoRender.h"

typedef NS_ENUM(NSInteger, ClassGroup) {
  CLASS_GROUP_HOST,
  CLASS_GROUP_HOST_ONAIR,
  CLASS_GROUP_GUEST,
  CLASS_GROUP_GUEST_ONAIR,
  CLASS_GROUP_VIEWER,
};

@interface ClassMember : NSObject
@property (nonatomic, strong) VSRoomUser* mBaseInfo;

@property (nonatomic, strong) VSMedia* mLocalMedia;
@property (nonatomic, strong) VSMedia* mMainMedia;
@property (nonatomic, strong) VSMedia* mShareMedia;

- (void)syncInfo:(ClassMember*)member;
- (VSRoomUser*)copyInfo;

- (NSString *)userId;
- (NSString *)nickName;
- (BOOL)isCameraBlind;
- (BOOL)isMicMuted;
- (BOOL)isHandup;
- (BOOL)isHost;
- (BOOL)isGuest;
- (BOOL)isViewer;
- (ClassGroup)group;

- (BOOL)hasStream;
- (BOOL)hasShareStream;
- (BOOL)isSharing;

- (void)openLocalMedia;
- (void)closeLocalMedia;

- (void)enableLocalVideo:(BOOL)enable;
- (BOOL)isLocalVideoEnable;
- (void)enableLocalAudio:(BOOL)enable;
- (BOOL)isLocalAudioEnable;

//有数据流 就认为是一个合法的用户
- (BOOL)iscanvisible;

//教练视频的操作
- (void)enableHostVideo:(BOOL)enable;
- (BOOL)isHostVideoEnable;
- (void)enableHostAudio:(BOOL)enable;
- (BOOL)isHostAudioEnable;

- (void)checkStream;
- (void)checkShareStream:(BOOL)allowShare;
- (void)closeStream;
- (void)closeShareStream;

- (void)bindLocalVideoRender:(VSVideoRender*)render;
- (void)unbindLocalVideoRender:(VSVideoRender*)render;

- (void)bindMainVideoRender:(VSVideoRender*)render;
- (void)unbindMainVideoRender:(VSVideoRender*)render;

- (void)bindShareVideoRender:(VSVideoRender*)render;
- (void)unbindShareVideoRender:(VSVideoRender*)render;

//是否正在推流 是否正在直播
- (BOOL)isonTheAir;


//获取教练端的声音大小和设置
- (void)SetMainVolume:(float)volume;
- (float)GetMainVolume;

 
@end

