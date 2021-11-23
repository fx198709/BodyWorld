//
//  ViewController.m
//  fitworld
//
//  Created by wangwei on 2021/7/1.
//

#import "AppDelegate.h"
#import "RegisterController.h"
#import "LoginController.h"
#import "SelectCountryCodeViewController.h"

#import "FITAPI.h"
#import "UIDeps.h"
#import "UserInfo.h"

@interface RegisterController ()

@property (weak, nonatomic) IBOutlet UIButton *zhLanguageBtn;
@property (weak, nonatomic) IBOutlet UIButton *enLanguageBtn;

@property (weak, nonatomic) IBOutlet UIButton *accountBtn;


@property (weak, nonatomic) IBOutlet UIView *nameView;

@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *getCountryBtn;


@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;



@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self reloadTextView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    
    [APPObjOnce sharedAppOnce].isLogining = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [APPObjOnce sharedAppOnce].isLogining = NO;
}

- (void)initView {
    [self.nameView cornerHalfWithBorderColor:[self.nameField backgroundColor]];
    [self.codeView cornerHalfWithBorderColor:[self.codeView backgroundColor]];
    [self.codeBtn cornerHalfWithBorderColor:[self.codeBtn backgroundColor]];
    [self.loginBtn cornerHalfWithBorderColor:[self.loginBtn backgroundColor]];
}

- (void)reloadTextView {
    [self.loginBtn setTitle:ChineseStringOrENFun(@"登录", @"Login") forState:UIControlStateNormal];
    [self.accountBtn setTitle:ChineseStringOrENFun(@"密码登录", @"Account Login") forState:UIControlStateNormal];
    [self.codeBtn setTitle:ChineseStringOrENFun(@"获取验证码", @"Request Code") forState:UIControlStateNormal];
    
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入账号", @"Please enter the account number") attributes:attr];
    self.codeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"短信验证码", @"SMS Code") attributes:attr];
}

#pragma mark - data

#pragma mark - action

//修改语言
- (IBAction)ChangeLanguage:(UIButton *)sender {
    LanguageEnum language;
    if (sender == self.enLanguageBtn) {
        language = LanguageEnum_English;
    } else {
        language = LanguageEnum_Chinese;
    }
    
    //保存当前语言
    [ConfigManager sharedInstance].language = language;
    [[ConfigManager sharedInstance] saveConfig];
    [self reloadTextView];
}


- (IBAction)goToAccountLogin:(id)sender {
    [self resignFirstResponder];
    LoginController *nextVC = VCBySBName(@"LoginController");
    [self.navigationController setViewControllers:@[nextVC] animated:YES];
}


//获取验证码
- (IBAction)getValidCode:(id)sender {
    [self.view endEditing:YES];
    
    NSString *code = self.countryCodeLabel.text;
    if ([NSString isNullString:code]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"请选择地区编码", @"Please select country code")];
        return;
    }
    
    NSString *number = self.nameField.text;
    if ([NSString isNullString:number]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"请输入手机号", @"Please enter the account number")];
        return;
    }
    
    NSString *mobile = [NSString stringWithFormat:@"%@:%@", code, number];
    NSDictionary *param = @{@"account":mobile};
    [[AFAppNetAPIClient manager] POST:@"captcha" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"====respong:%@", responseObject);
        //显示倒计时
        [self.codeBtn countdownWithStartTime:60
                                       title:GetValidCodeBtnTitle
                              countDownTitle:GetValidCodeBtnTitle_H];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

//点击切换区码
- (IBAction)clickSelectCode:(id)sender {
    [self performSegueWithIdentifier:@"selectCodeSegue" sender:nil];
}

- (IBAction)clickLogin {
    [self resignFirstResponder];
    
    NSString *name = self.nameField.text;
    NSString *pwd = self.codeField.text;
    
    if ([NSString isNullString:name] || [NSString isNullString:pwd]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"账号和验证码不能为空",
                                                          @"Account and code can not be emtpy")];
        return;
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@captcha/validate", FITAPI_HTTPS_PREFIX];
    NSLog(@"uuid>>>>%@", [UIDevice currentDevice].identifierForVendor.UUIDString);
    [MTHUD showLoadingHUD];
    NSString *account = [NSString stringWithFormat:@"%@:%@",self.countryCodeLabel.text,name];
    
    NSDictionary *dict = @{ @"account":account,  @"captcha":pwd};
    [[AFHTTPSessionManager manager] POST:strUrl
                              parameters:dict
                                 headers:nil
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MTHUD hideHUD];
        [[APPObjOnce sharedAppOnce] loginSuccess:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MTHUD hideHUD:YES completedBlock:^{
            [MTHUD showDurationNoticeHUD:error.localizedDescription];
        }];
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"selectCodeSegue"]) {
        SelectCountryCodeViewController *nextVC = segue.destinationViewController;
        nextVC.callback = ^(CountryCode *code) {
            self.countryCodeLabel.text = [NSString stringWithFormat:@"+%d", code.code];
        };
    }
}

@end
