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
#import "BaseResponseModel.h"

@interface RegisterController ()

@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (weak, nonatomic) IBOutlet UIButton *noaccountBtn;
@property (weak, nonatomic) IBOutlet UIView *nameView;

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;



@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self reloadTextView];
}


- (void)initView {
    [self.nameView cornerHalfWithBorderColor:[self.nameField backgroundColor]];
    [self.codeView cornerHalfWithBorderColor:[self.codeView backgroundColor]];
    [self.codeBtn cornerHalfWithBorderColor:[self.codeBtn backgroundColor]];
    [self.loginBtn cornerHalfWithBorderColor:[self.loginBtn backgroundColor]];
}

- (void)reloadTextView {
    [super reloadTextView];
    NSString *mobileStr = ChineseStringOrENFun(@"  手机号", @"  Mobile");
    NSString *emailStr = ChineseStringOrENFun(@"  邮箱", @"  Email");
    [self.isMobileBtn setTitle:mobileStr forState:UIControlStateNormal];
    [self.isEmailBtn setTitle:emailStr forState:UIControlStateNormal];
    [self.loginBtn setTitle:ChineseStringOrENFun(@"登录", @"Login") forState:UIControlStateNormal];
    [self.accountBtn setTitle:ChineseStringOrENFun(@"密码登录", @"Account Login") forState:UIControlStateNormal];
    [self.noaccountBtn setTitle:ChineseStringOrENFun(@"免密登录", @"SMS Code Login") forState:UIControlStateNormal];

    [self.codeBtn setTitle:ChineseStringOrENFun(@"获取验证码", @"Request Code") forState:UIControlStateNormal];
    
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入账号", @"Please enter the account number") attributes:attr];
    self.codeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"短信验证码", @"SMS Code") attributes:attr];
}

#pragma mark - data

#pragma mark - action


- (IBAction)goToAccountLogin:(id)sender {
    [self resignFirstResponder];
    LoginController *nextVC = VCBySBName(@"LoginController");
    [self.navigationController setViewControllers:@[nextVC] animated:YES];
}


//获取验证码
- (IBAction)getValidCode:(id)sender {
    [self.view endEditing:YES];
    BOOL isEmail = self.isEmailBtn.isSelected;
    
    NSString *code = self.countryCodeLabel.text;
    if (!isEmail && [NSString isNullString:code]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"请选择地区编码", @"Please select country code")];
        return;
    }
    
    NSString *number = self.nameField.text;
    if ([NSString isNullString:number]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"请输入手机号", @"Please enter the account number")];
        return;
    }
    NSString *account;
    if (isEmail) {
        account = number;
    } else {
        account = [NSString stringWithFormat:@"%@:%@",code, number];
    }
    
    NSDictionary *param = @{@"account":account,
                            @"account_type" : [self getAccountType]};
    [[AFAppNetAPIClient manager] POST:@"captcha" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"====respong:%@", responseObject);
        
        BaseResponseModel *resp = [[BaseResponseModel alloc] initWithDictionary:responseObject error:nil];
        if (resp.status != 0) {
            //错误
            [MTHUD showDurationNoticeHUD:resp.msg];
            return;
        }
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
    
    BOOL isEmail = self.isEmailBtn.isSelected;
    
    NSString *name = self.nameField.text;
    NSString *pwd = self.codeField.text;
    NSString *code = self.countryCodeLabel.text;
    
    if (!isEmail && [NSString isNullString:code]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"请选择地区编码", @"Please select country code")];
        return;
    }
    
    if ([NSString isNullString:name] || [NSString isNullString:pwd]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"账号和验证码不能为空",
                                                          @"Account and code can not be emtpy")];
        return;
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@captcha/validate", FITAPI_HTTPS_PREFIX];
    NSLog(@"uuid>>>>%@", [UIDevice currentDevice].identifierForVendor.UUIDString);
    [MTHUD showLoadingHUD];
    NSString *accountType = [self getAccountType];
    NSString *account;
    if (isEmail) {
        account = name;
    } else {
        account = [NSString stringWithFormat:@"%@:%@",code, name];
    }
    NSDictionary *dict = @{ @"account":account,  @"captcha":pwd,
                            @"account_type" : accountType};
    [[AFHTTPSessionManager manager] POST:strUrl
                              parameters:dict
                                 headers:nil
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MTHUD hideHUD];
        [APPObjOnce saveAccountType:accountType];
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
