//
//  ViewController.m
//  fitworld
//
//  Created by wangwei on 2021/7/1.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import "RegisterController.h"

#import "FITAPI.h"
#import "UIDeps.h"
#import "UserInfo.h"

#import "APPObjOnce.h"

#define ProtocolShowKey @"ProtocolDisplay"


@interface LoginController ()

@property (weak, nonatomic) IBOutlet UIButton *zhLanguageBtn;
@property (weak, nonatomic) IBOutlet UIButton *enLanguageBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic, strong) UIView *protocolView;



@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self reloadTextView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
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
//        self.protocolView = LoadXib(@"protocolView");
    }
//    [self.view addSubView:self.protocolView];
}


- (void)reloadTextView {
    [self.loginBtn setTitle:ChineseStringOrENFun(@"登录", @"Login") forState:UIControlStateNormal];
    [self.registerBtn setTitle:ChineseStringOrENFun(@"免密登录", @"SMS Code Login") forState:UIControlStateNormal];
    
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入账号", @"Please enter the account number") attributes:attr];
    self.pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入密码", @"Please input a password") attributes:attr];
    
    // TODO 默认账号
//    self.nameField.text = @"+86:13501173505";
    self.nameField.text = @"+86:18600411689";
//    self.nameField.text = @"+86:18601061163";
    self.pwdField.text = @"1122";
}

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


- (IBAction)goToRegister:(id)sender {
    [self resignFirstResponder];
    
    RegisterController *nextVC = VCBySBName(@"RegisterController");
    [self.navigationController setViewControllers:[NSArray arrayWithObject:nextVC] animated:YES];
}


//点击显示密码
- (IBAction)clickShowPwd:(id)sender {
    [self.showPwdBtn setSelected:!self.showPwdBtn.isSelected];
    [self.pwdField setSecureTextEntry:!self.showPwdBtn.isSelected];
}


- (IBAction)clickLogin {
    [self.view endEditing:YES];
    
    NSString *name = self.nameField.text;
    NSString *pwd = self.pwdField.text;
    
    if ([NSString isNullString:name] || [NSString isNullString:pwd]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"用户名和密码不能为空", @"Account and password can not be emtpy")];
        return;
    }
    
    NSDictionary *param = @{@"username":name, @"password":pwd};
    [self loginToServer:param];
}

//到首页
- (void)goToMainVC {
    UINavigationController *vc = VCBySBName(@"mainNavVC");
    [self.view.window setRootViewController:vc];
}

#pragma mark - server

- (void)loginToServer:(NSDictionary *)param {
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"login" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        if ([responseObject objectForKey:@"status"] && [[responseObject objectForKey:@"status"] longLongValue] == 0) {
            UserInfo *userInfo = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"][@"user"]];
            userInfo.msg = responseObject[@"recordset"][@"msg"];
            userInfo.msg_cn = responseObject[@"recordset"][@"msg_cn"];
            [APPObjOnce sharedAppOnce].currentUser = userInfo;
            
            NSString *userToken = responseObject[@"recordset"][@"token"];
            if(userToken != nil){
                [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:@"userToken"];
            }
            [self goToMainVC];
        } else {
            NSString *msg = [responseObject objectForKey:@"msg"];
            [MTHUD showDurationNoticeHUD:msg];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

@end
