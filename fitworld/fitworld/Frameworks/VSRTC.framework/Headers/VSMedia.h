//
//  VSMedia.h
//  VASDK
//
//  Created by pliu on 21/03/2019.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

#import "VSVideoConfig.h"
#import "VSVideoRender.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, VSMediaType) {
  VS_MEDIA_CAPTURE,
  VS_MEDIA_SCREEN,
  VS_MEDIA_FILE,
  VS_MEDIA_REMOTE,
};

typedef NS_ENUM(NSInteger, VSMediaState) {
  VS_MEDIA_CLOSED,
  VS_MEDIA_OPENING,
  VS_MEDIA_OPENED,
  VS_MEDIA_ERROR,
};

typedef NS_ENUM(NSInteger, VSMediaStreamState) {
  VS_MEDIA_STREAM_IDLE,
  VS_MEDIA_STREAM_STARTING,
  VS_MEDIA_STREAM_STARTED,
  VS_MEDIA_STREAM_RESTARTING,
  VS_MEDIA_STREAM_FAILED,
};

@class VSMedia;
@protocol VSMediaEventHandler <NSObject>
- (void)OnOpening:(VSMedia*)handle;
- (void)OnOpened:(VSMedia*)handle;
- (void)OnClose:(VSMedia*)handle;
- (void)OnError:(VSMedia*)handle withError:(NSString *)errDesc;

- (void)OnStreamIdle:(VSMedia*)handle;
- (void)OnStreamStarting:(VSMedia*)handle;
- (void)OnStreamStarted:(VSMedia*)handle withStream:(NSString *)streamId;
- (void)OnStreamRestarting:(VSMedia*)handle;
- (void)OnStreamFailed:(VSMedia*)handle;
@end

@interface VSMedia : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (NSDictionary*)getStats;

- (uint64_t)mid;
- (NSString *)stream_id;
- (VSMediaType)type;
- (VSMediaState)state;
- (VSMediaStreamState)stream_state;
- (NSString *)stream_label;
- (NSString *)error;
- (long)stream_err;
- (BOOL)has_video;
- (BOOL)has_audio;
- (BOOL)stereo_opus;

- (NSUInteger)recvBitrate;
- (NSUInteger)sendBitrate;
- (NSUInteger)connRtt;
- (NSUInteger)recvAudioDelay;

- (void)SetEventHandler:(id<VSMediaEventHandler>)handler;
- (VSVideoConfig*)QueryVideoConfig;
- (void)BindVideoRender:(VSVideoRender*)render;
- (void)UnbindVideoRender;
- (NSInteger)renderHandle;

- (void)EnableStereoOpus:(BOOL)enable;

- (BOOL)OpenWithVideo:(BOOL)has_video andAudio:(BOOL)has_audio;
- (BOOL)Close;

- (int32_t)StartRecord:(int32_t)dir path:(NSString*)path;
- (int32_t)StopRecord:(int32_t)dir;

- (void)EnableVideo:(BOOL)enable;
- (BOOL)isVideoEnable;
- (void)EnableAudio:(BOOL)enable;
- (BOOL)isAudioEnable;

- (BOOL)Publish:(BOOL)scale streamBitrate:(int)bitrate stramLabel:(NSString*)label;
- (BOOL)Unpublish;
- (BOOL)Subscribe;
- (BOOL)Unsubscribe;
- (void)Restart;

@end

NS_ASSUME_NONNULL_END
