//
//  ViewController.m
//  fitworld
//
//  Created by wangwei on 2021/7/1.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import "RegisterController.h"
#import "SelectCountryCodeViewController.h"
#import "ProtocolView.h"

#import "FITAPI.h"
#import "UIDeps.h"
#import "UserInfo.h"

#import "APPObjOnce.h"



@interface LoginController ()

@property (weak, nonatomic) IBOutlet UIView *loginview;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;

@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;

@property (nonatomic, strong) ProtocolView *protocolView;



@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self reloadTextView];
    _loginview.layer.cornerRadius = 24;
    _loginview.clipsToBounds = YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showProtocolView];
}

- (void)initView {
    [self.nameField cornerHalfWithBorderColor:[self.nameField backgroundColor]];
    [self.pwdField cornerHalfWithBorderColor:[self.pwdField backgroundColor]];
    [self.loginBtn cornerHalfWithBorderColor:[self.loginBtn backgroundColor]];
}

- (void)showProtocolView {
    NSString *hasShow = [[NSUserDefaults standardUserDefaults] objectForKey:ProtocolShowKey];
    if (hasShow != nil) {
        return;
    }
    
    //显示协议
    if (self.protocolView == nil) {
        self.protocolView = LoadXib(NSStringFromClass([ProtocolView class]));
    }
    [self.view addSubview:self.protocolView];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


- (void)reloadTextView {
    [super reloadTextView];
    NSString *mobileStr = ChineseStringOrENFun(@"  手机号", @"  mobile");
    NSString *emailStr = ChineseStringOrENFun(@"  邮箱", @"  email");
    [self.isMobileBtn setTitle:mobileStr forState:UIControlStateNormal];
    [self.isEmailBtn setTitle:emailStr forState:UIControlStateNormal];
    [self.loginBtn setTitle:ChineseStringOrENFun(@"登录", @"Login") forState:UIControlStateNormal];
    [self.accountBtn setTitle:ChineseStringOrENFun(@"密码登录", @"Account Login") forState:UIControlStateNormal];
    [self.registerBtn setTitle:ChineseStringOrENFun(@"免密登录", @"SMS Code Login") forState:UIControlStateNormal];
    
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入账号", @"Please enter the account number") attributes:attr];
    self.pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入密码", @"Please input a password") attributes:attr];
    
    // TODO 默认账号
//    self.nameField.text = @"13501173505";
//    self.nameField.text = @"18600411689";
//    self.nameField.text = @"18500507735";
//    self.pwdField.text = @"123456";
//    self.pwdField.text = @"1122";

}

#pragma mark - action



- (IBAction)goToRegister:(id)sender {
    [self resignFirstResponder];
    
    RegisterController *nextVC = VCBySBName(@"RegisterController");
    [self.navigationController setViewControllers:@[nextVC] animated:YES];
}

//点击显示密码
- (IBAction)clickShowPwd:(id)sender {
    [self.showPwdBtn setSelected:!self.showPwdBtn.isSelected];
    [self.pwdField setSecureTextEntry:!self.showPwdBtn.isSelected];
}



#pragma mark - server

- (IBAction)clickLogin {
    [self.view endEditing:YES];
    BOOL isEmail = self.isEmailBtn.isSelected;
    
    NSString *name = self.nameField.text;
    NSString *pwd = self.pwdField.text;
    NSString *code = self.countryCodeLabel.text;
    
    if (!isEmail && [NSString isNullString:code]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"请选择地区编码", @"Please select country code")];
        return;
    }
    
    if ([NSString isNullString:name] || [NSString isNullString:pwd]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"用户名和密码不能为空", @"Account and password can not be emtpy")];
        return;
    }
    
    NSString *account;
    if (isEmail) {
        account = name;
    } else {
        account = [NSString stringWithFormat:@"%@:%@", code, name];
    }
    NSString *accountType = [self getAccountType];
    NSDictionary *param = @{@"username":account, @"password":pwd,
                            @"account_type" : accountType};
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"login" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        [APPObjOnce saveAccountType:accountType];
        [[APPObjOnce sharedAppOnce] loginSuccess:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"loginToSelectCodeSegue"]) {
        SelectCountryCodeViewController *nextVC = segue.destinationViewController;
        nextVC.callback = ^(CountryCode *code) {
            self.countryCodeLabel.text = [NSString stringWithFormat:@"+%d", code.code];
        };
    }
}


@end
