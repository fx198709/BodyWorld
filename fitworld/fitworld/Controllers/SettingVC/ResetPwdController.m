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

@interface ResetPwdController ()


@property (weak, nonatomic) IBOutlet UITextField *validCodeLabel;

@property (weak, nonatomic) IBOutlet UILabel *pwdTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *repeatTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *repeatLabel;

@property (weak, nonatomic) IBOutlet UIButton *validCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation ResetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = ChineseStringOrENFun(@"修改密码", @"CHANGE THE PASSWORD");
    [self initUI];
}

- (void)initUI {
    self.pwdTitleLabel.text = ChineseStringOrENFun(@"修改密码", @"Change the password");
    

}

//获取验证码
- (IBAction)getVaildCode:(id)sender {
    
}

//确认修改
- (IBAction)submit:(id)sender {
    
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
