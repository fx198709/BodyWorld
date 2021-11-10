//
//  UserCenterViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/7/20.
//

#import "SystemViewController.h"
#import "ResetPwdController.h"
#import "LoginController.h"
#import "YYMySelectDatePickerView.h"
#import "ChangeInfoViewController.h"


@interface SystemViewController () <YYMySelectDatePickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pwdTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nickTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UILabel *languageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;


@property (weak, nonatomic) IBOutlet UILabel *genderTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;


@property (weak, nonatomic) IBOutlet UILabel *mobileTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;


@property (weak, nonatomic) IBOutlet UILabel *birthdayTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;


@property (weak, nonatomic) IBOutlet UILabel *heightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;


@property (weak, nonatomic) IBOutlet UILabel *weightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;


@property (weak, nonatomic) IBOutlet UILabel *cityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


@property (weak, nonatomic) IBOutlet UILabel *introductionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;


@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@property (nonatomic, strong) YYMySelectDatePickerView *datePicker;


@end

@implementation SystemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = ChineseStringOrENFun(@"系统设置",@"PERSONAL SETTING");
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)initUI {
    self.pwdTitleLabel.text = ChineseStringOrENFun(@"修改密码", @"Change the password");
    self.headTitleLabel.text = ChineseStringOrENFun(@"头像", @"Head portrait");
    self.nickTitleLabel.text = ChineseStringOrENFun(@"昵称", @"Nickname");
    self.languageTitleLabel.text = ChineseStringOrENFun(@"语言", @"Language");
    self.genderTitleLabel.text = ChineseStringOrENFun(@"性别", @"Gender");
    self.mobileTitleLabel.text = ChineseStringOrENFun(@"手机号", @"Telephone");
    self.birthdayTitleLabel.text = ChineseStringOrENFun(@"生日", @"Date of birth");
    self.heightTitleLabel.text = ChineseStringOrENFun(@"身高", @"Height");
    self.weightTitleLabel.text = ChineseStringOrENFun(@"体重", @"Weight");
    self.cityTitleLabel.text = ChineseStringOrENFun(@"所在城市", @"Location");
    self.introductionTitleLabel.text = ChineseStringOrENFun(@"介绍", @"Introduction");
    
    self.logoutBtn.titleLabel.text = ChineseStringOrENFun(@"退出登录", @"Logout");
    
    [self.headImg cornerHalfWithBorderColor:[UIColor darkGrayColor]];
    [self.logoutBtn cornerWithRadius:4.0 borderColor:[self.logoutBtn backgroundColor]];
    
}

- (void)loadData {
    self.languageLabel.text = ISChinese() ? @"中文" : @"English";

    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    
    self.nickLabel.text = user.nickname;
    self.genderLabel.text = SexNameFormGender(user.gender);
    self.birthdayLabel.text = user.birthday;
    
}

- (YYMySelectDatePickerView *)datePicker {
    if (_datePicker == nil) {
        _datePicker = ViewByNibWithClass([YYMySelectDatePickerView class]);
        _datePicker.delegate = self;
    }
    return _datePicker;
}

#pragma mark - Action


//修改密码
-(IBAction)changePwd:(id)sender {
    ResetPwdController *nextVC = VCBySBName(@"ResetPwdController");
    [self.navigationController pushViewController:nextVC animated:YES];
}

//修改头像
- (IBAction)changeHeadImg:(id)sender {
    
}

//修改昵称
-(IBAction)changeNickName:(id)sender {
    
}

//修改语言
-(IBAction)changeLanguage:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"English" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showChangeLanguageTip:LanguageEnum_English];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"中文" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showChangeLanguageTip:LanguageEnum_Chinese];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"取消", @"Cancel") style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)showChangeLanguageTip:(LanguageEnum)languageEnum {
    NSString *tips = ChineseStringOrENFun(@"是否确认更改默认语言?", @"the display lauguage will been changed");
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:ChineseStringOrENFun(@"提示", @"tips") message:tips preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:ChineseStringOrENFun(@"确定", @"yes") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //保存当前语言
        
        [ConfigManager sharedInstance].language = languageEnum;
        [[ConfigManager sharedInstance] saveConfig];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:ChineseStringOrENFun(@"取消", @"no") style:UIAlertActionStyleCancel handler:nil];
    [alter addAction:cancle];
    [alter addAction:sure];
    
    [self presentViewController:alter animated:YES completion:nil];
}

//修改性别
-(IBAction)changeSex:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [ac addAction:[UIAlertAction actionWithTitle:SexNameFormGender(GenderEnum_Male) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeSexFromServer:GenderEnum_Male];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:SexNameFormGender(GenderEnum_Female) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeSexFromServer:GenderEnum_Female];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"取消", @"Cancel") style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)changeSexFromServer:(GenderEnum)gender {
    //todo:
    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    user.gender = gender;
    [self loadData];
}


//修改手机号
-(IBAction)changeMobile:(id)sender {
    //不能修改手机号
}

//修改生日
-(IBAction)changeBirthday:(id)sender {
    [self.datePicker showWithAnimated:YES completedBlock:nil];
}

//修改身高
-(IBAction)changeHeight:(id)sender {
    [self goToChangeInfoViewController:ChangeTypeEnum_Height];
}

//修改体重
-(IBAction)changeWeight:(id)sender {
    [self goToChangeInfoViewController:ChangeTypeEnum_Weight];
}

//修改所在城市
-(IBAction)changeCity:(id)sender {
    
}

//修改介绍
-(IBAction)ChangeIntroduction:(id)sender {
    [self goToChangeInfoViewController:ChangeTypeEnum_Info];
}

//跳转到修改页面
- (void)goToChangeInfoViewController:(ChangeTypeEnum)type {
    ChangeInfoViewController *nextVC = VCBySBName(@"ChangeInfoViewController");
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)loginOut:(id)sender {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"确定退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alter addAction:sure];
    [alter addAction:cancle];
    
    [self presentViewController:alter animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - YYMySelectDatePickerViewDelegate

- (void)selectDatePickerDidSelectDate:(NSDate *)date {
    //todo

    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    user.birthday =  [date mt_formatString:YYDateFormatter_Year];;
    [self loadData];
}

- (void)selectDatePickerDidClickCancel {
}

@end
