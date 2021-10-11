#import "ViewerPanel.h"

#import "UIDeps.h"
#import "IJKMediaFrameworkWithSSL/IJKMediaFrameworkWithSSL.h"

@interface ViewerPanel ()
{
}
@property(atomic, retain) id<IJKMediaPlayback> mPlayer;

@end

@implementation ViewerPanel

@synthesize mPlayer;

- (void)dealloc{
  NSLog(@"ViewerPanel dealloc");
}

- (id) init {
  self = [super init];
  
  self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
  
#ifdef DEBUG
  [IJKFFMoviePlayerController setLogReport:YES];
  [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
  [IJKFFMoviePlayerController setLogReport:NO];
  [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif

  return self;
}

- (void)startPlay:(NSString*)url {
  IJKFFOptions *options = [IJKFFOptions optionsByDefault];
  // NOTICE:@stimeout is TCP operation tiemout param,count by microsecond
  //        default value is 5 seconds(5000000)
  [options setFormatOptionValue:@"2000000" forKey:@"stimeout"];
  [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
  
  mPlayer = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url] withOptions:options];
  mPlayer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  mPlayer.view.frame = self.bounds;
  mPlayer.scalingMode = IJKMPMovieScalingModeAspectFit;
  mPlayer.shouldAutoplay = YES;
  [self addSubview:mPlayer.view];
  
  [self installMovieNotificationObservers];
  [mPlayer prepareToPlay];
}

- (void)stopPlay {
  [mPlayer shutdown];
  [self removeMovieNotificationObservers];
  [mPlayer.view removeFromSuperview];
  mPlayer = nil;
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(loadStateDidChange:)
                                               name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                             object:mPlayer];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackDidFinish:)
                                               name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                             object:mPlayer];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(mediaIsPreparedToPlayDidChange:)
                                               name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                             object:mPlayer];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlayBackStateDidChange:)
                                               name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                             object:mPlayer];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
- (void)removeMovieNotificationObservers {
  [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:mPlayer];
  [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:mPlayer];
  [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:mPlayer];
  [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:mPlayer];
  
  [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerVSVideoEvent object:mPlayer];
}

#pragma mark:-观看播放器相关
- (void)loadStateDidChange:(NSNotification*)notification {
  //    MPMovieLoadStateUnknown        = 0,
  //    MPMovieLoadStatePlayable       = 1 << 0,
  //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
  //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
  
  IJKMPMovieLoadState loadState = mPlayer.loadState;
  
  if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
    NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
  } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
    NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
  } else {
    NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
  }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification {
  //    MPMovieFinishReasonPlaybackEnded,
  //    MPMovieFinishReasonPlaybackError,
  //    MPMovieFinishReasonUserExited
  int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
  
  switch (reason)
  {
    case IJKMPMovieFinishReasonPlaybackEnded:
      NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
      break;
      
    case IJKMPMovieFinishReasonUserExited:
      NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
      break;
      
    case IJKMPMovieFinishReasonPlaybackError:
      NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
      break;
      
    default:
      NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
      break;
  }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
  NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
  //    MPMoviePlaybackStateStopped,
  //    MPMoviePlaybackStatePlaying,
  //    MPMoviePlaybackStatePaused,
  //    MPMoviePlaybackStateInterrupted,
  //    MPMoviePlaybackStateSeekingForward,
  //    MPMoviePlaybackStateSeekingBackward
  
  switch (mPlayer.playbackState)
  {
    case IJKMPMoviePlaybackStateStopped: {
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)mPlayer.playbackState);
      break;
    }
    case IJKMPMoviePlaybackStatePlaying: {
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)mPlayer.playbackState);
      break;
    }
    case IJKMPMoviePlaybackStatePaused: {
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)mPlayer.playbackState);
      break;
    }
    case IJKMPMoviePlaybackStateInterrupted: {
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)mPlayer.playbackState);
      break;
    }
    case IJKMPMoviePlaybackStateSeekingForward:
    case IJKMPMoviePlaybackStateSeekingBackward: {
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)mPlayer.playbackState);
      break;
    }
    default: {
      NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)mPlayer.playbackState);
      break;
    }
  }
}

@end
