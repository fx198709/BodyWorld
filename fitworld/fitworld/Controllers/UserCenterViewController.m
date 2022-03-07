//
//  UserCenterViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/7/20.
//

#import "UserCenterViewController.h"
#import "UIDeps.h"
#import "FITAPI.h"
#import "MTCalendarView.h"
#import "PractiseWeek.h"
#import "PractiseStatic.h"

#import "UserCenterInfo.h"

@interface UserCenterViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcatLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcatTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *killoLabel;
@property (weak, nonatomic) IBOutlet UILabel *killoTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UILabel *historyTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *historyDetailBtn;
@property (weak, nonatomic) IBOutlet UILabel *historyCountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyCountLabel;

//团课
@property (weak, nonatomic) IBOutlet UILabel *tuanTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuanCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tuanTimeLabel;

//对练课
@property (weak, nonatomic) IBOutlet UILabel *dlTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dlCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dlTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *calenderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *calenderTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *calenderContainerView;

@property (nonatomic, strong) MTCalendarView *calenderView;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSArray *checkDays;

@property (nonatomic, strong) UserCenterInfo *centerInfo;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = ChineseStringOrENFun(@"个人中心", @"Dashboard");
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addSettingBtn];
    [self loadCurrentInfoData];
    [self getUserDataFromServer];
}

- (void)initView {
    [self.historyView cornerTopWithRadius:16 borderColor:self.historyView.backgroundColor];
    [self.headImg cornerHalfWithBorderColor:[UIColor darkGrayColor]];
    
    self.totalTimeTitleLabel.text = ChineseStringOrENFun(@"累计锻炼时长(min)", @"Training time(min)");
    self.kcatTitleLabel.text = ChineseStringOrENFun(@"卡路里消耗(kcal)", @"Calories burned(kcal)");
    self.killoTitleLabel.text = ChineseStringOrENFun(@"里程", @"Ranking");
    
    self.historyTitleLabel.text = ChineseStringOrENFun(@"历史统计", @"Historical Data");
    self.historyCountTitleLabel.text = ChineseStringOrENFun(@" 次", @" times");
    
    self.tuanTitleLabel.text = Text_Group;
    self.dlTitleLabel.text = Text_Training;
    
    self.calenderTitleLabel.text = @"";//ChineseStringOrENFun(@"最近30天打卡记录", @"30 Day activity");
    self.endDate = [NSDate date];
    self.startDate = [self.endDate mt_previousDate:29];
    NSString *chDayStr =  [NSString stringWithFormat:@"%ld月%ld日 - %ld月%ld日",
                           self.startDate.mt_month, self.startDate.mt_day,
                           self.endDate.mt_month, self.endDate.mt_day];
    NSString *enDayStr = [NSString stringWithFormat:@"%@ %ld - %@ %ld",
                          self.startDate.mt_englishtMonth, self.startDate.mt_day,
                          self.endDate.mt_englishtMonth, self.endDate.mt_day];
    self.calenderTimeLabel.text = ChineseStringOrENFun(chDayStr, enDayStr);
    [self addCalendarView];
}

- (void)loadCurrentInfoData {
    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    self.headImg.hidden = [NSString isNullString:user.avatar];
    
    NSString *url = [FITAPI_HTTPS_ROOT stringByAppendingString:user.avatar];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:url]
                    placeholderImage:[UIImage imageNamed:@"choose_course_foot_logo3_unselected"]];
    self.nameLabel.text = user.nickname;
    self.cityLabel.text = [NSString stringWithFormat:@"%@, %@", user.city, user.country];
}

//加载数据
- (void)loadUserData {
    
    self.totalTimeLabel.text = [NSString stringWithFormat:@"%.0ld",self.centerInfo.user_info.duration/60];
    self.kcatLabel.text = IntToString(self.centerInfo.week_data.cal);
    self.killoLabel.text = IntToString(self.centerInfo.week_data.total);
    
    self.historyCountLabel.text = IntToString(self.centerInfo.total);
    self.dlCountLabel.text = [NSString stringWithFormat:@"%d%@", self.centerInfo.buddy.count,ChineseStringOrENFun(@" 次", @" times")];
    self.dlTimeLabel.text = [NSString stringWithFormat:@"%d min",
                             (int)(self.centerInfo.buddy.duration / 60.0)];
    if (self.centerInfo.buddy.duration / 60.0/60 > 1) {
//        超过一个小时
        self.dlTimeLabel.text = [NSString stringWithFormat:@"%d h %d min",(int)(self.centerInfo.buddy.duration / 3600),
                                 (int)((self.centerInfo.buddy.duration % 3600)/60)];
    }
    
    self.tuanCountLabel.text = [NSString stringWithFormat:@"%d%@", self.centerInfo.group.count,ChineseStringOrENFun(@" 次", @" times")];
    self.tuanTimeLabel.text = [NSString stringWithFormat:@"%d min",
                               (int)(self.centerInfo.group.duration / 60.0)];
    if (self.centerInfo.group.duration / 60.0/60 > 1) {
//        超过一个小时
        self.tuanTimeLabel.text = [NSString stringWithFormat:@"%d h %d min",(int)(self.centerInfo.group.duration / 3600),
                                 (int)((self.centerInfo.group.duration % 3600)/60)];
    }
    if (self.centerInfo.day_of_month != nil && self.centerInfo.day_of_month.count > 0) {
        NSMutableArray *days = [NSMutableArray arrayWithCapacity:self.centerInfo.day_of_month.count];
        for (NSNumber *times in self.centerInfo.day_of_month) {
            NSString *dayStr = ReachYearANDTime(times.longValue);
            NSDate *day = [NSDate mt_dateFromString:dayStr format:@"yyyy-MM-dd HH:mm"];
            [days addObject:day];
        }
        self.checkDays = days;
    } else {
        self.checkDays = nil;
    }
    [self reloadCalenderView];
}


- (void)addSettingBtn{
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (@available(iOS 11, *)) {
        [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
        }];
    } else {
        [settingBtn setFrame:CGRectMake(0, 0, 40, 40)];
    }
    UIImage *bgImg = [UIImage imageNamed:@"center_setting"];
    [settingBtn setImage:bgImg forState:UIControlStateNormal];
    [settingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(onClickSetting) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)addCalendarView {
    [self.calenderContainerView clearAllSubViews];
    self.calenderView = [[MTCalendarView alloc] init];
    self.calenderView.backgroundColor = self.calenderContainerView.superview.backgroundColor;
    [self.calenderContainerView addSubview:self.calenderView];
    [self.calenderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.calenderContainerView);
        make.height.mas_equalTo(300);
    }];
    [self reloadCalenderView];
}

- (void)reloadCalenderView {
    self.calenderView.startDate = self.startDate;
    self.calenderView.endDate = self.endDate;
    self.calenderView.markList = self.checkDays;
    [self.calenderView reloadData];
}

#pragma mark - action


//跳转到历史详情
- (IBAction)goToHistoryList:(id)sender {
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

#pragma mark - server

- (void)getUserDataFromServer {
    NSString *url = @"practise/info";
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSDictionary *result = [responseObject objectForKey:@"recordset"];
        NSError *error;
        UserCenterInfo *centerInfo = [[UserCenterInfo alloc] initWithDictionary:result error:&error];
        if (error == nil) {
            self.centerInfo = centerInfo;
            [self loadUserData];
        } else {
            [MTHUD showDurationNoticeHUD:error.localizedDescription];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showChangeFailedError:error];
    }];
}


@end
