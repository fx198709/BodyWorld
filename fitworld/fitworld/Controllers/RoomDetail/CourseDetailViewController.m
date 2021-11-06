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

@interface CourseDetailViewController ()

@end

@implementation CourseDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
        
    self.view.backgroundColor = UIColor.blackColor;
    
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"coursedetail_top"];
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
    topImgBotView.backgroundColor = UIColor.darkGrayColor;
    topImgBotView.alpha = 0.7;
    [self.view addSubview:topImgBotView];
    [topImgBotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(topImgView).multipliedBy(0.3);
        make.bottom.mas_equalTo(topImgView.mas_bottom);
    }];
    
    UILabel *courseNameLl = [[UILabel alloc] init];
    courseNameLl.text = self.selectRoom.course.name;
    courseNameLl.textColor = UIColor.whiteColor;
    [topImgBotView addSubview:courseNameLl];
    [courseNameLl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgBotView).offset(10);
        make.left.equalTo(topImgBotView).offset(10);
        make.width.mas_equalTo(100);
    }];
    
    UILabel *createUserName = [[UILabel alloc] init];
    NSDictionary *roomCreatorDic = self.selectRoom.room_creator;
    createUserName.text = [NSString stringWithFormat: @"%@ %@", self.selectRoom.room_creator.nickname, self.selectRoom.course.type];
    createUserName.textColor = UIColor.whiteColor;
    [topImgBotView addSubview:createUserName];
    [createUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(courseNameLl.mas_bottom).offset(10);
        make.left.equalTo(topImgBotView).offset(10);
        make.width.mas_equalTo(100);
    }];
    
    UIView *userLeftView = [[UIView alloc]init];
    userLeftView.alpha = 0.8;
    userLeftView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:userLeftView];
    
    UILabel *getTimeLabel = [[UILabel alloc] init];
    getTimeLabel.text = [NSString stringWithFormat:@"%d", _selectRoom.course.duration]; //@"5";
    getTimeLabel.font = [UIFont systemFontOfSize:10];
    getTimeLabel.textColor= UIColor.whiteColor;
    getTimeLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"Time(mins)";
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor= UIColor.whiteColor;

    timeLabel.adjustsFontSizeToFitWidth = YES;

    [userLeftView addSubview:timeLabel];
    [userLeftView addSubview:getTimeLabel];
    
    [getTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(userLeftView);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getTimeLabel.mas_bottom).offset(2);
        make.centerX.equalTo(userLeftView);
    }];
    
    UIView *userMidView = [[UIView alloc]init];
//    userMidView.alpha = 0.7;
    userMidView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:userMidView];

    UILabel *getHeartLabel = [[UILabel alloc] init];
    getHeartLabel.text = @"0";
    getHeartLabel.font = [UIFont systemFontOfSize:10];
    getHeartLabel.textColor= UIColor.whiteColor;
    getHeartLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *heartLabel = [[UILabel alloc] init];
    heartLabel.text = @"Heart rate(Bpm)";
    heartLabel.font = [UIFont systemFontOfSize:10];
    heartLabel.textColor= UIColor.whiteColor;
    heartLabel.adjustsFontSizeToFitWidth = YES;

    [userMidView addSubview:heartLabel];
    [userMidView addSubview:getHeartLabel];
    
    [getHeartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(userMidView);
    }];
    
    [heartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getHeartLabel.mas_bottom).offset(2);
        make.centerX.equalTo(userMidView);
    }];
    
    
    UIView *userRightView = [[UIView alloc]init];
    userRightView.alpha = 0.8;
    userRightView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:userRightView];
    
    UILabel *getKcalLabel = [[UILabel alloc] init];
    getKcalLabel.text = [NSString stringWithFormat:@"%d", _selectRoom.course.cal];
    getKcalLabel.font = [UIFont systemFontOfSize:10];
    getKcalLabel.textColor= UIColor.whiteColor;
    getKcalLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *kcalLabel = [[UILabel alloc] init];
    kcalLabel.text = @"Consumption(Kcal)";
    kcalLabel.textColor= UIColor.whiteColor;
    kcalLabel.font = [UIFont systemFontOfSize:10];
    kcalLabel.adjustsFontSizeToFitWidth = YES;

    [userRightView addSubview:kcalLabel];
    [userRightView addSubview:getKcalLabel];
    
    [getKcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(userRightView);
    }];
    
    [kcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getKcalLabel.mas_bottom).offset(2);
        make.centerX.equalTo(userRightView);
    }];
    
    [userLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImgView);
        make.top.equalTo(topImgView.mas_bottom).offset(0);
        make.height.mas_equalTo(50);
        make.right.equalTo(userMidView.mas_left);
    }];
    
    [userMidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView);
        make.height.equalTo(userLeftView);
        make.right.equalTo(userRightView.mas_left);
    }];

    [userRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView);
        make.right.equalTo(topImgView);
        make.height.equalTo(userLeftView);
        make.width.equalTo(@[userLeftView, userMidView]);
    }];
    
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
    NSString * nickName = @"123";
    [ConfigManager sharedInstance].eventId = _selectRoom.event_id;
    [ConfigManager sharedInstance].nickName = nickName;
    [[ConfigManager sharedInstance] saveConfig];

    NSDictionary *codeDict = @{@"eid":_selectRoom.event_id, @"name":nickName};
    RoomVC *roomVC = [[RoomVC alloc] initWith:codeDict];
    [self.navigationController pushViewController:roomVC animated:YES];
}


@end
