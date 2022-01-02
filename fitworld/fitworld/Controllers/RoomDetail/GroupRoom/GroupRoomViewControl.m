#import "GroupRoomViewControl.h"

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
#import "GroupMyRoom.h"

#define LOG_FOLDER        @"Log"

@interface GroupRoomViewControl () <VConductorClientDelegate> {
    BOOL canErrorToPOP;//进入房间失败，就可以pop出去
    BOOL needShowOthersVideo;//是否展示其他人的视频  免打扰
    NSTimer *roomTimer;  //定时器，用来刷新时间的
    SliderView *currentSlider;//滑块
    BOOL hasStartLiving;// 开始直播了
    UILabel *startDuringTimeLabel;//开始了多久 //long diff = currentTime- room.start_time;
    UIButton *voiceBtn;// 头上视频的声音
    UILabel *vtitleLabel;//title 直播间名称
    UILabel *vnumberLabel;//title 直播间人数

    BOOL headHasVoice;//头部的有声音
    UIButton *settingBtn;//设置按钮
    
    BOOL createRoomLiving;//已经开始直播
    UILabel *leftTimeLabel;
    UIView *leftTimeBackview;
    RoomVCSettingView * settingView;//设置视图
    GroupMyRoom *myRoomModel; //我的房间信息，主要是子房间信息，
    NSTimer * groupdataTimer;//团课定时器
    
    CGSize panelSize;
}

@property (nonatomic, strong) NSDictionary* mCode;
@property (nonatomic, strong) MBProgressHUD *mHud;

@property (nonatomic, strong) UIImageView* mBkImg;
@property (nonatomic, strong) SidePanel *mSidePanel; //自己的view
@property (nonatomic, strong) MainPanel* mMainPanel; //教练的view
@property (nonatomic, strong) NSMutableArray* guestPanels;//其他人的

@end

@implementation GroupRoomViewControl

@synthesize mCode;
@synthesize mHud;

@synthesize mBkImg;
//@synthesize mHeaderPanel;
@synthesize mSidePanel;
@synthesize mMainPanel;

- (id)initWith:(NSDictionary*)code {
    self = [super init];
    mCode = code;
    panelSize = CGSizeMake(ScreenWidth/4, ScreenWidth/4/0.563);
    return self;
}

- (void)dealloc{
    // [[VSRTC sharedInstance] setObserver:nil];
    //    [mHeaderPanel stopTimer];
    NSLog(@"GroupRoomViewControl dealloc");
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
    mMainPanel = [MainPanel new];
    mMainPanel.layer.cornerRadius = 5;
    mMainPanel.layer.masksToBounds = YES;
    [self.view addSubview:mMainPanel];
    [mMainPanel createPlaceImageView];
    
    mSidePanel = [SidePanel new];
    mSidePanel.layer.cornerRadius = 5;
    mSidePanel.layer.masksToBounds = YES;
    [self.view addSubview:mSidePanel];
    mSidePanel.frame = CGRectMake(0, 100, panelSize.width , panelSize.height);
    //   给视图 添加手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
    [mSidePanel addGestureRecognizer:panGestureRecognizer];
    
    
    [self layoutPanel];
    __weak GroupRoomViewControl* weakSelf = self;
    mMainPanel.viewDoubleTapped = ^{
        GroupRoomViewControl* strongSelf = weakSelf;
        if (!strongSelf ) {
            return;
        }
    };
    
    mSidePanel.pressBtnChat = ^() {
        GroupRoomViewControl* strongSelf = weakSelf;
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
        
    } else {
        [mMainPanel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.height.equalTo(self.view);
        }];
        
        
        WeakSelf
        [UIView animateWithDuration:0.3 animations:^{
            //    获取所有的成员列表
            StrongSelf(wSelf);
            VConductorClient *client = [VConductorClient sharedInstance];
            NSDictionary * memberDic = [client getGustMemberData];
            //            拷贝一份key出来 这边的key就是userID
            NSMutableArray *keysArray = [[NSMutableArray alloc] initWithArray:memberDic.allKeys];
            //            团课 需要判断 这些成员，是不是自己直播间的
            
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
            NSMutableArray *tempArray = [NSMutableArray array];
            
            for (RoomUser *tempuser in self->myRoomModel.room_user) {
                [tempArray addObject:tempuser.id];
            }
            if (keysArray.count > 0) {
                for (NSString *userID in keysArray) {
                    //                    用户id 存在room里面
                    if ([tempArray containsObject:userID]) {
                        if (strongSelf.guestPanels.count < 3) {
                            //                        游客小于3个，这边才用
                            GuestPanel * guestpanel = [[GuestPanel alloc] init];
                            guestpanel.mUserId = userID;
                            [strongSelf.guestPanels addObject:guestpanel];
                            int showguestcount = (int)strongSelf.guestPanels.count;
                            [self.view addSubview:guestpanel];
                            CGFloat startX = ScreenWidth/4*(showguestcount);
                            CGFloat startY = 100;
                            guestpanel.frame = CGRectMake(startX, startY, self->panelSize.width, self->panelSize.height);
                            
                            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragReplyButton:)];
                            [guestpanel addGestureRecognizer:panGestureRecognizer];
                            [guestpanel attachGuestRenderView];
                            ClassMember *currentMember = [memberDic objectForKey:guestpanel.mUserId];
                            if ([[currentMember copyInfo].custom objectForKey:@"internal"]) {
                                guestpanel.mMyLabel.text = [[[currentMember copyInfo].custom objectForKey:@"internal"] objectForKey:@"nickName"];
                            }
                            guestpanel.translatesAutoresizingMaskIntoConstraints =  YES;
                        }
                    }
                }
            }
            
            self->vnumberLabel.text = [NSString stringWithFormat:@"%lu online",strongSelf.guestPanels.count+1];
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [groupdataTimer invalidate];
    groupdataTimer = nil;
    groupdataTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reachMyRoomData) userInfo:nil repeats:YES];
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
    [groupdataTimer invalidate];
    groupdataTimer = nil;
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
    //    mFullScreen = !mFullScreen;
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
    }
}

- (void)onTick {
    [mMainPanel syncRemoteView];
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

//改变成员
- (void)guestMemberChangetoView{
    [self layoutPanel];
    
}

//设置导航栏左边按钮
- (UIBarButtonItem *)leftMenuBarButtonItem {
    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-150, 40)];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(-10, 0, 40, 40)];
    [backview addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backPopViewcontroller:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 20, 20)];
    imageview.image = [UIImage imageNamed:@"back_white"];
    [backview addSubview:imageview];
    vtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 3, ScreenWidth-150-20-60, 20)];
    [backview addSubview:vtitleLabel];
    vtitleLabel.textColor = UIColor.whiteColor;
    
    vnumberLabel =[[UILabel alloc] initWithFrame:CGRectMake(25, 23, ScreenWidth-150-20-60, 15)];
    [backview addSubview:vnumberLabel];
    vnumberLabel.font =SystemFontOfSize(14);
    vnumberLabel.textColor = UIRGBColor(167, 167, 167, 1);
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
    self->canErrorToPOP = NO;
    [self joinStateRequest:NO success:^{
        [alertControl dismissViewControllerAnimated:YES completion:nil];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            //             跳转到健身完成页面
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
//    团课进入，多调用一次进入
    [manager POST:@"subroom/enter" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
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
        vnumberLabel.text = [NSString stringWithFormat:@"%lu online",self.guestPanels.count+1];
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
                make.top.equalTo(self.view).offset(250);
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
            [panel onlyShowUserImage];
        }else{
            //            关闭免打扰
            [panel showUservideo];
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


#pragma mark 获取子房间详情
- (void)reachMyRoomData{
    NSDictionary *baddyParams = @{
        @"event_id": mCode[@"eid"],
        @"user_id":[APPObjOnce sharedAppOnce].currentUser.id
    };
    [[AFAppNetAPIClient manager] GET:@"subroom/myroom" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        if (CheckResponseObject(responseObject)) {
            GroupMyRoom * myRoom = [[GroupMyRoom alloc] initWithDictionary:responseObject[@"recordset"] error:nil];
            self->myRoomModel = myRoom;
            //            获取子房间详情之后，这边需要重新
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


#pragma mark 获取子房间详情
- (void)dragReplyButton:(UIPanGestureRecognizer *)recognizer {
    UIView *moveView = recognizer.view;
    CGSize selfSize = self.view.bounds.size;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [recognizer locationInView:self.view];
        
        if (location.y < 0 || location.y > selfSize.height) {
            return;
        }
        CGPoint translation = [recognizer translationInView:self.view];
        
        recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,recognizer.view.center.y + translation.y);
        [recognizer setTranslation:CGPointZero inView:self.view];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        CGRect currentFrame = moveView.frame;
        
        if (currentFrame.origin.x < 0) {
            currentFrame.origin.x = 0;
            if (currentFrame.origin.y < 0) {
                currentFrame.origin.y = 4;
            } else if ((currentFrame.origin.y + currentFrame.size.height) > selfSize.height) {
                currentFrame.origin.y = selfSize.height - currentFrame.size.height;
            }
            [UIView animateWithDuration:0.5 animations:^{
                moveView.frame = currentFrame;
            }];
            return;
        }
        if ((currentFrame.origin.x + currentFrame.size.width) > selfSize.width) {
            currentFrame.origin.x = selfSize.width - currentFrame.size.width;
            if (currentFrame.origin.y < 0) {
                currentFrame.origin.y = 4;
            } else if ((currentFrame.origin.y + currentFrame.size.height) > selfSize.height) {
                currentFrame.origin.y = selfSize.height - currentFrame.size.height;
            }
            [UIView animateWithDuration:0.5 animations:^{
                moveView.frame = currentFrame;
            }];
            return;
        }
        if (currentFrame.origin.y < 0) {
            currentFrame.origin.y = 4;
            [UIView animateWithDuration:0.5 animations:^{
                moveView.frame = currentFrame;
            }];
            return;
        }
        if ((currentFrame.origin.y + currentFrame.size.height) > selfSize.height) {
            currentFrame.origin.y = selfSize.height - currentFrame.size.height;
            [UIView animateWithDuration:0.5 animations:^{
                moveView.frame = currentFrame;
            }];
            return;
        }
    }
}


@end
