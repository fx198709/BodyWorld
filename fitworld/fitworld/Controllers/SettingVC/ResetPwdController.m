//
//  ViewController.m
//  fitworld
//
//  Created by wangwei on 2021/7/1.
//

#import "AppDelegate.h"
#import "ResetPwdController.h"
#import "MainViewController.h"
#import "AFNetworking.h"
#import "FITAPI.h"
#import "UIDeps.h"
#import "UserInfo.h"
#import "MBProgressHUD.h"

@interface ResetPwdController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UITextField *validCodeLabel;

@property (weak, nonatomic) IBOutlet UILabel *pwdTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *repeatLabel;

@property (weak, nonatomic) IBOutlet UIButton *validCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *showPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *showRepeatPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation ResetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = ChineseStringOrENFun(@"修改密码", @"Change password");
    [self initUI];
}

- (void)initUI {
    [self.containerView cornerWithRadius:4.0 borderColor:self.containerView.backgroundColor];
    [self.validCodeBtn cornerHalfWithBorderColor:self.validCodeBtn.backgroundColor];
    [self.submitBtn cornerHalfWithBorderColor:self.submitBtn.backgroundColor];
    
    
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    
    self.validCodeLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"短信验证码", @"SMS Code") attributes:attr];
    self.validCodeBtn.titleLabel.text = ChineseStringOrENFun(@"获取验证码", @"Request Code");
    
    self.pwdTitleLabel.text = ChineseStringOrENFun(@"新密码", @"New Password");
    
    self.pwdLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入新密码", @"enter a new password") attributes:attr];
    
    self.repeatTitleLabel.text = ChineseStringOrENFun(@"重复确认密码", @"New Password Again");
    self.repeatLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请重复输入一次新密码", @"Repeat the new password again") attributes:attr];
    
    self.submitBtn.titleLabel.text = ChineseStringOrENFun(@"确认修改", @"SAVE");
}

//获取验证码
- (IBAction)getValidCode:(id)sender {
    //todo:发送短信验证码
    
    //显示倒计时
    NSString *normalTitle = ChineseStringOrENFun(@"获取验证码", @"Request Code");

    NSString *hTitle = ChineseStringOrENFun(@"重新获取", @"Request Again");
    [self.validCodeBtn countdownWithStartTime:60 title:normalTitle countDownTitle:hTitle];
}



//确认修改
- (IBAction)submit:(id)sender {
    NSString *validCode = self.validCodeLabel.text;
    if ([NSString isNullString:validCode]) {
        [MTHUD showDurationSuccessHUD:ChineseStringOrENFun(@"请输入验证码", @"Please enter verifycode")];
        return;
    }
    NSString *pwd = self.pwdLabel.text;
    if ([NSString isNullString:pwd]) {
        [MTHUD showDurationSuccessHUD:ChineseStringOrENFun(@"请输入新密码", @"The new password can not be empty")];
        return;
    }
    NSString *repeatPwd = self.repeatLabel.text;
    if ([NSString isNullString:repeatPwd]) {
        [MTHUD showDurationSuccessHUD:ChineseStringOrENFun(@"请输入确认密码", @"Please repeat the new password again")];
        return;
    }
    
    //todo:
    [self.navigationController popViewControllerAnimated:YES];
}

//点击显示新密码
- (IBAction)clickShowPwd:(id)sender {
    [self.showPwdBtn setSelected:!self.showPwdBtn.isSelected];
    [self.pwdLabel setSecureTextEntry:!self.showPwdBtn.isSelected];
}

//点击显示重复密码
- (IBAction)clickShowRepeatPwd:(id)sender {
    [self.showRepeatPwdBtn setSelected:!self.showRepeatPwdBtn.isSelected];
    [self.repeatLabel setSecureTextEntry:!self.showRepeatPwdBtn.isSelected];
}

/*
 
 - (void)loginBtnClick {
 if(self.passwordTxt.text != self.passwordTxt2.text){
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"输入的新密码不一致，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
 [alertView show];
 return;
 }
 NSString *strUrl = [NSString stringWithFormat:@"%@password/reset", FITAPI_HTTPS_PREFIX];
 NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
 AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
 [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
 [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
 NSDictionary *dict = @{
 @"username":self.userNameTxt.text,
 @"password":self.passwordTxt.text
 };
 [manager POST:strUrl parameters:dict headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
 // 进度
 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 NSLog(@"请求成功---%@", responseObject);
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:responseObject[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
 [alertView show];
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 }];
 }
 */
@end
