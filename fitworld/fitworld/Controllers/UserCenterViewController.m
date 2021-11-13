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


@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcatLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcatTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *killoLabel;
@property (weak, nonatomic) IBOutlet UILabel *killoTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *historyView;
@property (weak, nonatomic) IBOutlet UILabel *historyTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *historyDetailBtn;
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

@property (nonatomic, strong) CalendarView *calendar;

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = ChineseStringOrENFun(@"个人中心", @"User Center");
    [self initView];
    [self getPractiseWeek];
    [self getPractiseStatic];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addSettingBtn];
}

- (void)initView {
    [self.historyView cornerTopWithRadius:16 borderColor:self.historyView.backgroundColor];
    [self.headImg cornerHalfWithBorderColor:[UIColor darkGrayColor]];
    
    self.totalTimeTitleLabel.text = ChineseStringOrENFun(@"累计锻炼时长(min)", @"Training time(min)");
    self.kcatTitleLabel.text = ChineseStringOrENFun(@"卡路里消耗(kcal)", @"Calories burned(kcal)");
    self.killoTitleLabel.text = ChineseStringOrENFun(@"里程", @"");
    
    self.historyTitleLabel.text = ChineseStringOrENFun(@"历史统计", @"");
    
    self.tuanTitleLabel.text = ChineseStringOrENFun(@"团课", @"");
    self.dlTitleLabel.text = ChineseStringOrENFun(@"对练课", @"");
    
    self.calenderTitleLabel.text = ChineseStringOrENFun(@"最近30天打卡记录", @"");
    //todo:
    self.calenderTimeLabel.text = @"10月14-11月12";
    
    [self addCalendarView];
    [self loadUserData];
}


- (void)loadUserData {
    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    self.headImg.hidden = [NSString isNullString:user.avatar];
    
    NSString *url = [FITAPI_HTTPS_ROOT stringByAppendingString:user.avatar];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:url]
                    placeholderImage:[UIImage imageNamed:@"choose_course_foot_logo3_unselected"]];
    self.nameLabel.text = user.nickname;
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
    self.calendar = [[CalendarView alloc] init];
    self.calendar.backgroundColor = self.calenderContainerView.backgroundColor;
    [self.calenderContainerView addSubview: self.calendar];
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.calenderContainerView);
        make.height.mas_equalTo(300);
    }];
    
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
        //        practiseWeek = [[PractiseWeek alloc] initWithJSON:responseObject[@"recordset"]];
        //        timesTxtLabel.text = [NSString stringWithFormat:@"%d times", practiseWeek.total];
        //        getKcalLabelw.text = [NSString stringWithFormat:@"%d", practiseWeek.cal];
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
        //        historyCountTxtLb.text = [NSString stringWithFormat:@"%d", practiseStatic.total];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure ---- %@", error);
    }];
}


@end
