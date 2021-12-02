//
//  GroupRoomDetailViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/8/4.
//

#import "GroupRoomDetailViewController.h"
#import "UIDeps.h"
#import "FITAPI.h"
#import "ConfigManager.h"
#import "RoomVC.h"
#import "APPObjOnce.h"
#import "UserHeadPicView.h"

@interface GroupRoomDetailViewController ()
@property(nonatomic, strong)UIButton *joinBtn;

@end

@implementation GroupRoomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
        
    self.view.backgroundColor = UIColor.blackColor;
    [self reachRoomDetailInfo];
}

- (void)changejoinBtn{
    [CommonTools changeBtnState:_joinBtn btnData:self.selectRoom];
}

- (void)addsubviews{
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"coursedetail_top"];
    NSString *picUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, self.selectRoom.course.pic];
    [topImgView sd_setImageWithURL: [NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    [self.view addSubview:topImgView];
    int topimageHeight = self.view.bounds.size.height / 3;
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(topimageHeight);
    }];

    _joinBtn = [[UIButton alloc] init];
//    joinBtn.backgroundColor = UIColor.redColor;
    
//    [countInBtn setTitle:@"JOIN CLASS" forState:UIControlStateNormal];
    [_joinBtn addTarget:self action:@selector(joinClass) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_joinBtn];
    _joinBtn.titleLabel.font =SystemFontOfSize(13);
    [_joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topImgView.mas_bottom).offset(-30);
        make.right.equalTo(topImgView.mas_right).offset(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    [self changejoinBtn];
    UIView *topImgBotView = [[UIView alloc]init];
    topImgBotView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:topImgBotView];
    [topImgBotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(topImgView.mas_bottom).offset(-20);
    }];
//    不透明背景
    UIView *topimagBotBackView = [[UIView alloc] init];
    [topImgBotView addSubview:topimagBotBackView];
    topimagBotBackView.backgroundColor = UIRGBColor(37, 37, 37, 0.3);
    topimagBotBackView.alpha = 0.7;
//    topimagBotBackView.backgroundColor = UIColor.redColor;
    [topimagBotBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(topImgBotView);
        make.top.equalTo(topImgBotView);
        make.left.equalTo(topImgBotView);
    }];
    
    UILabel *courseNameLl = [[UILabel alloc] init];
    courseNameLl.text = self.selectRoom.name;
    courseNameLl.textColor = UIColor.whiteColor;
    courseNameLl.font =[UIFont boldSystemFontOfSize:22];
    [topImgBotView addSubview:courseNameLl];
    [courseNameLl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgBotView);
        make.left.equalTo(topImgBotView).offset(10);
    }];
    
    UILabel *startTimelabel = [[UILabel alloc] init];
    startTimelabel.text = ReachWeekTime(self.selectRoom.start_time);
    startTimelabel.textColor = UIColorFromRGB(225, 225, 225);
    startTimelabel.font = SystemFontOfSize(13);
    [topImgBotView addSubview:startTimelabel];
    [startTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(courseNameLl.mas_bottom).offset(5);
        make.left.equalTo(courseNameLl);
    }];
    
//    滚动条
    UIScrollView * scrollview = [[UIScrollView alloc] init];
    [self.view addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgBotView.mas_bottom).offset(15);
        make.left.bottom.right.equalTo(self.view);
    }];
    int outwith = ScreenWidth;
    UIView *detailView = [[UIView alloc] init];
    [scrollview addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollview);
        make.left.right.equalTo(scrollview);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(outwith);
    }];
    
    
    UIView *userLeftView = [[UIView alloc]init];
    userLeftView.backgroundColor = UIColor.blackColor;
    [detailView addSubview:userLeftView];
    [userLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detailView);
        make.top.equalTo(detailView);
        make.height.mas_equalTo(50);
        make.width.equalTo(detailView).multipliedBy(0.33);

    }];
    
    
    UILabel *getTimeLabel = [[UILabel alloc] init];
    getTimeLabel.text = [NSString stringWithFormat:@"%ld", (long)_selectRoom.duration]; //@"5";
    getTimeLabel.font = [UIFont boldSystemFontOfSize:20];
    getTimeLabel.textColor= UIColor.whiteColor;
    getTimeLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = ChineseStringOrENFun(@"时长(分)", @"Time(min)");
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor= UIColor.whiteColor;

    timeLabel.adjustsFontSizeToFitWidth = YES;

    [userLeftView addSubview:timeLabel];
    [userLeftView addSubview:getTimeLabel];
    
    [getTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userLeftView);
        make.top.equalTo(userLeftView).offset(5);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getTimeLabel.mas_bottom).offset(8);
        make.centerX.equalTo(userLeftView);
    }];
    
    UIView *userMidView = [[UIView alloc]init];
    userMidView.backgroundColor = UIColor.blackColor;
    [detailView addSubview:userMidView];
    [userMidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView);
        make.left.equalTo(userLeftView.mas_right);
        make.height.mas_equalTo(50);
        make.width.equalTo(detailView).multipliedBy(0.33);
        
    }];
    

    UILabel *getHeartLabel = [[UILabel alloc] init];
    getHeartLabel.text = _selectRoom.heart_rate.length > 0?_selectRoom.heart_rate:@"  ";
    getHeartLabel.font = [UIFont boldSystemFontOfSize:20];;
    getHeartLabel.textColor= UIColor.whiteColor;
    getHeartLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *heartLabel = [[UILabel alloc] init];
    heartLabel.text = ChineseStringOrENFun(@"心率(Bpm)", @"Heart rate(Bpm)");
    heartLabel.font = [UIFont systemFontOfSize:13];
    heartLabel.textColor= UIColor.whiteColor;
    heartLabel.adjustsFontSizeToFitWidth = YES;

    [userMidView addSubview:heartLabel];
    [userMidView addSubview:getHeartLabel];
    
    [getHeartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userMidView);
        make.top.equalTo(userMidView).offset(5);
    }];
    [heartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getHeartLabel.mas_bottom).offset(8);
        make.centerX.equalTo(userMidView);
    }];
    
    
    UIView *userRightView = [[UIView alloc]init];
    userRightView.backgroundColor = UIColor.blackColor;
    [detailView addSubview:userRightView];
    [userRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView);
        make.right.equalTo(detailView);
        make.height.equalTo(userLeftView);
        make.left.equalTo(userMidView.mas_right);
    }];
    
    UILabel *getKcalLabel = [[UILabel alloc] init];
    getKcalLabel.text = [NSString stringWithFormat:@"%@", _selectRoom.cal];
    getKcalLabel.font = [UIFont boldSystemFontOfSize:20];;
    getKcalLabel.textColor= UIColor.whiteColor;
    getKcalLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *kcalLabel = [[UILabel alloc] init];
    kcalLabel.text =ChineseStringOrENFun(@"卡路里(Kcal)", @"Consumption(Kcal)");
    kcalLabel.textColor= UIColor.whiteColor;
    kcalLabel.font = [UIFont systemFontOfSize:13];
    kcalLabel.adjustsFontSizeToFitWidth = YES;

    [userRightView addSubview:kcalLabel];
    [userRightView addSubview:getKcalLabel];
    
    [getKcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userRightView);
        make.top.equalTo(userRightView).offset(5);
    }];
    
    [kcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getKcalLabel.mas_bottom).offset(8);
        make.centerX.equalTo(userRightView);
    }];
    
//    备注
    
    UILabel *vdesclabel = [[UILabel alloc]init];
    [scrollview addSubview:vdesclabel];
    [vdesclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView.mas_bottom).offset(25);
        make.left.equalTo(scrollview).offset(10);
        make.right.equalTo(scrollview).offset(-10);

    }];
    vdesclabel.preferredMaxLayoutWidth = ScreenWidth-20;
    vdesclabel.numberOfLines = 0;
    vdesclabel.font = SystemFontOfSize(15);
    vdesclabel.textColor = UIRGBColor(225, 225, 225, 1);
    vdesclabel.text = self.selectRoom.course.desc;
    [vdesclabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [vdesclabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = LineColor;
    [scrollview addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vdesclabel.mas_bottom).offset(15);
        make.left.equalTo(scrollview).offset(10);
        make.right.equalTo(scrollview).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
//    教练
    UIView *coachView = [[UIView alloc] init];
//    coachView.backgroundColor = UIColor.darkGrayColor;
//    coachView.layer.cornerRadius = 5;
//    coachView.clipsToBounds = YES;
    [scrollview addSubview:coachView];
    [coachView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(scrollview);
        make.top.equalTo(lineview.mas_bottom).offset(5);
        make.height.mas_equalTo(80);
    }];
    
    UserHeadPicView * coachimageview = [[UserHeadPicView alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    [coachView addSubview:coachimageview];
    [coachimageview changeCoachModelData:self.selectRoom.coach];

    
    UILabel *courseLabel = [[UILabel alloc] init];
    courseLabel.adjustsFontSizeToFitWidth = YES;
    courseLabel.text = self.selectRoom.coach.nickname;
    courseLabel.textColor = UIColor.whiteColor;
    courseLabel.font =SystemFontOfSize(16);
    [coachView addSubview:courseLabel];
    [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coachView.mas_left).offset(75);
        make.top.equalTo(coachView).offset(25);
    }];
    
    UIImageView *countryImage = [[UIImageView alloc] init];
    [coachView addSubview:countryImage];
    [countryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(courseLabel.mas_right).offset(6);
        make.centerY.equalTo(courseLabel);
        make.size.mas_equalTo(CGSizeMake(20, 10));
    }];
    NSString *url = self.selectRoom.coach.country_icon;
    [countryImage sd_setImageWithURL:[NSURL URLWithString:url]];
    countryImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *courseCityLabel = [[UILabel alloc] init];
    courseCityLabel.adjustsFontSizeToFitWidth = YES;
    courseCityLabel.text = [NSString stringWithFormat:@"%@ - %@", self.selectRoom.coach.city, self.selectRoom.coach.country];
    courseCityLabel.textColor = LightGaryTextColor;
    courseCityLabel.font = SystemFontOfSize(14);
    [coachView addSubview:courseCityLabel];
    [courseCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(courseLabel.mas_bottom).offset(6);
        make.left.equalTo(courseLabel);
    }];
    
//    UIButton *followCoachBtn = [[UIButton alloc] init];
//
//    NSString *btntitle = ChineseStringOrENFun(@"关注", @"Follow");
//    [followCoachBtn setTitle:btntitle forState:UIControlStateNormal];
//    [followCoachBtn setTitle:btntitle forState:UIControlStateHighlighted];
//    followCoachBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//    UIColor *greenColor = SelectGreenColor;
//    [followCoachBtn setTitleColor:greenColor forState:UIControlStateNormal];
//     [followCoachBtn setTitleColor:greenColor forState:UIControlStateHighlighted];
//    [coachView addSubview:followCoachBtn];
//    [followCoachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(coachView.mas_top).offset(20);
//        make.right.equalTo(coachView).offset(-10);
//        make.height.mas_equalTo(40);
//        make.width.mas_equalTo(90);
//    }];
//    followCoachBtn.layer.cornerRadius = 20;
//    followCoachBtn.clipsToBounds = YES;
//    followCoachBtn.backgroundColor = UIColorFromRGB(37, 37, 37);
//    [followCoachBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineview1 = [[UIView alloc] init];
    lineview1.backgroundColor = LineColor;
    [scrollview addSubview:lineview1];
    [lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coachView.mas_bottom).offset(15);
        make.left.equalTo(scrollview).offset(10);
        make.right.equalTo(scrollview).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *programLabel = [[UILabel alloc] init];
    programLabel.text = ChineseStringOrENFun(@"锻炼计划", @"Program");
    programLabel.font = [UIFont boldSystemFontOfSize:18];
    programLabel.textColor = UIColor.whiteColor;
    programLabel.adjustsFontSizeToFitWidth = YES;
    [scrollview addSubview:programLabel];
    [programLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview1.mas_bottom).offset(16);
        make.left.equalTo(scrollview).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    int planCount = (int)self.selectRoom.course.plan.count;
    int  backViewHeight = 40+ 30*planCount+30;
    UIView *planBackView = [[UIView alloc] init];
    [scrollview addSubview:planBackView];
    [planBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(programLabel.mas_bottom).offset(16);
        make.left.equalTo(scrollview).offset(10);
        make.right.equalTo(scrollview).offset(-10);
        make.height.mas_equalTo(backViewHeight);
        make.bottom.equalTo(scrollview).offset(-10);
    }];
    planBackView.backgroundColor = BgGrayColor;
    planBackView.layer.cornerRadius = 15;
    planBackView.clipsToBounds = YES;
    int allwith = outwith-60;
    UILabel *headleftLabel = [[UILabel alloc] init];
    [planBackView addSubview:headleftLabel];
    headleftLabel.textColor = UIColor.whiteColor;
    headleftLabel.font = [UIFont boldSystemFontOfSize:17];
    headleftLabel.frame = CGRectMake(20, 5, allwith* 0.4, 40);
//    headleftLabel.textAlignment = NSTextAlignmentCenter;
    headleftLabel.text = ChineseStringOrENFun(@"时长（分钟）", @"Time(min)");
    UILabel *headrightLabel = [[UILabel alloc] init];
    [planBackView addSubview:headrightLabel];
    headrightLabel.textColor = UIColor.whiteColor;
    headrightLabel.font = [UIFont boldSystemFontOfSize:20];
    headrightLabel.frame = CGRectMake(allwith* 0.4+30, 5, allwith* 0.6, 40);
    headrightLabel.text = ChineseStringOrENFun(@"内容", @"Content");
    for (int index=0; index< planCount; index++) {
        int starty = 40+10+30*index;
        Plan * plan = [self.selectRoom.course.plan objectAtIndex:index];
        UILabel *leftlabel = [self contentLabel];
        [planBackView addSubview:leftlabel];
        leftlabel.text = [NSString stringWithFormat:@"%ld",plan.duration];
//        leftlabel.textAlignment = NSTextAlignmentCenter;
        leftlabel.frame = CGRectMake(20, starty, allwith*0.4, 30);
        UILabel *rightlabel = [self contentLabel];
        [planBackView addSubview:rightlabel];
        rightlabel.frame = CGRectMake(allwith* 0.4+30, starty, allwith*0.6, 30);
        rightlabel.text = plan.stage;
    }
}

- (UILabel*)contentLabel{
    UILabel *vLabel = [[UILabel alloc] init];
    vLabel.textColor = UIRGBColor(225, 225, 225, 1);
    vLabel.font = SystemFontOfSize(17);
    return  vLabel;
}

- (void)followBtnClick{
    
}



- (void)reachRoomDetailInfo
{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSString *eventid = self.selectRoom.event_id;
        NSDictionary *baddyParams = @{
                               @"event_id": self.selectRoom.event_id,
                           };
        [manager GET:@"room/detail" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *roomJson = responseObject[@"recordset"];
            NSError *error;
            self->_selectRoom = [[Room alloc] initWithDictionary:roomJson error:&error];
            self.selectRoom.event_id = eventid;
            [self addsubviews];
          
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    
 
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) joinClass{
//    需要判断状态
    int realState = [self.selectRoom reachRoomDealState];
    
    if (realState == 1 || realState == 2) {
//        预约
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
        BOOL postBool =!self.selectRoom.is_join;
        NSMutableDictionary *baddyParams = [NSMutableDictionary dictionary];
        [baddyParams setObject:self.selectRoom.event_id forKey:@"event_id"];
        [baddyParams setObject:[NSNumber numberWithBool:postBool] forKey:@"is_join"];
        [manager POST:@"room/join" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (CheckResponseObject(responseObject)) {
                self.selectRoom.is_join = postBool;
                [self changejoinBtn];
            }else{
                [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"]  control:self];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [CommonTools showNETErrorcontrol:self];
        }];
    }else if(realState == 5){
//        直接开始
        [[APPObjOnce sharedAppOnce] joinRoom:self.selectRoom withInvc:self];
    }
    
}


@end

