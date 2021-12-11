//
//  GroupRoomPrepareViewController.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/7.
//

#import "GroupRoomPrepareViewController.h"
#import "UserHeadPicView.h"
#import "TableHeadview.h"
#import "UIImage+Extension.h"
#import "CourseDetailSmallview.h"
#import "GroupRoomDetailViewController.h"
#import "ChoosePeopleViewController.h"
#import "MainViewController.h"
#import "RoomVC.h"
#import "UserInfoView.h"
#import "GroupMyRoom.h"
#import "ChoosePeopleTypeView.h"

@interface GroupRoomPrepareViewController (){
    UIScrollView * _bottomScrollview;
    UIScrollView *userlistView;
    Room *currentRoom;
    NSTimer * dataTimer;
    NSTimer * numberTimer;

    int userListHeight;
    
    GroupMyRoom *myRoomModel; //我的房间信息，主要是子房间信息，
    ChoosePeopleTypeView *choosePeopleTypeView; //选择房间的模式
}

@end

@implementation GroupRoomPrepareViewController

- (void)addPeopleBtnClick{
    ChoosePeopleViewController * peopleVC = [[ChoosePeopleViewController alloc] initWithNibName:@"ChoosePeopleViewController" bundle:nil];
    peopleVC.currentRoom = currentRoom;
    [self.navigationController pushViewController:peopleVC animated:YES];
    
}

- (void)changeUserList{
//
    RemoveSubviews(userlistView, [NSArray array]);;
    int startX = 0;
    BOOL isCreate = NO;
//    房主要在第一位
    NSMutableArray *tempArray = [NSMutableArray array];
    for (RoomUser *tempuser in myRoomModel.room_user) {
        if (tempuser.is_creator) {
//            房主要放第一个
            if ([[APPObjOnce sharedAppOnce].currentUser.id  isEqualToString:tempuser.id]) {
                isCreate = YES;
            }
            [tempArray insertObject:tempuser atIndex:0];
        }else{
            [tempArray addObject:tempuser];
        }
    }
    myRoomModel.room_user = (NSArray<RoomUser> *)tempArray;
    for (int index = 0; index < 4; index++) {
        RoomUser *user = nil;
        if (myRoomModel.room_user.count > index) {
            user = tempArray[index];
        }
        if (myRoomModel.room_user.count < 1 && index == 0) {
//            如果一个人都没有，把自己加在第一个
            user = [[RoomUser alloc] init];
            user.avatar = [APPObjOnce sharedAppOnce].currentUser.avatar;
            user.nickname = [APPObjOnce sharedAppOnce].currentUser.nickname;
        }
        UserInfoView * userView = [[UserInfoView alloc] initWithFrame:CGRectMake(startX, 0, 70, userListHeight)];
        [userlistView addSubview:userView];
        userView.userInteractionEnabled = YES;
//        团课 不能删除人
        [userView changeDatawithRoomUser:user andIsCreater:NO];
        userView.deleteBtn.tag = 1000+ index;
        startX = startX+80;
        
    }
    if (tempArray.count < 4 && isCreate) {
//        可以添加人
        UIView * userView = [[UIView alloc] initWithFrame:CGRectMake(startX, 0, 70, userListHeight)];
        [userlistView addSubview:userView];
        CGSize  parentSize = CGSizeMake(60, 60);
        UIButton  *addPeopleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, parentSize.width, parentSize.height)];
        [userView addSubview:addPeopleBtn];
        addPeopleBtn.backgroundColor = UIRGBColor(80, 80, 80, 1);
        addPeopleBtn.clipsToBounds = YES;
        addPeopleBtn.layer.cornerRadius = parentSize.width/2;
        
        UIImageView *userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add_plus_button.png"]];
        [addPeopleBtn addSubview:userImageView];
        userImageView.frame = CGRectMake(0, 0, parentSize.width, parentSize.height);
        [addPeopleBtn addTarget:self action:@selector(addPeopleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        startX = startX+70;
    }
    int contentsizex = startX;
    userlistView.contentSize = CGSizeMake(contentsizex, 0);
}

//修改倒计时按钮
- (void)changetillBtnTitle{
    
    if (currentRoom.status !=0) {
//    表示已经开始
    }
    if (currentRoom.start_time) {
        long currentTime = [[NSDate date] timeIntervalSince1970];
        long diff = currentRoom.start_time - currentTime;
        if (diff > 0) {
        
            NSString *leftString = [CommonTools reachLeftString:diff];
            NSString *titleString = [NSString stringWithFormat:@"Till start %@",leftString];
            [self.tillBtn setTitle:titleString forState:UIControlStateNormal];
            [self.tillBtn setTitle:titleString forState:UIControlStateHighlighted];
        }else{
            NSString *titleString = ChineseStringOrENFun(@"开始", @"JOIN");
            [self.tillBtn setTitle:titleString forState:UIControlStateNormal];
            [self.tillBtn setTitle:titleString forState:UIControlStateHighlighted];
            UIImage * image1 = [UIImage imageWithColor:SelectGreenColor];
            [self.tillBtn setBackgroundImage:image1 forState:UIControlStateNormal];
            [self.tillBtn setBackgroundImage:image1 forState:UIControlStateHighlighted];
            //                已经开始直播了
            [self.tillBtn addTarget:self action:@selector(joinInRoomClicked) forControlEvents:UIControlEventTouchUpInside];
            _startNowBtnHeightCon.constant = 0;
            _actionBtnTopConstraint.constant = 0;

        }
    }
}

- (void)addsubviews{
    self.view.hidden = NO;
    _headview.backgroundColor = [UIColor clearColor];
    TableHeadview *tableheadview = (TableHeadview *)[[[NSBundle mainBundle] loadNibNamed:@"TableHeadview" owner:self options:nil] lastObject];
    [_headview addSubview:tableheadview];
    _headview.clipsToBounds = YES;
    [tableheadview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headview);
        make.left.right.bottom.equalTo(_headview);
    }];
    self.title = ChineseStringOrENFun(@"团课准备", @"PREPARED COURSE");
    self.headTitle.text = @"   ";
    self.headTitle.font = SystemFontOfSize(20);
    self.timeLabel.text = ReachYearAndWeekTime(currentRoom.start_time);
    self.timeLabel.font = SystemFontOfSize(17);
    self.actionbackview.backgroundColor = BgGrayColor;
    NSString *startNowString = ChineseStringOrENFun(@"提前开始", @"Start Now");
    self.startNowBtn.layer.cornerRadius =5;
    self.startNowBtn.clipsToBounds =YES;
    BOOL isCreate = [currentRoom.creator_userid isEqualToString:[APPObjOnce sharedAppOnce].currentUser.id];
//    是自己创建的，才有提前开始按钮
    if (!isCreate) {
        _startNowBtnHeightCon.constant = 0;
        _actionBtnTopConstraint.constant = 0;
    }

    [self.startNowBtn setTitle:startNowString forState:UIControlStateNormal];
    [self.startNowBtn setTitle:startNowString forState:UIControlStateHighlighted];
    UIImage * image1 = [UIImage imageWithColor:SelectGreenColor];
    [self.startNowBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    [self.startNowBtn setBackgroundImage:image1 forState:UIControlStateHighlighted];
    [self.startNowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.startNowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [self.startNowBtn addTarget:self action:@selector(startNowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tillBtn.backgroundColor = UIRGBColor(79, 79, 79, 1);
    [self.tillBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.tillBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    self.tillBtn.layer.cornerRadius =5;
    self.tillBtn.clipsToBounds =YES;
    [self changetillBtnTitle];
    // Do any additional setup after loading the view from its nib.
    
    _bottomScrollview = [[UIScrollView alloc] init];
    [self.view addSubview:_bottomScrollview];
    _bottomScrollview.backgroundColor= BgGrayColor;
    [_bottomScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_actionbackview.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    //    随机匹配 邀请成员
    choosePeopleTypeView = [[[NSBundle mainBundle] loadNibNamed:@"ChoosePeopleTypeView" owner:self options:nil] lastObject];
    [_bottomScrollview addSubview:choosePeopleTypeView];
    [choosePeopleTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomScrollview);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
    }];
    choosePeopleTypeView.parentVC = self;
    [choosePeopleTypeView changeDataWithModel:myRoomModel];
    UIView *userListBackView = [[UIView alloc] init];
    [_bottomScrollview addSubview:userListBackView];
    int listwidth = ScreenWidth - 30;
    [userListBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(choosePeopleTypeView.mas_bottom).offset(10);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(userListHeight);
    }];

    userlistView = [[UIScrollView alloc] init];
    [userListBackView addSubview:userlistView];
    userlistView.frame = CGRectMake(0, 0, listwidth, userListHeight);
    [self changeUserList];
    
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = UIRGBColor(225, 225, 225, 0.5);
    [_bottomScrollview addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userlistView.mas_bottom).offset(15);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(listwidth);
    }];
    
    UILabel *titleLabel1 = [[UILabel alloc] init];
    [_bottomScrollview addSubview:titleLabel1];
    titleLabel1.text = ChineseStringOrENFun(@"课程介绍", @"Course introduction");
    titleLabel1.textColor = UIColor.whiteColor;
    titleLabel1.font = SystemFontOfSize(20);
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview.mas_bottom).offset(5);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(25);
    }];
    
    UIView *courseDetailView = [[UIView alloc] init];
    [_bottomScrollview addSubview:courseDetailView];
    [courseDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel1.mas_bottom).offset(15);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(300);
        make.bottom.equalTo(_bottomScrollview).offset(-15);
    }];
    courseDetailView.backgroundColor = UIRGBColor(59, 59, 59, 1);
    courseDetailView.layer.cornerRadius = 10;
    courseDetailView.clipsToBounds = YES;
    
    UIImageView *mainImageview = [[UIImageView alloc] init];
    [courseDetailView addSubview:mainImageview];
    [mainImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(courseDetailView);
        make.left.right.equalTo(courseDetailView);
        make.height.mas_equalTo(210);
    }];
    NSString *picUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, currentRoom.pic];
    [mainImageview sd_setImageWithURL: [NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    CourseDetailSmallview *detailsmall = (CourseDetailSmallview *)[[[NSBundle mainBundle] loadNibNamed:@"CourseDetailSmallview" owner:self options:nil] lastObject];
    [courseDetailView addSubview:detailsmall];
    [detailsmall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainImageview.mas_bottom);
        make.left.right.equalTo(courseDetailView);
        make.height.mas_equalTo(90);
    }];
    [detailsmall changeDatawithRoom:currentRoom];
    [detailsmall.detailBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)joinInRoomClicked{
    NSString * nickName = [APPObjOnce sharedAppOnce].currentUser.nickname;
    [ConfigManager sharedInstance].eventId = self.event_id;
    [ConfigManager sharedInstance].nickName = nickName;
    [[ConfigManager sharedInstance] saveConfig];
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
    codeDict[@"eid"] =self.event_id;
    codeDict[@"name"] =nickName;

//    NSDictionary *codeDict = @{@"eid":_selectRoom.event_id, @"name":nickName};
    RoomVC *roomVC = [[RoomVC alloc] initWith:codeDict];
    [self.navigationController pushViewController:roomVC animated:YES];
    roomVC.invc = self;
}

- (void)detailBtnClick{
    GroupRoomDetailViewController *vc =  [[GroupRoomDetailViewController alloc] initWithNibName:@"GroupRoomDetailViewController" bundle:nil];
    vc.selectRoom = currentRoom;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hidden = YES;
    userListHeight = 110;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    进来就调用，进入房间
    [self joinRoom];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reachData];
    [self changetillBtnTitle];
    dataTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(reachData) userInfo:nil repeats:YES];
    numberTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changetillBtnTitle) userInfo:nil repeats:YES];
        
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    不能左滑点击
    self.isTapBack = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [dataTimer invalidate];
    dataTimer = nil;
    [numberTimer invalidate];
    numberTimer = nil;
    
}

- (void)reachMyRoomData{
//    GET /api/subroom/myroom?user_id=46009524363987460&event_id=
    NSDictionary *baddyParams = @{
                           @"event_id": self.event_id,
                           @"user_id":[APPObjOnce sharedAppOnce].currentUser.id
                       };
    [[AFAppNetAPIClient manager] GET:@"subroom/myroom" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        if (CheckResponseObject(responseObject)) {
            GroupMyRoom * myRoom = [[GroupMyRoom alloc] initWithDictionary:responseObject[@"recordset"] error:nil];
            self->myRoomModel = myRoom;
            [self->choosePeopleTypeView changeDataWithModel:myRoom];
            [self changeUserList];

        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

//随机房间 还是自定义房间
- (void)createSubRoomOrDelete:(int)type{
    if (type == 0) {
//        随机 sub_room_id
        if (myRoomModel.sub_room_id.length > 0) {
            NSDictionary *baddyParams = @{
                                   @"sub_room_id":myRoomModel.sub_room_id
                               };
            [[AFAppNetAPIClient manager] POST:@"subroom/del" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
                if (CheckResponseObject(responseObject)) {
//                    获取一次子房间信息
                    [self reachMyRoomData];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
            }];
        }
    }else{
        NSDictionary *baddyParams = @{
                                @"event_id": self.event_id,
                                @"friend_ids":@""
                           };
        [[AFAppNetAPIClient manager] POST:@"subroom/create" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            if (CheckResponseObject(responseObject)) {
//                    获取一次子房间信息
                [self reachMyRoomData];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }
    
}


- (void)reachData{
    [self reachRoomDetailInfo];
    [self reachMyRoomData];
}

- (void)reachRoomDetailInfo
{
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
        NSString *eventid = self.event_id;
        NSDictionary *baddyParams = @{
                               @"event_id": eventid,
                           };
        [manager GET:@"room/detail" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (CheckResponseObject(responseObject)) {
                NSDictionary *roomJson = responseObject[@"recordset"];
                NSError *error;
                self->currentRoom = [[Room alloc] initWithDictionary:roomJson error:&error];
                self->currentRoom.event_id = eventid;
    //            没有创建过视图，处理一下
                if (!self->_bottomScrollview) {
                    [self addsubviews];
                }else{
    //                只改变状态
                    [self changetillBtnTitle];
                }
            }

            
          
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [CommonTools showNETErrorcontrol:self];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    
 
}

//http://1.117.70.210:8091/api/room/user?event_id=380559132387707396


- (void)startNowBtnClicked:(UIButton *)startNowBtn{
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];

    NSDictionary *baddyParams = @{
                           @"event_id": self.event_id,
                       };
    [manager POST:@"room/start_in_advance" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (CheckResponseObject(responseObject)) {
//            NSDictionary *roomJson = responseObject[@"recordset"];
            NSString * nickName = [APPObjOnce sharedAppOnce].currentUser.nickname;
            [ConfigManager sharedInstance].eventId = self.event_id;
            [ConfigManager sharedInstance].nickName = nickName;
            [[ConfigManager sharedInstance] saveConfig];
            NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
            codeDict[@"eid"] =self.event_id;
            codeDict[@"name"] =nickName;
        
        //    NSDictionary *codeDict = @{@"eid":_selectRoom.event_id, @"name":nickName};
            RoomVC *roomVC = [[RoomVC alloc] initWith:codeDict];
            [self.navigationController pushViewController:roomVC animated:YES];
            roomVC.invc = self;
        }else{
            [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"]  control:self];
        }
       
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CommonTools showNETErrorcontrol:self];

    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)backPopViewcontroller:(id) sender
{
    UIViewController * popVC = nil;
    NSArray *vcs = self.navigationController.viewControllers;
    for (UIViewController * vc in vcs) {
        if ([vc isKindOfClass:[MainViewController class]]) {
            popVC = vc;
        }
    }
    if (popVC) {
        [self.navigationController popToViewController:popVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//每次进入，都调用一下 room/join接口，表示自己进入了
- (void)joinRoom{
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSMutableDictionary *baddyParams = [NSMutableDictionary dictionary];
    [baddyParams setObject:self.event_id forKey:@"event_id"];
    [baddyParams setObject:[NSNumber numberWithBool:1] forKey:@"is_join"];
    [manager POST:@"room/join" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

@end
