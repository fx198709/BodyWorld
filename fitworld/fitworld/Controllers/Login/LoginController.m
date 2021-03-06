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

@property (weak, nonatomic) IBOutlet UIButton *zhLanguageBtn;
@property (weak, nonatomic) IBOutlet UIButton *enLanguageBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCountryBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    [APPObjOnce sharedAppOnce].isLogining = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showProtocolView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [APPObjOnce sharedAppOnce].isLogining = NO;
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
    
    //????????????
    if (self.protocolView == nil) {
        self.protocolView = LoadXib(NSStringFromClass([ProtocolView class]));
    }
    [self.view addSubview:self.protocolView];
    [self.protocolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


- (void)reloadTextView {
    [self.loginBtn setTitle:ChineseStringOrENFun(@"??????", @"Login") forState:UIControlStateNormal];
    [self.registerBtn setTitle:ChineseStringOrENFun(@"????????????", @"SMS Code Login") forState:UIControlStateNormal];
    
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"???????????????", @"Please enter the account number") attributes:attr];
    self.pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"???????????????", @"Please input a password") attributes:attr];
    
    // TODO ????????????
//    self.nameField.text = @"13501173505";
//    self.nameField.text = @"18600411689";
    self.nameField.text = @"18500507735";
//    self.pwdField.text = @"123456";
    self.pwdField.text = @"1122";

}

#pragma mark - action

//????????????
- (IBAction)ChangeLanguage:(UIButton *)sender {
    LanguageEnum language;
    if (sender == self.enLanguageBtn) {
        language = LanguageEnum_English;
    } else {
        language = LanguageEnum_Chinese;
    }
    
    //??????????????????
    [ConfigManager sharedInstance].language = language;
    [[ConfigManager sharedInstance] saveConfig];
    [self reloadTextView];
}


- (IBAction)goToRegister:(id)sender {
    [self resignFirstResponder];
    
    RegisterController *nextVC = VCBySBName(@"RegisterController");
    [self.navigationController setViewControllers:@[nextVC] animated:YES];
}


//??????????????????
- (IBAction)clickShowPwd:(id)sender {
    [self.showPwdBtn setSelected:!self.showPwdBtn.isSelected];
    [self.pwdField setSecureTextEntry:!self.showPwdBtn.isSelected];
}


- (IBAction)clickLogin {
    [self.view endEditing:YES];
    
    NSString *name = self.nameField.text;
    NSString *pwd = self.pwdField.text;
    NSString *code = self.countryCodeLabel.text;
    
    if ([NSString isNullString:code]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"?????????????????????", @"Please select country code")];
        return;
    }
    
    if ([NSString isNullString:name] || [NSString isNullString:pwd]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"??????????????????????????????", @"Account and password can not be emtpy")];
        return;
    }
    
    NSString *mobile = [NSString stringWithFormat:@"%@:%@", code, name];
    NSDictionary *param = @{@"username":mobile, @"password":pwd};
    [self loginToServer:param];
}

#pragma mark - server

- (void)loginToServer:(NSDictionary *)param {
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"login" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
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
