//
//  CourseDetailViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/8/4.
//

#import "CourseDetailViewController.h"
#import "UIDeps.h"
#import "FITAPI.h"
#import "ConfigManager.h"
#import "RoomVC.h"
#import "APPObjOnce.h"

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
        
    self.view.backgroundColor = UIColor.blackColor;
    [self reachRoomDetailInfo];
}

- (void)addsubviews{
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"coursedetail_top"];
    NSString *picUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, self.selectRoom.pic];
    [topImgView sd_setImageWithURL: [NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    [self.view addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(self.view.bounds.size.height / 3);
    }];

    UIButton *countInBtn = [[UIButton alloc] init];
    countInBtn.backgroundColor = UIColor.redColor;
    [countInBtn setTitle:@"JOIN CLASS" forState:UIControlStateNormal];
    [countInBtn addTarget:self action:@selector(joinClass) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:countInBtn];
    [countInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_top).offset(100);
        make.right.equalTo(topImgView.mas_right).offset(-10);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(30);
    }];
    
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
    courseNameLl.font = SystemFontOfSize(20);
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
//    UIScrollView * scrollview = [[UIScrollView alloc] init];
//    [self.view addSubview:scrollview];
//    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(topImgBotView.mas_bottom);
//        make.left.bottom.right.equalTo(self.view);
//    }];
    
    UIView *userLeftView = [[UIView alloc]init];
    userLeftView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:userLeftView];
    [userLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(topImgBotView.mas_bottom).offset(0);
        make.height.mas_equalTo(50);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.33);
    }];
    
    
    UILabel *getTimeLabel = [[UILabel alloc] init];
    getTimeLabel.text = [NSString stringWithFormat:@"%ld", (long)_selectRoom.duration]; //@"5";
    getTimeLabel.font = [UIFont boldSystemFontOfSize:17];
    getTimeLabel.textColor= UIColor.whiteColor;
    getTimeLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = ChineseStringOrENFun(@"时长(分)", @"Time(mins)");
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
    [self.view addSubview:userMidView];
    [userMidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView);
        make.left.equalTo(userLeftView.mas_right);
        make.height.mas_equalTo(50);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.34);
    }];
    

    UILabel *getHeartLabel = [[UILabel alloc] init];
    getHeartLabel.text = _selectRoom.heart_rate;
    getHeartLabel.font = [UIFont boldSystemFontOfSize:17];;
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
    [self.view addSubview:userRightView];
    [userRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView);
        make.right.equalTo(self.view);
        make.height.equalTo(userLeftView);
        make.left.equalTo(userMidView.mas_right);
    }];
    
    UILabel *getKcalLabel = [[UILabel alloc] init];
    getKcalLabel.text = [NSString stringWithFormat:@"%@", _selectRoom.cal];
    getKcalLabel.font = [UIFont boldSystemFontOfSize:17];;
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
//    UILabel *vlabel
    
    UIView *coachView = [[UIView alloc] init];
    coachView.backgroundColor = UIColor.darkGrayColor;
    coachView.alpha = 0.3;
    [self.view addSubview:coachView];
    [coachView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(userLeftView.mas_bottom).offset(10);
        make.height.mas_equalTo(120);
    }];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, [self.selectRoom.room_creator valueForKey:@"avatar"]]]];
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    leftImageView.layer.masksToBounds = YES;
    leftImageView.layer.cornerRadius = 20;
    [leftImageView.layer setBorderWidth:2];
    [leftImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [coachView addSubview:leftImageView];
    
    UILabel *courseLabel = [[UILabel alloc] init];
    courseLabel.adjustsFontSizeToFitWidth = YES;
    courseLabel.text = self.selectRoom.course.coach_name;
    courseLabel.textColor = UIColor.whiteColor;
    [coachView addSubview:courseLabel];
    [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImageView.mas_right).offset(3);
        make.top.equalTo(leftImageView);
    }];
    
    UILabel *courseCityLabel = [[UILabel alloc] init];
    courseCityLabel.adjustsFontSizeToFitWidth = YES;
    courseCityLabel.text = [NSString stringWithFormat:@"%@ - %@", self.selectRoom.room_creator.country, self.selectRoom.room_creator.city];
    courseCityLabel.textColor = UIColor.whiteColor;
    [coachView addSubview:courseCityLabel];
    [courseCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(courseLabel.mas_bottom).offset(1);
        make.left.equalTo(courseLabel);
    }];
    
    UIView *programView = [[UIView alloc] init];
    programView.backgroundColor = UIColor.darkGrayColor;
    programView.alpha = 0.3;
    [self.view addSubview:programView];
    [programView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(coachView.mas_bottom).offset(5);
        make.height.mas_equalTo(120);
    }];
    
    UILabel *programLabel = [[UILabel alloc] init];
    programLabel.text = @"Program";
    programLabel.textColor = UIColor.whiteColor;
    programLabel.adjustsFontSizeToFitWidth = YES;
    [programView addSubview:programLabel];
    [programLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(programView).offset(10);
    }];
}

- (void)reachRoomDetailInfo
{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];

        NSDictionary *baddyParams = @{
                               @"event_id": self.selectRoom.event_id,
                           };
        [manager GET:@"room/detail" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSDictionary *roomJson = responseObject[@"recordset"];
            self->_selectRoom = [[Room alloc] initWithJSON:roomJson];
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

#pragma mark - 初始化数据
- (void)initData{
    
}


- (void) joinClass{
    NSLog(@"inviteStart ----  ");
    NSString * nickName = [APPObjOnce sharedAppOnce].currentUser.nickname;
    [ConfigManager sharedInstance].eventId = _selectRoom.event_id;
    [ConfigManager sharedInstance].nickName = nickName;
    [[ConfigManager sharedInstance] saveConfig];

    NSDictionary *codeDict = @{@"eid":_selectRoom.event_id, @"name":nickName};
    RoomVC *roomVC = [[RoomVC alloc] initWith:codeDict];
    [self.navigationController pushViewController:roomVC animated:YES];
}


@end
