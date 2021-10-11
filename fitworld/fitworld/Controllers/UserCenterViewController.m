//
//  UserCenterViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/7/20.
//

#import "UserCenterViewController.h"
#import "UIDeps.h"
#import "FITAPI.h"
#import "CalendarView.h"
#import "PrefixHeader.h"
#import "AFNetworking.h"
#import "PractiseWeek.h"
#import "PractiseStatic.h"

@interface UserCenterViewController ()
@property (nonatomic, strong) CalendarView *calendar;
@end

@implementation UserCenterViewController{
    PractiseWeek *practiseWeek;
    UILabel *timesTxtLabel;
    UILabel *getKcalLabelw;
    UILabel *historyCountTxtLb;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = UIColor.blackColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //设置图片
    [button setTitle:@"设置" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [button addTarget:self action:@selector(onClickSetting) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"coursedetail_top"];
    [self.view addSubview:topImgView];
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(self.view.bounds.size.height / 4);
    }];
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, 40, 40)];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, self.userInfo.avatar]]];
    leftImageView.contentMode = UIViewContentModeScaleAspectFill;
    leftImageView.layer.masksToBounds = YES;
    leftImageView.layer.cornerRadius = 20;
    [leftImageView.layer setBorderWidth:2];
    [leftImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [topImgView addSubview:leftImageView];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 100, 20)];
    userNameLabel.adjustsFontSizeToFitWidth = YES;
    userNameLabel.textColor = UIColor.whiteColor;
    userNameLabel.text = self.userInfo.username;
    [topImgView addSubview:userNameLabel];
    
    UILabel *nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, 100, 20)];
    nickNameLabel.adjustsFontSizeToFitWidth = YES;
    nickNameLabel.textColor = UIColor.whiteColor;
//    nickNameLabel.text = self.userInfo.nickname;
    nickNameLabel.font = [UIFont systemFontOfSize:12];
    [topImgView addSubview:nickNameLabel];

    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:rightView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgView.mas_bottom);
        make.left.equalTo(topImgView);
        make.right.equalTo(rightView.mas_left);
        make.height.mas_equalTo(50);
    }];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftView);
        make.left.equalTo(leftView.mas_right);
        make.right.equalTo(topImgView);
        make.width.height.equalTo(leftView);
    }];
    
    UILabel *gettrainTimeLabel = [[UILabel alloc] init];
    gettrainTimeLabel.adjustsFontSizeToFitWidth = YES;
    gettrainTimeLabel.textColor = UIColor.whiteColor;
    gettrainTimeLabel.text = [NSString stringWithFormat: @"%d", self.userInfo.duration];
    gettrainTimeLabel.font = [UIFont systemFontOfSize:12];
    [leftView addSubview:gettrainTimeLabel];
    [gettrainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(leftView);
    }];
    
    UILabel *trainTimeLabel = [[UILabel alloc] init];
    trainTimeLabel.adjustsFontSizeToFitWidth = YES;
    trainTimeLabel.textColor = UIColor.whiteColor;
    trainTimeLabel.text = @"Training time(hours)";
    trainTimeLabel.font = [UIFont systemFontOfSize:10];
    [leftView addSubview:trainTimeLabel];
    [trainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gettrainTimeLabel.mas_bottom);
        make.centerX.equalTo(leftView);
    }];
    
    
    UILabel *getKcalLabel = [[UILabel alloc] init];
    getKcalLabel.adjustsFontSizeToFitWidth = YES;
    getKcalLabel.textColor = UIColor.whiteColor;
    getKcalLabel.text = [NSString stringWithFormat: @"%d", self.userInfo.cal];
    getKcalLabel.font = [UIFont systemFontOfSize:12];
    [rightView addSubview:getKcalLabel];
    [getKcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(rightView);
    }];
    
    UILabel *kcalLabel = [[UILabel alloc] init];
    kcalLabel.adjustsFontSizeToFitWidth = YES;
    kcalLabel.textColor = UIColor.whiteColor;
    kcalLabel.text = @"Calories burned(Kcal)";
    kcalLabel.font = [UIFont systemFontOfSize:10];
    [rightView addSubview:kcalLabel];
    [kcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gettrainTimeLabel.mas_bottom);
        make.centerX.equalTo(rightView);
    }];
    
    UIView *summaryBgView = [[UIView alloc] init];
    summaryBgView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:summaryBgView];
    [summaryBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(120);
    }];
    
    UILabel *summaryTxtLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    summaryTxtLabel.adjustsFontSizeToFitWidth = YES;
    summaryTxtLabel.text = @"Summary this week";
    summaryTxtLabel.textColor = UIColor.whiteColor;
    summaryTxtLabel.font = [UIFont systemFontOfSize:12];
    [summaryBgView addSubview:summaryTxtLabel];
    
    timesTxtLabel = [[UILabel alloc] init];
    timesTxtLabel.adjustsFontSizeToFitWidth = YES;
//    timesTxtLabel.text = [NSString stringWithFormat:@"%@ times", practiseWeek.total];
    timesTxtLabel.textColor = UIColor.whiteColor;
    timesTxtLabel.font = [UIFont systemFontOfSize:12];
    [summaryBgView addSubview:timesTxtLabel];
    [timesTxtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(summaryBgView).offset(20);
        make.right.equalTo(summaryBgView.mas_right).offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    UIImageView *summaryImgView = [[UIImageView alloc] init];
    summaryImgView.image = [UIImage imageNamed:@"uc_summary"];
    [summaryBgView addSubview:summaryImgView];
    [summaryImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timesTxtLabel.mas_bottom);
        make.left.right.bottom.equalTo(summaryBgView);
    }];
    
    UILabel *trainTxtLabel = [[UILabel alloc] init];
    trainTxtLabel.adjustsFontSizeToFitWidth = YES;
    trainTxtLabel.text = @"Training Time \n    (hours)";
    trainTxtLabel.textColor = UIColor.whiteColor;
    trainTxtLabel.font = [UIFont systemFontOfSize:12];
    trainTxtLabel.numberOfLines = 0;
    [summaryImgView addSubview:trainTxtLabel];
    [trainTxtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(summaryImgView).offset(5);
        make.center.equalTo(trainTimeLabel);
        
    }];
    
    UILabel *getTrainTxtLabel = [[UILabel alloc] init];
    getTrainTxtLabel.adjustsFontSizeToFitWidth = YES;
    getTrainTxtLabel.text = @"0.0";
    getTrainTxtLabel.textColor = UIColor.whiteColor;
    getTrainTxtLabel.font = [UIFont systemFontOfSize:12];
    [summaryImgView addSubview:getTrainTxtLabel];
    [getTrainTxtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(trainTxtLabel.mas_bottom);
        make.centerX.equalTo(trainTxtLabel);
    }];
    
    UILabel *kcalTxtLabel = [[UILabel alloc] init];
    kcalTxtLabel.adjustsFontSizeToFitWidth = YES;
    kcalTxtLabel.text = @"Calories burned(Kcal) \n    (kcal)";
    kcalTxtLabel.textColor = UIColor.whiteColor;
    kcalTxtLabel.font = [UIFont systemFontOfSize:12];
    kcalTxtLabel.numberOfLines = 0;
    [summaryImgView addSubview:kcalTxtLabel];
    [kcalTxtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(summaryImgView).offset(5);
        make.center.equalTo(kcalLabel);
    }];
    
    UILabel *getKcalLabelw = [[UILabel alloc] init];
    getKcalLabelw.adjustsFontSizeToFitWidth = YES;
    getKcalLabelw.text = @"0.0";
    getKcalLabelw.textColor = UIColor.whiteColor;
    getKcalLabelw.font = [UIFont systemFontOfSize:12];
    [summaryImgView addSubview:getKcalLabelw];
    [getKcalLabelw mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kcalTxtLabel.mas_bottom);
        make.centerX.equalTo(kcalTxtLabel);
    }];
    
    UIView *historyBgView = [[UIView alloc] init];
    historyBgView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:historyBgView];
    [historyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(summaryBgView.mas_bottom).offset(10);
        make.left.right.equalTo(summaryBgView);
        make.height.mas_equalTo(40);
    }];
    UILabel *historyTxtLb = [[UILabel alloc] init];
    historyTxtLb.adjustsFontSizeToFitWidth = YES;
    historyTxtLb.text = @"Historical statistics";
    historyTxtLb.textColor = UIColor.whiteColor;
    historyTxtLb.font = [UIFont systemFontOfSize:12];
    [historyBgView addSubview:historyTxtLb];
    [historyTxtLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(historyBgView).offset(10);
    }];
    
    historyCountTxtLb = [[UILabel alloc] init];
    historyCountTxtLb.adjustsFontSizeToFitWidth = YES;
//    historyCountTxtLb.text = @"XXX >";
    historyCountTxtLb.textColor = UIColor.whiteColor;
    historyCountTxtLb.font = [UIFont systemFontOfSize:12];
    [historyBgView addSubview:historyCountTxtLb];
    [historyCountTxtLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyBgView).offset(10);
        make.right.equalTo(historyBgView).offset(-5);
    }];
    
    // TODO
    UIView *groupClassBgView = [[UIView alloc] init];
    groupClassBgView.backgroundColor = UIColor.darkGrayColor;
    [self.view addSubview:groupClassBgView];
    [groupClassBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(historyBgView.mas_bottom);
        make.left.right.equalTo(historyBgView);
        make.height.mas_equalTo(5);
    }];
    UILabel *groupClassTxtLb = [[UILabel alloc] init];
    groupClassTxtLb.adjustsFontSizeToFitWidth = YES;
    groupClassTxtLb.text = @"Group class";
    groupClassTxtLb.textColor = UIColor.whiteColor;
    groupClassTxtLb.font = [UIFont systemFontOfSize:12];
    [groupClassBgView addSubview:groupClassTxtLb];
    [groupClassTxtLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(historyBgView).offset(30);
    }];
    
    UIView *buddyTrainingBgView = [[UIView alloc] init];
    buddyTrainingBgView.backgroundColor = UIColor.blackColor;
    [self.view addSubview:buddyTrainingBgView];
    [buddyTrainingBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(groupClassBgView.mas_bottom);
        make.left.right.equalTo(groupClassBgView);
        make.height.mas_equalTo(40);
    }];
    UILabel *buddyTrainingTxtLb = [[UILabel alloc] init];
    buddyTrainingTxtLb.adjustsFontSizeToFitWidth = YES;
    buddyTrainingTxtLb.text = @"Buddy training";
    buddyTrainingTxtLb.textColor = UIColor.whiteColor;
    buddyTrainingTxtLb.font = [UIFont systemFontOfSize:12];
    [buddyTrainingBgView addSubview:buddyTrainingTxtLb];
    [buddyTrainingTxtLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(buddyTrainingBgView).offset(10);
    }];
    
    
    [self.view addSubview: self.calendar];
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(buddyTrainingBgView.mas_bottom);
        make.left.right.equalTo(buddyTrainingBgView);
        make.height.mas_equalTo(200);
    }];
    
    
    [self getPractiseWeek];
    [self getPractiseStatic];

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

- (void)onClickSetting{
    NSLog(@"onClickSetting");

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //这里的id填刚刚设置的值,vc设置属性就可以给下个页面传参数了
    UIViewController *vc = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"systemVC"];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (CalendarView *)calendar {
    if (!_calendar) {
        
        _calendar = [[CalendarView alloc] initWithFrame:CGRectMake(10, 30, ScreenWidth - 20, 200)];
        _calendar.backgroundColor = UIColor.blackColor;
    }
    return _calendar;
}

- (void) getPractiseWeek
{

    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSLog(@"initroom userToken ---- %@", userToken);

    NSString *strUrl = [NSString stringWithFormat:@"%@practise/week", FITAPI_HTTPS_PREFIX];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];

    [manager GET:strUrl parameters:nil headers:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject ---- %@", responseObject);
        practiseWeek = [[PractiseWeek alloc] initWithJSON:responseObject[@"recordset"]];
        timesTxtLabel.text = [NSString stringWithFormat:@"%d times", practiseWeek.total];
        getKcalLabelw.text = [NSString stringWithFormat:@"%d", practiseWeek.cal];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"failure ---- %@", error);
    }];
}

- (void) getPractiseStatic
{

    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSLog(@"initroom userToken ---- %@", userToken);

    NSString *strUrl = [NSString stringWithFormat:@"%@practise/statistic", FITAPI_HTTPS_PREFIX];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];

    [manager GET:strUrl parameters:nil headers:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject ---- %@", responseObject);
        PractiseStatic *practiseStatic = [[PractiseStatic alloc] initWithJSON:responseObject[@"recordset"]];
        historyCountTxtLb.text = [NSString stringWithFormat:@"%d", practiseStatic.total];

       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"failure ---- %@", error);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear %@",self.class);
}


@end
