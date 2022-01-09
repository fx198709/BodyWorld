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
#import "ChooseGroupPeopleViewController.h"
#import "MainViewController.h"
#import "GroupRoomViewControl.h"
#import "UserInfoView.h"
#import "GroupMyRoom.h"
#import "ChoosePeopleTypeView.h"
#import <messageUI/messageUI.h>

@interface GroupRoomPrepareViewController ()<MFMessageComposeViewControllerDelegate>{
    UIScrollView * _bottomScrollview;
    UIScrollView *userlistView;
    Room *currentRoom;
    NSTimer * dataTimer;
    NSTimer * numberTimer;

    int userListHeight;
    
    GroupMyRoom *myRoomModel; //我的房间信息，主要是子房间信息，
    ChoosePeopleTypeView *choosePeopleTypeView; //选择房间的模式
    BOOL hasDealPushData;//是否处理推送信息
    
    UIView * choosePeopleTypeOutView;//外层的view
    
    int  enterRoomType;//加入房间类型
}

@end

@implementation GroupRoomPrepareViewController

- (void)addPeopleBtnClick{
    ChooseGroupPeopleViewController * peopleVC = [[ChooseGroupPeopleViewController alloc] initWithNibName:@"ChooseGroupPeopleViewController" bundle:nil];
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
//            同意的才添加
            if (tempuser.is_accept) {
                [tempArray addObject:tempuser];
            }
        }
    }
    if (enterRoomType == 2) {
        RoomUser *user =  [[RoomUser alloc] init];
        user.avatar = [APPObjOnce sharedAppOnce].currentUser.avatar;
        user.nickname = [APPObjOnce sharedAppOnce].currentUser.nickname;
        UserInfoView * userView = [[UserInfoView alloc] initWithFrame:CGRectMake(startX, 0, 70, userListHeight)];
        [userlistView addSubview:userView];
        userView.userInteractionEnabled = YES;
//        团课 不能删除人
        [userView changeDatawithRoomUser:user andIsCreater:NO];
        userlistView.contentSize = CGSizeMake(0, 0);
        return;
    }
    for (int index = 0; index < 4; index++) {
        RoomUser *user = nil;
        if (tempArray.count > index) {
            user = tempArray[index];
        }
        if (tempArray.count < 1 && index == 0) {
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

//根据返回的子房间信息，修改详情
- (void)changeviewAfterRearchMyRoom{
    [self changeUserList];
    [self changeChoosePeopleTypeOutView];
}

//展示是否接受的alertControl
- (void)showAcceptAlertControl
{
    //    [self.navigationController popViewControllerAnimated:YES];
    NSString *titleString = ChineseStringOrENFun(@"提示", @"Alert");
    NSString *contentString = ChineseStringOrENFun(@"您是否接受邀请，加入他的房间", @"");
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:titleString message:contentString preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *weakalert = alertControl;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:CancelString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        __strong UIAlertController* strongalert = weakalert;
        [self refuseInvite:strongalert];
    }];
    [alertControl addAction:cancelAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:OKString style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        __strong UIAlertController* strongalert = weakalert;
        [self agreeInvite:strongalert];
    }];
    [alertControl addAction:sureAction];
    [self presentViewController:alertControl animated:YES completion:nil];
    
}


- (void)agreeInvite:(UIAlertController*)alert{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSDictionary *baddyParams = @{
                           @"sub_room_id": myRoomModel.sub_room_id
                       };
    [manager POST:@"subroom/agree" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (CheckResponseObject(responseObject)) {
//            同意 直接返回 开启timer
            self->hasDealPushData = YES;//表示已经处理过推送消息了 然后开启定时器
            [self startDataTimer];
        }else{
            [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"] control:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [CommonTools showNETErrorcontrol:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)refuseInvite:(UIAlertController*)alert{
//            [alertControl dismissViewControllerAnimated:YES completion:nil];
//    sub_room_id
//    user_id
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSDictionary *baddyParams = @{
                           @"sub_room_id": myRoomModel.sub_room_id,
                           @"user_id": [APPObjOnce sharedAppOnce].currentUser.id
                       };
    [manager POST:@"subroom/refuse" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (CheckResponseObject(responseObject)) {
//            拒绝 直接返回
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"] control:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [CommonTools showNETErrorcontrol:self];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


//修改对外的view
- (void)changeChoosePeopleTypeOutView{
    if (!_bottomScrollview) {
        return;
    }
    BOOL needAddview = NO;//是否需要添加  随机 邀请朋友的视图
//    查看自己是不是在别人的子房间内
    if (myRoomModel.is_accept == 0) {
        if (myRoomModel.sub_room_id && myRoomModel.sub_room_id.length >0 && !myRoomModel.is_creator) {
            //        弹出选择的alertview 有子房间信息，有人邀请的
            [self showAcceptAlertControl];
            return;
        }else{
//            需要加上头部的信息
            needAddview = YES;
        }
    }
    if (myRoomModel.is_accept == 1) {
//        判断自己是不是子房间的房主， 如果不是，则不需要显示上面的那部分
        if (myRoomModel.is_creator) {
            needAddview = YES;
        }
    }
    if (needAddview) {
        RemoveSubviews(choosePeopleTypeOutView, @[]);
        choosePeopleTypeView = [[[NSBundle mainBundle] loadNibNamed:@"ChoosePeopleTypeView" owner:self options:nil] lastObject];
        [choosePeopleTypeOutView addSubview:choosePeopleTypeView];
        [choosePeopleTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomScrollview);
            make.left.equalTo(_bottomScrollview);
            make.right.equalTo(_bottomScrollview);
        }];
        choosePeopleTypeView.parentVC = self;
        [choosePeopleTypeView changeDataWithModel:myRoomModel enterType:enterRoomType];
        [choosePeopleTypeOutView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomScrollview);
            make.left.equalTo(_bottomScrollview).offset(15);
            make.right.equalTo(_bottomScrollview).offset(-15);
            make.bottom.equalTo(choosePeopleTypeView.mas_bottom);
         }];
        WeakSelf
        choosePeopleTypeView.shareTypeBtnClick = ^(NSNumber* clickModel) {
            [wSelf sharedType:clickModel.intValue];
        };
    }else{
        RemoveSubviews(choosePeopleTypeOutView, @[]);
        [choosePeopleTypeOutView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_bottomScrollview);
            make.left.equalTo(_bottomScrollview).offset(15);
            make.right.equalTo(_bottomScrollview).offset(-15);
            make.height.mas_equalTo(0);
        }];
    }
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
            NSString *string = ChineseStringOrENFun(@"距开始", @"Till start");
            NSString *titleString = [NSString stringWithFormat:@"%@ %@",string,leftString];
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
    self.headTitle.text = currentRoom.name;
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
    choosePeopleTypeOutView = [[UIView alloc] init];
    [_bottomScrollview addSubview:choosePeopleTypeOutView];
    [choosePeopleTypeOutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomScrollview);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(0);
    }];
    if (myRoomModel) {
        [self changeChoosePeopleTypeOutView];
    }

    UIView *userListBackView = [[UIView alloc] init];
    [_bottomScrollview addSubview:userListBackView];
    int listwidth = ScreenWidth - 30;
    [userListBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(choosePeopleTypeOutView.mas_bottom).offset(10);
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
    [ConfigManager sharedInstance].userId = [APPObjOnce sharedAppOnce].currentUser.id;
    [[ConfigManager sharedInstance] saveConfig];
    NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
    codeDict[@"eid"] =self.event_id;
    codeDict[@"name"] =nickName;

//    NSDictionary *codeDict = @{@"eid":_selectRoom.event_id, @"name":nickName};
    GroupRoomViewControl *roomVC = [[GroupRoomViewControl alloc] initWith:codeDict];
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
    enterRoomType = 0;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    进来就调用，进入房间
    if (self.extended_data.allKeys.count) {
//        从推送进来的
        hasDealPushData = NO;
    }else{
        hasDealPushData = YES;
        [self joinRoom];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reachData];
    [self changetillBtnTitle];
//    处理过推送信息，或者没有推送信息，这边才开启
    [self startDataTimer];
    [numberTimer invalidate];
    numberTimer = nil;
    numberTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changetillBtnTitle) userInfo:nil repeats:YES];
        
}

- (void)startDataTimer{
    if (hasDealPushData) {
        [dataTimer invalidate];
        dataTimer = nil;
        dataTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(reachData) userInfo:nil repeats:YES];
    }
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

//http://1.117.70.210:8091/api/subroom/myroom?user_id=45169669346167300&event_id=384827458639104516&sub_room_id=2021121202_ddygra


- (void)reachMyRoomData{
//    GET /api/subroom/myroom?user_id=46009524363987460&event_id=
//    extended_data
//     http://1.117.70.210:8091/api/subroom/myroom?user_id=45169669346167300&event_id=384827458639104516&sub_room_id=2021121202_ddygra
    
//    2021121202_ddygra
    
//http://1.117.70.210:8091/api/subroom/agree
//http://1.117.70.210:8091/api/subroom/refuse
    NSDictionary *baddyParams1 = @{
                           @"event_id": self.event_id,
                           @"user_id":[APPObjOnce sharedAppOnce].currentUser.id
                       };
    NSMutableDictionary *baddyParams = [NSMutableDictionary dictionaryWithDictionary:baddyParams1];
    if (self.extended_data.allKeys.count && !hasDealPushData) {
        [baddyParams setObject:[self.extended_data objectForKey:@"sub_room_id"] forKey:@"sub_room_id"];
    }

    [[AFAppNetAPIClient manager] GET:@"subroom/myroom" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        if (CheckResponseObject(responseObject)) {
            GroupMyRoom * myRoom = [[GroupMyRoom alloc] initWithDictionary:responseObject[@"recordset"] error:nil];
            self->myRoomModel = myRoom;
//            获取子房间详情之后，这边需要重新
            [self changeviewAfterRearchMyRoom];
        }else{
            [CommonTools showAlertDismissWithResponseContent:responseObject control:self];
//            弹出错误，然后开启
            self->hasDealPushData = YES;//表示已经处理过推送消息了 然后开启定时器
            [self startDataTimer];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [CommonTools showNETErrorcontrol:self];
    }];
}

//随机房间 还是自定义房间
- (void)createSubRoomOrDelete:(int)type{
    enterRoomType = type;
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
    }else if(type == 2){
        NSDictionary *baddyParams = @{
                                @"event_id": self.event_id,
                           };
        [[AFAppNetAPIClient manager] POST:@"subroom/create_private" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            if (CheckResponseObject(responseObject)) {
//                    获取一次子房间信息
                [self reachMyRoomData];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    }else{
        NSDictionary *baddyParams = @{
                                @"event_id": self.event_id,
                                @"friend_ids":@""
                           };
//    http://m.fitworld.live/api/subroom/create_private
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
            [ConfigManager sharedInstance].userId = [APPObjOnce sharedAppOnce].currentUser.id;
            [[ConfigManager sharedInstance] saveConfig];
            NSMutableDictionary *codeDict = [NSMutableDictionary dictionary];
            codeDict[@"eid"] =self.event_id;
            codeDict[@"name"] =nickName;
        
        //    NSDictionary *codeDict = @{@"eid":_selectRoom.event_id, @"name":nickName};
            GroupRoomViewControl *roomVC = [[GroupRoomViewControl alloc] initWith:codeDict];
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
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)sharedType:(int)type{
    if (type == 2) {
        [self sharedByMessage];
    }
}

#pragma mark --MFMessageComposeViewControllerDelegate

- (void)sharedByMessage
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
       /**MFMessageComposeViewController提供了操作界面
        使用前必须检查canSendText方法,若返回NO则不应将这个controller展现出来,而应该提示用户不支持发送短信功能.
         */
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }else{
            [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"您设备没有短信功能", @"您设备没有短信功能") control:self];
        }
    }

}
 

-(void)displaySMSComposerSheet
{
   MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc]init];
    picker.messageComposeDelegate =self;
    NSString *body = @"Hihi! 跟我一起来上健身课，品牌健身房的大牌教练，哪国人都有。";
    NSString *urlString = [NSString stringWithFormat:@"http://m.fitworld.live/assets/share?type=group&event_id=%@&room_sub_id=%@",_event_id,myRoomModel.sub_room_id];
    picker.body = [NSString stringWithFormat:@"%@%@",body,urlString];
   
    [self presentViewController:picker animated:YES completion:^{
//        [self shareBackbuttonClicked:nil];
    }];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result

{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled){
    }else if (result == MessageComposeResultSent){
        [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"短信发送成功", @"短信发送成功") control:self];
    }else if(result == MessageComposeResultFailed){
        [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"短信发送失败，是否重新发送？", @"短信发送失败，是否重新发送？") control:self];

    }

}


@end
