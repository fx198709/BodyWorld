#import "RoomVC.h"

#import "MainPanel.h"
#import "HeaderPanel.h"
#import "SidePanel.h"
#import "ViewerPanel.h"
#import "GuestPanel.h"
#import "UIDeps.h"
#import "VConductorClient.h"
#import "ToolFunc.h"

#import "TUIKit.h"
#import "AfterTrainingViewController.h"
#import "RoomVCSettingView.h"
#import "SliderView.h"

#define LOG_FOLDER        @"Log"

@interface RoomVC () <VConductorClientDelegate> {
    BOOL canErrorToPOP;//进入房间失败，就可以pop出去
    BOOL needShowOthersVideo;//是否展示其他人的视频  免打扰
    NSTimer *roomTimer;  //定时器，用来刷新时间的
    SliderView *currentSlider;//滑块
    BOOL hasStartLiving;// 开始直播了
    UILabel *startDuringTimeLabel;//开始了多久 //long diff = currentTime- room.start_time;
    UIButton *voiceBtn;// 头上视频的声音
    UILabel *vtitleLabel;//title 文件
    BOOL headHasVoice;//头部的有声音
    UIButton *settingBtn;//设置按钮
    
    BOOL createRoomLiving;//已经开始直播
    UILabel *leftTimeLabel;
    UIView *leftTimeBackview;
    RoomVCSettingView * settingView;//设置视图
}

@property (nonatomic, strong) NSDictionary* mCode;
@property (nonatomic, strong) MBProgressHUD *mHud;

@property (nonatomic, strong) UIImageView* mBkImg;
//@property (nonatomic, strong) HeaderPanel *mHeaderPanel; //头部的信息和操作
@property (nonatomic, strong) SidePanel *mSidePanel;
@property (nonatomic, strong) MainPanel* mMainPanel;
@property (nonatomic, strong) ViewerPanel* mViewerPanel;
@property (nonatomic, strong) NSMutableArray* guestPanels;
@property (nonatomic, assign) BOOL mFullScreen;

@property (nonatomic, strong) UIView *bottomPanelView;

@end

@implementation RoomVC

@synthesize mCode;
@synthesize mHud;

@synthesize mBkImg;
//@synthesize mHeaderPanel;
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
    //    [mHeaderPanel stopTimer];
    NSLog(@"RoomVC dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    canErrorToPOP = YES;
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(guestMemberChangetoView) name:@"GuestMemberChange" object:nil];
    _guestPanels = [NSMutableArray array];
    mBkImg = [UIImageView new];
    [mBkImg setImage:[UIImage imageNamed:@"bg_jscn.jpg"]];
    [self.view addSubview:mBkImg];
    [mBkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    
    
    settingView = [[[NSBundle mainBundle] loadNibNamed:@"RoomVCSettingView" owner:self options:nil] lastObject];
    
    //    mHeaderPanel = [HeaderPanel new];
    //    [self.view addSubview:mHeaderPanel];
    
    _bottomPanelView = [[UIView alloc] init];
    [self.view addSubview:_bottomPanelView];
    
    mSidePanel = [SidePanel new];
    mSidePanel.layer.cornerRadius = 5;
    mSidePanel.layer.masksToBounds = YES;
    [_bottomPanelView addSubview:mSidePanel];
    
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
    //    mHeaderPanel.pressBtnQuit = ^() {
    //        RoomVC* strongSelf = weakSelf;
    //        if (!strongSelf ) {
    //            return;
    //        }
    //        [strongSelf actQuit];
    //    };
    //    mHeaderPanel.pressBtnSwitchMode = ^() {
    //        RoomVC* strongSelf = weakSelf;
    //        if (!strongSelf ) {
    //            return;
    //        }
    //        [strongSelf actSwitchMode];
    //    };
    //    mHeaderPanel.pressBtnHand = ^() {
    //        RoomVC* strongSelf = weakSelf;
    //        if (!strongSelf ) {
    //            return;
    //        }
    //        [strongSelf actHand];
    //    };
    //    mHeaderPanel.pressBtnMic = ^() {
    //        RoomVC* strongSelf = weakSelf;
    //        if (!strongSelf ) {
    //            return;
    //        }
    //        [strongSelf actMic];
    //    };
    //    mHeaderPanel.pressBtnCamera = ^() {
    //        RoomVC* strongSelf = weakSelf;
    //        if (!strongSelf ) {
    //            return;
    //        }
    //        [strongSelf actCamera];
    //    };
    //    mHeaderPanel.pressBtnFullScreen = ^() {
    //        RoomVC* strongSelf = weakSelf;
    //        if (!strongSelf ) {
    //            return;
    //        }
    //        [strongSelf actFullScreen];
    //    };
    
    mMainPanel.viewDoubleTapped = ^{
        RoomVC* strongSelf = weakSelf;
        if (!strongSelf ) {
            return;
        }
        //        全屏
        //        [strongSelf actFullScreen];
    };
    
    mSidePanel.pressBtnChat = ^() {
        RoomVC* strongSelf = weakSelf;
        if (!strongSelf ) {
            return;
        }
        //        [strongSelf showGroupChatView];
    };
    
    //    进入房间
    [self joinStateRequest:YES success:^{
        
    }];
    [self reachRoomDetailInfo];
}

#pragma mark 设置所有的视图的视频
- (void)layoutPanel {
    if ([VConductorClient sharedInstance].isViewer) {
        //        [mHeaderPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.and.top.equalTo(self.view);
        //            make.width.equalTo(self.view);
        //            if (self.mFullScreen) {
        //                make.height.equalTo(@0);
        //            } else {
        //                make.height.equalTo(@90);
        //            }
        //        }];
        //        [mSidePanel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.view.mas_right);
        //            make.top.equalTo(self.mHeaderPanel.mas_bottom);
        //            make.width.equalTo(@200);
        //            make.bottom.equalTo(self.view).offset(-sidePadding);
        //        }];
        //        [mMainPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.view).offset(sidePadding);
        //            make.top.equalTo(self.mHeaderPanel.mas_bottom);
        //            make.right.equalTo(self.mSidePanel.mas_left).offset(-midPadding);
        //            make.bottom.equalTo(self.mHeaderPanel.mas_bottom);
        //        }];
        //        [mViewerPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.equalTo(self.view).offset(sidePadding);
        //            make.top.equalTo(self.mMainPanel.mas_bottom);
        //            make.right.equalTo(self.mSidePanel.mas_left).offset(-midPadding);
        //            make.bottom.equalTo(self.view).offset(-sidePadding);
        //        }];
        //        [UIView animateWithDuration:0.3 animations:^{
        //            [self.view layoutIfNeeded];
        //        }];
    } else {
        [mMainPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.height.equalTo(self.view).multipliedBy(0.4);
        }];
        
        [_bottomPanelView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.mMainPanel.mas_bottom).offset(5);
            make.bottom.equalTo(self.view);
        }];
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        WeakSelf
        [UIView animateWithDuration:0.3 animations:^{
            //    获取所有的成员列表
            StrongSelf(wSelf);
            CGRect bottomframe = self->_bottomPanelView.frame;
            VConductorClient *client = [VConductorClient sharedInstance];
            NSDictionary * memberDic = [client getGustMemberData];
            //            拷贝一份key出来 这边的key就是userID
            NSMutableArray *keysArray = [[NSMutableArray alloc] initWithArray:memberDic.allKeys];
            int  guestPanelscount = (int)self.guestPanels.count;
            for (int  i = guestPanelscount -1; i>= 0;i--) {
                GuestPanel * guestpanel = [strongSelf.guestPanels objectAtIndex:i];
                //                    假如这个view 存在于原来的视图里面
                ClassMember *currentMember = [memberDic objectForKey:guestpanel.mUserId];
                //                id存在数组中，并且正在直播
                if ([keysArray containsObject:guestpanel.mUserId] && [currentMember isonTheAir]) {
                    //                        存在，视图不需要处理，还保存着  userID数组里面，需要删除
                    [keysArray removeObject:guestpanel.mUserId];
                }else{
                    //                        用户id不存在，需要把原来的删除
                    [guestpanel detachGuestRenderView];
                    [guestpanel removeFromSuperview];
                    [strongSelf.guestPanels removeObject:guestpanel];
                }
            }
//            还有没有添加进入的人员
            if (keysArray.count > 0) {
                for (NSString *userID in keysArray) {
                    //                    ClassMember *currentMember = [memberDic objectForKey:userID];
                    //                    if ([currentMember isonTheAir]) {
                    if (strongSelf.guestPanels.count < 5) {
//                        游客小于5个，这边才用
                        GuestPanel * guestpanel = [[GuestPanel alloc] init];
                        guestpanel.mUserId = userID;
                        [strongSelf.guestPanels addObject:guestpanel];
                        [self->_bottomPanelView addSubview:guestpanel];
                        [guestpanel attachGuestRenderView];
                        ClassMember *currentMember = [memberDic objectForKey:guestpanel.mUserId];
                        if ([[currentMember copyInfo].custom objectForKey:@"internal"]) {
                            guestpanel.mMyLabel.text = [[[currentMember copyInfo].custom objectForKey:@"internal"] objectForKey:@"nickName"];
                            
                        }
                        guestpanel.translatesAutoresizingMaskIntoConstraints =  YES;
                    }
                   
                    //
                }
            }
            int showguestcount = self.guestPanels.count;
            if (showguestcount == 0) {
                //        清楚所有的直播
                self->mSidePanel.frame = CGRectMake(0, 0, bottomframe.size.width, bottomframe.size.height);
                
            }else{
                if (showguestcount == 1){
                    //            一行两个
                    self->mSidePanel.frame = CGRectMake(0, 0, bottomframe.size.width/2, bottomframe.size.height);
                    GuestPanel * guestpanel = [strongSelf.guestPanels objectAtIndex:0];
                    guestpanel.frame = CGRectMake(bottomframe.size.width/2, 0, bottomframe.size.width/2, bottomframe.size.height);
                }else if (showguestcount == 3 || showguestcount == 2){
                    //            一行2个
                    self->mSidePanel.frame = CGRectMake(0, 0, bottomframe.size.width/2, bottomframe.size.height/2);
                    for (int index = 0; index < strongSelf.guestPanels.count; index++) {
                        GuestPanel * guestpanel = [strongSelf.guestPanels objectAtIndex:index];
                        CGFloat startX = index%2 == 0 ? bottomframe.size.width/2:0;
                        CGFloat startY = index > 0? bottomframe.size.height/2:0;
                        guestpanel.frame = CGRectMake(startX, startY, bottomframe.size.width/2, bottomframe.size.height/2);
                        
                    }
                    
                } else{
                    //            一行3个 2行
                    self->mSidePanel.frame = CGRectMake(0, 0, bottomframe.size.width/3, bottomframe.size.height/2);
                    for (int index = 0; index < strongSelf.guestPanels.count && index < 5; index++) {
                        GuestPanel * guestpanel = [strongSelf.guestPanels objectAtIndex:index];
                        CGFloat startX = bottomframe.size.width/3*((index+1)%3);
                        CGFloat startY = index > 1? bottomframe.size.height/2:0;
                        guestpanel.frame = CGRectMake(startX, startY, bottomframe.size.width/3, bottomframe.size.height/2);
                        
                    }
                }
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
};

- (void)viewDidAppear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [super viewDidAppear:animated];
    //   创建右侧的按钮
    //    appear  startDuringTimeLabel
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [super viewWillDisappear:animated];
}


- (void)viewDidDisappear:(BOOL)animated{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [super viewDidDisappear:animated];
    if (roomTimer) {
        [roomTimer invalidate];
        roomTimer = nil;
    }
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
//挂断
- (void)actHand {
    BOOL isHandup = [[VConductorClient sharedInstance] isHandup];
    [[VConductorClient sharedInstance] requestHandup:!isHandup];
}
//关闭声音
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
    if (canErrorToPOP) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onLostRoomWithCode:(NSInteger)code andError:(NSString*)err {
    [self showHud:@"您已离开房间" withDuration:3];
}

- (void)onLeaveRom {
    [mSidePanel detachLocalView];
    [mMainPanel detachLocalView];
    if (canErrorToPOP) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onRoomUpdate:(ClassRoom*)room {
    //    [mHeaderPanel setRoomTitle:room.roomTitle];
    [mMainPanel setLectureLayout:(room.playoutLayout == PLAYOUT_LAYOUT_LECTURE)];
}

- (void)onSessionUpdate:(ClassMember*)session withViewerModeChanged:(BOOL)modeChanged {
    //    [mHeaderPanel syncSession:session];
    //    有流过来了，表示开始直播了
    hasStartLiving = YES;
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

//改变成员
- (void)guestMemberChangetoView{
    [self layoutPanel];
    
}

//设置导航栏左边按钮
- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-150, 40)];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backview addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPopViewcontroller:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    imageview.image = [UIImage imageNamed:@"back_white"];
    [backview addSubview:imageview];

    vtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, ScreenWidth-150-20-60, 20)];
    [backview addSubview:vtitleLabel];
    vtitleLabel.textColor = UIColor.whiteColor;
    
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backview];
    return leftBtnItem;
}


- (void)backPopViewcontroller:(id) sender
{
    //    [self.navigationController popViewControllerAnimated:YES];
    NSString *titleString = ChineseStringOrENFun(@"提示", @"Alert");
    NSString *contentString = ChineseStringOrENFun(@"你将退出此次课程，确认退出吗？", @"");
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:titleString message:contentString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertControl addAction:cancelAction];
    __weak UIAlertController *weakalert = alertControl;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        __strong UIAlertController* strongalert = weakalert;
        [self leaveToSuccessview:strongalert];
    }];
    [alertControl addAction:sureAction];
    [self presentViewController:alertControl animated:YES completion:nil];
    
}

- (void)leaveToSuccessview:(UIAlertController*)alertControl{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self joinStateRequest:NO success:^{
        [alertControl dismissViewControllerAnimated:YES completion:nil];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            //             跳转到健身完成页面
            self->canErrorToPOP = NO;
            [self jumpToTrainingvc];
        });
    }];
}

- (void)joinStateRequest:(BOOL)isJoin success:(void(^)(void))successBlock{
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    
    NSDictionary *baddyParams = @{
        @"event_id": mCode[@"eid"],
        @"is_join":[NSNumber numberWithBool:isJoin]
    };
    [manager POST:@"practise/join" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (successBlock) {
            successBlock();
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (successBlock) {
            successBlock();
        }
    }];
}
#pragma mark  获取详情，开启定时器

//更新进度条
- (void)startTimer{
    if (!roomTimer) {
        roomTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dealwithTimer) userInfo:nil repeats:YES];
        
    }
}

- (void)dealwithTimer{
//    判断开始没有
//    还没开始，需要设置倒计时
    long dif = self.currentRoom.start_time- [[NSDate date] timeIntervalSince1970];
    if (dif>0) {
        if (!leftTimeLabel) {
            leftTimeBackview = [[UIView alloc] init];
            [mMainPanel addSubview:leftTimeBackview];
            [leftTimeBackview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(mMainPanel);
                make.left.top.equalTo(mMainPanel);
            }];
            leftTimeBackview.backgroundColor = UIColor.blackColor;
            leftTimeLabel = [[UILabel alloc] init];
            [leftTimeBackview addSubview:leftTimeLabel];
            [leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(leftTimeBackview);
            }];
            leftTimeLabel.font = [UIFont boldSystemFontOfSize:80];
            leftTimeLabel.textColor = UIRGBColor(48, 180, 90, 1);
        }
        leftTimeLabel.text = [NSString stringWithFormat:@"%ld",dif];
        return;
    }else{
        if (leftTimeBackview) {
            [leftTimeBackview removeFromSuperview];
        }
        if (!createRoomLiving) {
            createRoomLiving = YES;
//            开启直播
            [[VConductorClient sharedInstance] joinwithEntry:VRC_URL andCode:mCode asViewer:NO withDelegate:self];
        }
       
    }
    
    if (hasStartLiving) {
        if (!currentSlider) {
            currentSlider = [[SliderView alloc] init];
            [self.view addSubview:currentSlider];
            [currentSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(mMainPanel).offset(20);
                make.right.equalTo(mMainPanel).offset(-20);
                make.bottom.equalTo(mMainPanel).offset(-15);
                make.height.mas_equalTo(18);
            }];
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        }
        [self.view bringSubviewToFront:currentSlider];
        [currentSlider changeSliderWithData:self.currentRoom];
        
        if (!startDuringTimeLabel) {
            startDuringTimeLabel = [[UILabel alloc] init];
            [startDuringTimeLabel setFrame:CGRectMake(0, 0, 120, 40)];
            startDuringTimeLabel.font = SystemFontOfSize(14);
            startDuringTimeLabel.textColor = UIRGBColor(225, 225, 225, 1);
            startDuringTimeLabel.textAlignment = NSTextAlignmentRight;
            UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:startDuringTimeLabel];
            self.navigationItem.rightBarButtonItem = rightBtnItem;
        }
        int elapsedSecs = [NSDate.date timeIntervalSince1970]-self.currentRoom.start_time;
        if (elapsedSecs > 0) {
            NSInteger secondsNumber = elapsedSecs % 60;
            NSInteger minuteNumber = (elapsedSecs - secondsNumber) / 60 % 60;
            NSInteger hourNumber = ((elapsedSecs - secondsNumber) / 60 - minuteNumber) / 60 % 24;
            NSString *timeCode = [NSString stringWithFormat:@"时长: %.2ld:%.2ld:%.2ld", (long)hourNumber, (long)minuteNumber, (long)secondsNumber];
            NSString *timeCodeEN = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld Elapsed", (long)hourNumber, (long)minuteNumber, (long)secondsNumber];
            
            startDuringTimeLabel.text = ChineseStringOrENFun(timeCode, timeCodeEN);
        }
        vtitleLabel.text = self.currentRoom.name;
        if (elapsedSecs > self.currentRoom.duration*60) {
            //            课程结束
            [self jumpToTrainingvc];
        }
        
        if (!voiceBtn) {
            voiceBtn = [[UIButton alloc] init];
            [self.view addSubview:voiceBtn];
            [voiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(mMainPanel).offset(-20);
                make.bottom.equalTo(mMainPanel).offset(-50);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            [voiceBtn addTarget:self action:@selector(headvoiceBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            UIImage *image = [UIImage imageNamed:@"sound_on"];
            [voiceBtn setImage:image forState:UIControlStateNormal];
            [voiceBtn setImage:image forState:UIControlStateHighlighted];
        }
        if (!settingBtn) {
            settingBtn = [[UIButton alloc] init];
            [self.view addSubview:settingBtn];
            [settingBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(mMainPanel).offset(-20);
                make.top.equalTo(mMainPanel.mas_bottom).offset(50);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            [settingBtn addTarget:self action:@selector(settingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            UIImage *image = [UIImage imageNamed:@"video_set_back"];
            [settingBtn setImage:image forState:UIControlStateNormal];
            [settingBtn setImage:image forState:UIControlStateHighlighted];
        }
        
    }
    
}

//设置按钮点击
- (void)settingBtnClicked{
    UIWindow *mainwindow = [CommonTools mainWindow];
    [mainwindow addSubview:settingView];
    [settingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(mainwindow);
        make.left.top.equalTo(mainwindow);
    }];
    WeakSelf
    settingView.cancelBtnClickedBlock = ^(id clickModel) {
        StrongSelf(wSelf);
        [strongSelf->settingView removeFromSuperview];
    };
    settingView.myCameraSwitchChanged = ^(id clickModel) {
        
    };
    settingView.myMicSwicthChanged = ^(id clickModel) {
        
    };
    settingView.notdisturbSwitchChanged = ^(NSNumber *clickModel) {
//        免打扰
        StrongSelf(wSelf);
        [strongSelf changeNotDistrub:clickModel.boolValue];
    };
}

//免打扰
- (void)changeNotDistrub:(BOOL)need{
    needShowOthersVideo = need;
    for (GuestPanel * panel in _guestPanels) {
        if (needShowOthersVideo) {
//            开启免打扰
            [panel detachGuestRenderView];
        }else{
//            关闭免打扰
            [panel attachGuestRenderView];
        }
    }
}


#pragma mark  开启关闭 头部的声音
//开启关闭声音 头部的直播课的声音
- (void)headvoiceBtnClicked{
    VConductorClient *client = [VConductorClient sharedInstance];
    ClassMember *host = [client getHostMember];
    BOOL isAudioEnable = [host isHostAudioEnable];
    [host enableHostAudio:!isAudioEnable];
    UIImage *image = [UIImage imageNamed:@"sound_on"];
    if (isAudioEnable) {
        image = [UIImage imageNamed:@"sound_minus"];
    }
    [voiceBtn setImage:image forState:UIControlStateNormal];
    [voiceBtn setImage:image forState:UIControlStateHighlighted];
}

//获取房间的详情
- (void)reachRoomDetailInfo
{
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSString *eventid = mCode[@"eid"];
    NSDictionary *baddyParams = @{
        @"event_id": eventid,
    };
    [manager GET:@"room/detail" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        if (CheckResponseObject(responseObject)) {
            NSDictionary *roomJson = responseObject[@"recordset"];
            
            NSError *error;
            self.currentRoom = [[Room alloc] initWithDictionary:roomJson error:&error];
            self.currentRoom.event_id = eventid;
            //                显示进度条
//            self.title = self.currentRoom.name;
            [self startTimer];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

#pragma mark 跳转到完成页面
- (void)jumpToTrainingvc{
    AfterTrainingViewController *trainingvc = [[AfterTrainingViewController alloc] initWithNibName:@"AfterTrainingViewController" bundle:nil];
    trainingvc.event_id = self->mCode[@"eid"];
    trainingvc.invc = self.invc;
    [self.navigationController pushViewController:trainingvc animated:YES];
}


@end
