#import "HeaderPanel.h"

#import "VConductorClient.h"
#import "UIDeps.h"

@interface HeaderPanel () {
}
@property (nonatomic, assign) BOOL mViewerMode;
@property (nonatomic, strong) UIButton* mBtnSwitchMode;
@property (nonatomic, strong) UIImageView* mLogo;
@property (nonatomic, strong) UILabel* mTitle;
@property (nonatomic, strong) UILabel* mTimer;
@property (nonatomic, strong) UIButton* mBtnFullScreen;
@property (nonatomic, strong) UIButton* mBtnCamera;
@property (nonatomic, strong) UIButton* mBtnMic;
@property (nonatomic, strong) UIButton* mBtnHand;
@property (nonatomic, strong) UIButton* mBtnQuit;

@property (nonatomic, strong) NSTimer *mElapseTimer;
@end

@implementation HeaderPanel

@synthesize mViewerMode;
@synthesize mBtnSwitchMode;
@synthesize mLogo;
@synthesize mTitle;
@synthesize mTimer;
@synthesize mBtnFullScreen;
@synthesize mBtnCamera;
@synthesize mBtnMic;
@synthesize mBtnHand;
@synthesize mBtnQuit;

@synthesize mElapseTimer;

- (void)dealloc{
  NSLog(@"HeaderPanel dealloc");
}

- (id) init {
  self = [super init];
  
  mViewerMode = NO;
  
  mLogo = [UIImageView new];
  [mLogo setImage:[UIImage imageNamed:@"header_logo_jscn"]];
  [self addSubview:mLogo];
  [mLogo mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(35);
    make.bottom.equalTo(self).offset(-10);
    make.height.equalTo(self).multipliedBy(0.6);
    make.width.equalTo(self.mLogo.mas_height).multipliedBy(5.375);
  }];
  mLogo.contentMode = UIViewContentModeScaleAspectFit;
  mLogo.hidden = YES;
  
  mTitle = [UILabel new];
  [self addSubview:mTitle];
  [mTitle mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self).offset(35);
    make.top.equalTo(self).offset(10);
    make.height.equalTo(self).multipliedBy(0.6);
    make.width.equalTo(self).multipliedBy(0.5);
  }];
  mTitle.font = [UIFont boldSystemFontOfSize:22];
  
  mTimer = [UILabel new];
  [self addSubview:mTimer];
  [mTimer mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.mTitle);
    make.top.equalTo(self.mTitle.mas_bottom).offset(2);
    make.bottom.equalTo(self).offset(-10);
    make.width.equalTo(self.mTitle);
  }];
  mTimer.font = [UIFont systemFontOfSize:16];
  mTimer.textColor = [UIColor greenColor];
  
  mBtnSwitchMode = [UIButton new];
  [self addSubview:mBtnSwitchMode];
  [mBtnSwitchMode addTarget:self action:@selector(onSwitchModeClicked) forControlEvents:UIControlEventTouchUpInside ];
  
  mBtnQuit = [UIButton new];
  [self addSubview:mBtnQuit];
  [mBtnQuit addTarget:self action:@selector(onQuitClicked) forControlEvents:UIControlEventTouchUpInside ];
  [mBtnQuit setImage:[UIImage imageNamed:@"header_quit"] forState:UIControlStateNormal];
  
  mBtnHand = [UIButton new];
  [self addSubview:mBtnHand];
  [mBtnHand addTarget:self action:@selector(onHandClicked) forControlEvents:UIControlEventTouchUpInside ];
  [mBtnHand setImage:[UIImage imageNamed:@"header_hand"] forState:UIControlStateNormal];
  
  mBtnMic = [UIButton new];
  [self addSubview:mBtnMic];
  [mBtnMic addTarget:self action:@selector(onMicClicked) forControlEvents:UIControlEventTouchUpInside ];
  [mBtnMic setImage:[UIImage imageNamed:@"header_mic_on"] forState:UIControlStateNormal];
  
  mBtnCamera = [UIButton new];
  [self addSubview:mBtnCamera];
  [mBtnCamera addTarget:self action:@selector(onCameraClicked) forControlEvents:UIControlEventTouchUpInside ];
  [mBtnCamera setImage:[UIImage imageNamed:@"header_camera_on"] forState:UIControlStateNormal];
  
  mBtnFullScreen = [UIButton new];
  [self addSubview:mBtnFullScreen];
  [mBtnFullScreen addTarget:self action:@selector(onFullScreenClicked) forControlEvents:UIControlEventTouchUpInside ];
  [mBtnFullScreen setImage:[UIImage imageNamed:@"header_fullscreen"] forState:UIControlStateNormal];
  
  [self syncLayout];
  
  mElapseTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(refreshElapseTime)
                                            userInfo:nil
                                             repeats:YES];
  
  return self;
}

- (void)stopTimer {
  [mElapseTimer invalidate];
  mElapseTimer = nil;
}

-(void)refreshElapseTime {
  NSInteger elapsedSecs = VConductorClient.sharedInstance.getElapsedSeconds;
  
  NSInteger secondsNumber = elapsedSecs % 60;
  NSInteger minuteNumber = (elapsedSecs - secondsNumber) / 60 % 60;
  NSInteger hourNumber = ((elapsedSecs - secondsNumber) / 60 - minuteNumber) / 60 % 24;
  NSString *timeCode = [NSString stringWithFormat:@"时长: %.2d:%.2d:%.2d", hourNumber, minuteNumber, secondsNumber];
  mTimer.text = timeCode;
}

- (void)setRoomTitle:(NSString*)title {
  mTitle.text = title;
}

- (void)syncSession:(ClassMember*)session {
  if (session.isCameraBlind) {
    [mBtnCamera setImage:[UIImage imageNamed:@"header_camera_off"] forState:UIControlStateNormal];
  } else {
    [mBtnCamera setImage:[UIImage imageNamed:@"header_camera_on"] forState:UIControlStateNormal];
  }
  if (session.isMicMuted) {
    [mBtnMic setImage:[UIImage imageNamed:@"header_mic_off"] forState:UIControlStateNormal];
  } else {
    [mBtnMic setImage:[UIImage imageNamed:@"header_mic_on"] forState:UIControlStateNormal];
  }
  if (session.isHandup) {
    [mBtnHand setImage:[UIImage imageNamed:@"header_hand_up"] forState:UIControlStateNormal];
  } else {
    [mBtnHand setImage:[UIImage imageNamed:@"header_hand"] forState:UIControlStateNormal];
  }
  if (session.isViewer != mViewerMode) {
    mViewerMode = session.isViewer;
    [self syncLayout];
  }
}


- (void)syncLayout {
  if (mViewerMode) {
    [mBtnQuit mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self).offset(-20);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
    [mBtnSwitchMode mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.mBtnQuit.mas_left).offset(-10);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
    [mBtnSwitchMode setImage:[UIImage imageNamed:@"header_mode_live"] forState:UIControlStateNormal];
    
    [mBtnHand mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.mas_right).offset(10);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
    [mBtnMic mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.mBtnHand.mas_right).offset(-10);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
    [mBtnCamera mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.mBtnMic.mas_right).offset(-10);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
    [mBtnFullScreen mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.mBtnCamera.mas_right).offset(-10);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
  } else {
    [mBtnQuit mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self).offset(-20);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
    /*
    [mBtnSwitchMode mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.mBtnQuit.mas_left).offset(-10);
      make.bottom.equalTo(self).offset(-5);
      make.width.equalTo(@50);
      make.height.equalTo(@50);
    }];
    [mBtnSwitchMode setImage:[UIImage imageNamed:@"header_mode_rtc"] forState:UIControlStateNormal];
    */
    [mBtnHand mas_remakeConstraints:^(MASConstraintMaker *make) {
      //make.right.equalTo(self.mBtnSwitchMode.mas_left).offset(-10);
      make.right.equalTo(self.mBtnQuit.mas_left).offset(-10);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
    [mBtnMic mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.mBtnHand.mas_left).offset(-10);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
    [mBtnCamera mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.mBtnMic.mas_left).offset(-10);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
    [mBtnFullScreen mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.mBtnCamera.mas_left).offset(-10);
      make.bottom.equalTo(self).offset(-10);
      make.width.equalTo(@40);
      make.height.equalTo(@40);
    }];
  }
  
  [UIView animateWithDuration:0.3 animations:^{
    [self layoutIfNeeded];
  }];
}

- (void)onSwitchModeClicked {
  if (self.pressBtnSwitchMode) {
    self.pressBtnSwitchMode();
  }
}

- (void)onQuitClicked {
  if (self.pressBtnQuit) {
    self.pressBtnQuit();
  }
}

- (void)onHandClicked {
  if (self.pressBtnHand) {
    self.pressBtnHand();
  }
}

- (void)onMicClicked {
  if (self.pressBtnMic) {
    self.pressBtnMic();
  }
}

- (void)onCameraClicked {
  if (self.pressBtnCamera) {
    self.pressBtnCamera();
  }
}

- (void)onFullScreenClicked {
  if (self.pressBtnFullScreen) {
    self.pressBtnFullScreen();
  }
}

@end
