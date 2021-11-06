#import "RoomVC.h"
#import "../VConductor/Panel/MainPanel.h"
#import "../VConductor/Panel/HeaderPanel.h"
#import "../VConductor/Panel/SidePanel.h"
#import "../VConductor/Panel/ViewerPanel.h"

#import "UIDeps.h"
#import "VConductorClient.h"
#import "ToolFunc.h"

#import "TUIKit.h"

#define LOG_FOLDER        @"Log"

@interface RoomVC () <VConductorClientDelegate> {
}

@property (nonatomic, strong) NSDictionary* mCode;
@property (nonatomic, strong) MBProgressHUD *mHud;

@property (nonatomic, strong) UIImageView* mBkImg;
@property (nonatomic, strong) HeaderPanel *mHeaderPanel;
@property (nonatomic, strong) SidePanel *mSidePanel;
@property (nonatomic, strong) MainPanel* mMainPanel;
@property (nonatomic, strong) ViewerPanel* mViewerPanel;
@property (nonatomic, assign) BOOL mFullScreen;

@end

@implementation RoomVC

@synthesize mCode;
@synthesize mHud;

@synthesize mBkImg;
@synthesize mHeaderPanel;
@synthesize mSidePanel;
@synthesize mMainPanel;
@synthesize mViewerPanel;
@synthesize mFullScreen;

- (id)initWith:(NSDictionary*)code {
  self = [super init];
  mCode = code;
  return self;
}

- (void)dealloc{
  // [[VSRTC sharedInstance] setObserver:nil];
  [mHeaderPanel stopTimer];
  NSLog(@"RoomVC dealloc");
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
  mBkImg = [UIImageView new];
  [mBkImg setImage:[UIImage imageNamed:@"bg_jscn.jpg"]];
  [self.view addSubview:mBkImg];
  [mBkImg mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.and.centerY.equalTo(self.view);
    make.size.equalTo(self.view);
  }];
  
  mHeaderPanel = [HeaderPanel new];
  [self.view addSubview:mHeaderPanel];
  
  mSidePanel = [SidePanel new];
  mSidePanel.layer.cornerRadius = 5;
  mSidePanel.layer.masksToBounds = YES;
  [self.view addSubview:mSidePanel];
  
  mMainPanel = [MainPanel new];
  mMainPanel.layer.cornerRadius = 5;
  mMainPanel.layer.masksToBounds = YES;
  [self.view addSubview:mMainPanel];
  
//  mViewerPanel = [ViewerPanel new];
//  mViewerPanel.layer.cornerRadius = 5;
//  mViewerPanel.layer.masksToBounds = YES;
//  [self.view addSubview:mViewerPanel];
  
  mFullScreen = NO;
  [self layoutPanel];
  
  __weak RoomVC* weakSelf = self;
  mHeaderPanel.pressBtnQuit = ^() {
    RoomVC* strongSelf = weakSelf;
    if (!strongSelf ) {
      return;
    }
    [strongSelf actQuit];
  };
  mHeaderPanel.pressBtnSwitchMode = ^() {
    RoomVC* strongSelf = weakSelf;
    if (!strongSelf ) {
      return;
    }
    [strongSelf actSwitchMode];
  };
  mHeaderPanel.pressBtnHand = ^() {
    RoomVC* strongSelf = weakSelf;
    if (!strongSelf ) {
      return;
    }
    [strongSelf actHand];
  };
  mHeaderPanel.pressBtnMic = ^() {
    RoomVC* strongSelf = weakSelf;
    if (!strongSelf ) {
      return;
    }
    [strongSelf actMic];
  };
  mHeaderPanel.pressBtnCamera = ^() {
    RoomVC* strongSelf = weakSelf;
    if (!strongSelf ) {
      return;
    }
    [strongSelf actCamera];
  };
  mHeaderPanel.pressBtnFullScreen = ^() {
    RoomVC* strongSelf = weakSelf;
    if (!strongSelf ) {
      return;
    }
    [strongSelf actFullScreen];
  };
  
  mMainPanel.viewDoubleTapped = ^{
    RoomVC* strongSelf = weakSelf;
    if (!strongSelf ) {
      return;
    }
    [strongSelf actFullScreen];
  };
  
  mSidePanel.pressBtnChat = ^() {
    RoomVC* strongSelf = weakSelf;
    if (!strongSelf ) {
      return;
    }
    [strongSelf showGroupChatView];
  };
  
  [[VConductorClient sharedInstance] joinwithEntry:VRC_URL andCode:mCode asViewer:NO withDelegate:self];
}

- (void)layoutPanel {
  NSInteger sidePadding = self.mFullScreen ? 0 : 15;
  NSInteger midPadding = self.mFullScreen ? 0 : 5;
  if ([VConductorClient sharedInstance].isViewer) {
    [mHeaderPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view);
      make.left.and.top.equalTo(self.view);
      make.width.equalTo(self.view);
      if (self.mFullScreen) {
        make.height.equalTo(@0);
      } else {
        make.height.equalTo(@90);
      }
    }];
    [mSidePanel mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view.mas_right);
      make.top.equalTo(self.mHeaderPanel.mas_bottom);
      make.width.equalTo(@200);
      make.bottom.equalTo(self.view).offset(-sidePadding);
    }];
    [mMainPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view).offset(sidePadding);
      make.top.equalTo(self.mHeaderPanel.mas_bottom);
      make.right.equalTo(self.mSidePanel.mas_left).offset(-midPadding);
      make.bottom.equalTo(self.mHeaderPanel.mas_bottom);
    }];
    [mViewerPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.view).offset(sidePadding);
      make.top.equalTo(self.mMainPanel.mas_bottom);
      make.right.equalTo(self.mSidePanel.mas_left).offset(-midPadding);
      make.bottom.equalTo(self.view).offset(-sidePadding);
    }];
  } else {
    [mHeaderPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.and.top.equalTo(self.view);
      make.width.equalTo(self.view);
      if (self.mFullScreen) {
        make.height.equalTo(@0);
      } else {
        make.height.equalTo(@90);
      }
    }];
    
      [mMainPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.left.right.equalTo(self.view).offset(sidePadding);
          make.right.equalTo(self.view).offset(-sidePadding);
          make.top.equalTo(self.mHeaderPanel.mas_bottom);
          make.height.equalTo(self.view).multipliedBy(0.3);
      }];
      
      [mSidePanel mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.left.right.equalTo(self.view).offset(sidePadding);
          make.right.equalTo(self.view).offset(-sidePadding);
          make.top.equalTo(self.mMainPanel.mas_bottom).offset(sidePadding);
          make.bottom.equalTo(self.view).offset(-sidePadding);
      }];
      
//    [mViewerPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
//      make.left.equalTo(self.view).offset(sidePadding);
//      make.top.equalTo(self.mMainPanel.mas_bottom);
//      make.right.equalTo(self.mSidePanel.mas_left).offset(-midPadding);
//      make.bottom.equalTo(self.view).offset(-sidePadding);
//    }];
  }
  
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.navigationController.navigationBar.hidden = NO;
};

- (void)viewDidAppear:(BOOL)animated {
  [UIApplication sharedApplication].idleTimerDisabled = YES;
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  [UIApplication sharedApplication].idleTimerDisabled = NO;
  [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [super viewDidDisappear:animated];

    [self actQuit];
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)actQuit {
  [[VConductorClient sharedInstance] leave];
}

- (void)actSwitchMode {
  if (![VConductorClient sharedInstance].canSwitchViewerMode) {
    [self showHud:@"该课程未启用转播" withDuration:3];
    return;
  }
  [[VConductorClient sharedInstance] requestSwitchViewerMode];
}

- (void)actHand {
  BOOL isHandup = [[VConductorClient sharedInstance] isHandup];
  [[VConductorClient sharedInstance] requestHandup:!isHandup];
}

- (void)actMic {
  BOOL isAudioEnable = [[VConductorClient sharedInstance] isAudioEnable];
  [[VConductorClient sharedInstance] enableAudio:!isAudioEnable];
}

- (void)actCamera {
  BOOL isVideoEnable = [[VConductorClient sharedInstance] isVideoEnable];
  [[VConductorClient sharedInstance] enableVideo:!isVideoEnable];
}

- (void)actFullScreen {
  mFullScreen = !mFullScreen;
  [self layoutPanel];
}

- (void)onJoinRoomLoading {
  [self showHud:@"正在加入..." withDuration:0];
}

- (void)onJoinRoomSuccess {
  [self hideHud];
  
}

- (void)onJoinRoomFailed:(NSString *)error {
  [self hideHud];
  [self showHud:error withDuration:3];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)onLostRoomWithCode:(NSInteger)code andError:(NSString*)err {
  [self showHud:@"您已离开房间" withDuration:3];
}

- (void)onLeaveRom {
  [mSidePanel detachLocalView];
  [mMainPanel detachLocalView];
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRoomUpdate:(ClassRoom*)room {
  [mHeaderPanel setRoomTitle:room.roomTitle];
  [mMainPanel setLectureLayout:(room.playoutLayout == PLAYOUT_LAYOUT_LECTURE)];
}

- (void)onSessionUpdate:(ClassMember*)session withViewerModeChanged:(BOOL)modeChanged {
  [mHeaderPanel syncSession:session];
  [mSidePanel syncSession:session];
  
  if (session.isViewer) {
    [mSidePanel detachLocalView];
    [mMainPanel detachLocalView];
  } else {
    if (session.group == CLASS_GROUP_GUEST_ONAIR) {
      [mSidePanel detachLocalView];
      [mMainPanel attachLocalView];
    } else {
      [mMainPanel detachLocalView];
      [mSidePanel attachLocalView];
    }
  }
  
  if (modeChanged) {
    [self layoutPanel];
    [mMainPanel syncRemoteView];
    if ([VConductorClient sharedInstance].isViewer) {
      NSString *liveUrl = [[VConductorClient sharedInstance] getViewerUrl];
      [mViewerPanel startPlay:liveUrl];
    } else {
      [mViewerPanel stopPlay];
    }
  }
}

- (void)onTick {
  [mMainPanel syncRemoteView];
}

- (void)showGroupChatView {
  TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
//  data.groupID = [[VConductorClient sharedInstance] getImGroupId];  // 如果是群会话，传入对应的群 ID
  TUIChatController *vc = [[TUIChatController alloc] initWithConversation:data];
  
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)showHud:(NSString*)msg withDuration:(NSInteger)delay {
  mHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  mHud.mode = MBProgressHUDModeText;
  mHud.label.text = msg;
  mHud.removeFromSuperViewOnHide = YES;
  mHud.backgroundView.hidden = YES;
  [mHud showAnimated:YES];
  if (delay != 0) {
    [mHud hideAnimated:YES afterDelay:delay];
  }
}

- (void)hideHud {
  [mHud hideAnimated:YES];
}

- (void)shareLog {
  NSString *fileName = [[NSProcessInfo processInfo] globallyUniqueString];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString* logDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:LOG_FOLDER];
  if (![[NSFileManager defaultManager] fileExistsAtPath:logDir isDirectory:nil]){
    [[NSFileManager defaultManager] createDirectoryAtPath:logDir withIntermediateDirectories:YES attributes:nil error:nil];
  }
  
  NSString *logFilePath = [logDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",fileName]];
  
  // [[VSRTC sharedInstance] startFileLog:self.logFilePath];
  // [[VSRTC sharedInstance] stopFileLog];
  
  //在iOS 11不显示分享选项了
  //定义URL数组
  NSArray *urls=@[[ NSURL fileURLWithPath:logFilePath]];
  //创建分享的类型,注意这里没有常见的微信,朋友圈以QQ等,但是罗列完后,实际运行是相应按钮的,所以可以运行.
  
  UIActivityViewController *activituVC=[[UIActivityViewController alloc]initWithActivityItems:urls applicationActivities:nil];
  NSArray *cludeActivitys = @[UIActivityTypePostToFacebook,
                              UIActivityTypePostToTwitter,
                              UIActivityTypePostToWeibo,
                              UIActivityTypePostToVimeo,
                              UIActivityTypeMessage,
                              UIActivityTypeMail,
                              UIActivityTypeCopyToPasteboard,
                              UIActivityTypePrint,
                              UIActivityTypeAssignToContact,
                              UIActivityTypeSaveToCameraRoll,
                              UIActivityTypeAddToReadingList,
                              UIActivityTypePostToFlickr,
                              UIActivityTypePostToTencentWeibo];
  activituVC.excludedActivityTypes = cludeActivitys;
  
  //显示分享窗口
  [self presentViewController:activituVC animated:YES completion:nil];
}

@end
