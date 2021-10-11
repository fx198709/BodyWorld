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

@property (nonatomic, strong) UITextField *userNameTxt;
@property (nonatomic, strong) UITextField *passwordTxt;
@property (nonatomic, strong) UITextField *passwordTxt2;
@property (nonatomic, strong) UIImageView *inputImageView;
@property (nonatomic, strong) UIPickerView *countryPicker;
@property (nonatomic, strong) NSArray *pickerArray;

@end

@implementation ResetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改密码";

    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.backgroundColor = UIColor.whiteColor;
    [self.view insertSubview: bgImgView atIndex:0];
    
    UIView *inputBgView = [[UIView alloc] initWithFrame:CGRectZero];
    [inputBgView.layer setMasksToBounds:YES];
    [inputBgView.layer setCornerRadius:9.0];
    
    [bgImgView addSubview: inputBgView];
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(150);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(150);
        make.centerX.equalTo(self.view);
    }];
    
    self.userNameTxt = [[UITextField alloc] init];
    self.userNameTxt.layer.borderWidth= 1.0f;
    self.userNameTxt.borderStyle = UITextBorderStyleBezel;
    self.userNameTxt.placeholder = @"请输入旧密码";
    [self.view addSubview: self.userNameTxt];
    [self.userNameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputBgView);
        make.top.equalTo(inputBgView).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    self.passwordTxt = [[UITextField alloc] init];
    self.passwordTxt.layer.borderWidth= 1.0f;
    self.passwordTxt.borderStyle = UITextBorderStyleBezel;
    self.passwordTxt.placeholder = @"请输入新密码";
    [self.view addSubview: self.passwordTxt];
    [self.passwordTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputBgView);
        make.top.equalTo(self.userNameTxt.mas_bottom).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    self.passwordTxt2 = [[UITextField alloc] init];
    self.passwordTxt2.layer.borderWidth= 1.0f;
    self.passwordTxt2.borderStyle = UITextBorderStyleBezel;
    self.passwordTxt2.placeholder = @"请再次输入新密码";
    self.passwordTxt2.text = @"";
    [self.view addSubview: self.passwordTxt2];
    [self.passwordTxt2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputBgView);
        make.top.equalTo(self.passwordTxt.mas_bottom).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    UIButton* loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"确认修改" forState:UIControlStateNormal] ;
    [loginBtn setBackgroundImage:[UIImage imageNamed: @"bg_loginbtn"] forState:UIControlStateNormal];
    loginBtn.alpha = 0.8;
    loginBtn.titleLabel.textColor = UIColor.whiteColor;
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputBgView);
        make.top.equalTo(inputBgView.mas_bottom).offset(10);
        make.height.mas_equalTo(45);
    }];
    [loginBtn addTarget: self action: @selector(loginBtnClick) forControlEvents: UIControlEventTouchDown];
    
}



- (void)loginBtnClick{
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

@end
