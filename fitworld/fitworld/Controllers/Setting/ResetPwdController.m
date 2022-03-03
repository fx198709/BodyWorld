//
//  ViewController.m
//  fitworld
//
//  Created by wangwei on 2021/7/1.
//

#import "AppDelegate.h"
#import "ResetPwdController.h"
#import "AFNetworking.h"
#import "FITAPI.h"
#import "UIDeps.h"
#import "UserInfo.h"
#import "MBProgressHUD.h"
#import "BaseResponseModel.h"

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
    
    self.navigationItem.title = ChineseStringOrENFun(@"修改密码", @"Change Password");
    [self initUI];
}

- (void)initUI {
    [self.containerView cornerWithRadius:4.0 borderColor:self.containerView.backgroundColor];
    [self.validCodeBtn cornerHalfWithBorderColor:self.validCodeBtn.backgroundColor];
    [self.submitBtn cornerHalfWithBorderColor:self.submitBtn.backgroundColor];
    
    
    NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    
    self.validCodeLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入验证码", @"Code received") attributes:attr];
    [self.validCodeBtn setTitle:ChineseStringOrENFun(@"获取验证码", @"Request Code") forState:UIControlStateNormal];
    
    self.pwdTitleLabel.text = ChineseStringOrENFun(@"新密码", @"New Password");
    
//    self.pwdLabel.attributedPlaceholder =[[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入新密码", @"enter a new password") attributes:attr];
    
    self.repeatTitleLabel.text = ChineseStringOrENFun(@"重复确认密码", @"Confirm Password");
//    self.repeatLabel.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请重复输入一次新密码", @"Repeat the new password again") attributes:attr];
     
    [self.submitBtn setTitle:ChineseStringOrENFun(@"确认修改", @"SAVE") forState:UIControlStateNormal];
}

//获取验证码
- (IBAction)getValidCode:(id)sender {
    [self.view endEditing:YES];

    UserInfo *userInfo = [APPObjOnce sharedAppOnce].currentUser;
    //账号 邮箱格式 : xx@xx.xx 手机格式: '国际区号:手机号'
    NSString *account = nil;
    if (![NSString isNullString:userInfo.mobile]) {
        account = [NSString stringWithFormat:@"%@:%@", userInfo.mobile_code, userInfo.mobile];
    } else {
        account = userInfo.username;
    }
    NSString *accountType = [APPObjOnce getAccountType];
    NSDictionary *param = @{@"account":account,
                            @"account_type" : accountType};
    [[AFAppNetAPIClient manager] POST:@"captcha" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"====respong:%@", responseObject);
        BaseResponseModel *resp = [[BaseResponseModel alloc] initWithDictionary:responseObject error:nil];
        if (resp.status != 0) {
            //错误
            [MTHUD showDurationNoticeHUD:resp.msg];
            return;
        }
        //显示倒计时
        [self.validCodeBtn countdownWithStartTime:60
                                            title:GetValidCodeBtnTitle
                                   countDownTitle:GetValidCodeBtnTitle_H];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}



//确认修改
- (IBAction)submit:(id)sender {
    [self.view endEditing:YES];

    NSString *validCode = self.validCodeLabel.text;
    if ([NSString isNullString:validCode]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"请输入验证码", @"Please enter verifycode")];
        return;
    }
    NSString *pwd = self.pwdLabel.text;
    if ([NSString isNullString:pwd]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"请输入新密码", @"The new password can not be empty")];
        return;
    }
    NSString *repeatPwd = self.repeatLabel.text;
    if ([NSString isNullString:repeatPwd]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"请输入确认密码", @"Please repeat the new password again")];
        return;
    }
    
    if (![repeatPwd isEqualToString:pwd]) {
        [MTHUD showDurationNoticeHUD:ChineseStringOrENFun(@"两次密码不一致", @"Two input password must be consistent")];
        return;
    }
    
    [self changePwdFromServer:validCode pwd:pwd];
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

#pragma mark - server

//服务器验证验证码 - 暂时不用
- (void)validCodeFromServer:(NSString *)code complete:(void(^)(bool isSuccess))completeBlock {
    [MTHUD showLoadingHUD];
    NSDictionary *param = @{@"captcha":code, @"no_login":@"false", @"invite_code":@""};
    [[AFAppNetAPIClient manager] POST:@"captcha/validate" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSLog(@"====respong:%@", responseObject);
        if ([responseObject objectForKey:@"recordset"]) {
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

//发送修改密码请求
- (void)changePwdFromServer:(NSString *)code pwd:(NSString *)pwd {
    [MTHUD showLoadingHUD];
    NSDictionary *param = @{@"captcha":code, @"password":pwd};
    [[AFAppNetAPIClient manager] POST:@"password/reset" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        [self showSuccessNoticeAndPopVC];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showChangeFailedError:error];
    }];
}

/*
 
 - (void)loginBtnClick {
 if(self.passwordTxt.text != self.passwordTxt2.text){
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"输入的新密码不一致，请重试！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
 [alertView show];
 return;
 }
 NSString *strUrl = [NSString stringWithFormat:@"%@password/reset", FITAPI_HTTPS_PREFIX];
 NSString *userToken = [APPObjOnce getUserToken ];
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
