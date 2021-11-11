//
//  ViewController.m
//  fitworld
//
//  Created by wangwei on 2021/7/1.
//

#import "AppDelegate.h"
#import "RegisterController.h"
#import "MainViewController.h"
#import "AFNetworking.h"
#import "FITAPI.h"
#import "UIDeps.h"
#import "UserInfo.h"

@interface RegisterController ()

@property (nonatomic, strong) UITextField *userNameTxt;
@property (nonatomic, strong) UITextField *passwordTxt;
@property (nonatomic, strong) UIImageView *inputImageView;
@property (nonatomic, strong) UIPickerView *countryPicker;
@property (nonatomic, strong) NSArray *pickerArray;

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgView.image = [UIImage imageNamed:@"loginbg"];
    [self.view insertSubview: bgImgView atIndex:0];
    
    UIView *inputBgView = [[UIView alloc] initWithFrame:CGRectZero];
    [inputBgView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
    [inputBgView.layer setMasksToBounds:YES];
    [inputBgView.layer setCornerRadius:9.0];
    
    [bgImgView addSubview: inputBgView];
    [inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(150);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(150);
        make.centerX.equalTo(self.view);
    }];
    
    UIImageView *logoImgView = [[UIImageView alloc] init];
    logoImgView.image = [UIImage imageNamed:@"logo_login"];
    [bgImgView addSubview:logoImgView];
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(inputBgView.mas_top).offset(-10);
        make.left.equalTo(inputBgView);
        make.width.height.mas_equalTo(40);
    }];
    
    UIImageView *pickerLeftImgView = [[UIImageView alloc] init];
    pickerLeftImgView.image = [UIImage imageNamed:@"login_world"];
    [inputBgView addSubview:pickerLeftImgView];
    [pickerLeftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(inputBgView.mas_left).offset(10);
        make.top.equalTo(inputBgView.mas_top).offset(10);
        make.width.height.mas_equalTo(15);
    }];
    
    self.pickerArray = [NSArray arrayWithObjects:@"China",@"HongKong",@"Switzerland", nil];
    self.countryPicker = [[UIPickerView alloc] init];
    self.countryPicker.delegate = self;
    self.countryPicker.dataSource = self;
    
    [self.view addSubview: self.countryPicker];
    [self.countryPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(inputBgView);
        make.left.equalTo(pickerLeftImgView.mas_right).offset(10);
        make.height.mas_equalTo(50);
        make.centerY.equalTo(pickerLeftImgView);
    }];
    
    self.userNameTxt = [[UITextField alloc] init];
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"mobile number" attributes:
        @{NSForegroundColorAttributeName:[UIColor whiteColor],
                     NSFontAttributeName: self.userNameTxt.font
             }];
    self.userNameTxt.attributedPlaceholder = placeholderString;
    self.userNameTxt.textColor = UIColor.whiteColor;
    // TODO 默认账号
    self.userNameTxt.text = @"wangwei";
    [self.view addSubview: self.userNameTxt];
    [self.userNameTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputBgView);
        make.top.equalTo(self.countryPicker.mas_bottom).offset(5);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *loginNameFieldLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 15, 15)];
    loginNameFieldLeftView.image = [UIImage imageNamed:@"login_phone"];
    UIView *loginNameLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
    [loginNameLeftPaddingView addSubview:loginNameFieldLeftView];
    self.userNameTxt.leftView = loginNameLeftPaddingView;
    self.userNameTxt.leftViewMode = UITextFieldViewModeAlways;
    
    self.passwordTxt = [[UITextField alloc] init];
    NSAttributedString *placeholderString2 = [[NSAttributedString alloc] initWithString:@"password" attributes:
        @{NSForegroundColorAttributeName:[UIColor whiteColor],
                     NSFontAttributeName: self.passwordTxt.font
             }];
    self.passwordTxt.attributedPlaceholder = placeholderString2;
    self.passwordTxt.textColor = UIColor.whiteColor;
    // TODO 默认密码
    self.passwordTxt.text = @"1122";
    [self.view addSubview: self.passwordTxt];
    [self.passwordTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(inputBgView);
        make.top.equalTo(self.userNameTxt.mas_bottom).offset(5);
        make.height.mas_equalTo(50);
    }];
    
    UIImageView *pwdFieldLeftView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 15, 15)];
    pwdFieldLeftView.image = [UIImage imageNamed:@"login_pwd"];
    UIView *pwdLeftPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 15)];
    [pwdLeftPaddingView addSubview:pwdFieldLeftView];
    self.passwordTxt.leftView = pwdLeftPaddingView;
    self.passwordTxt.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton* loginBtn = [[UIButton alloc] init];
    [loginBtn setTitle:@"LOGIN" forState:UIControlStateNormal] ;
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
    NSString *strUrl = [NSString stringWithFormat:@"%@login", FITAPI_HTTPS_PREFIX];
    NSLog(@"uuid>>>>%@", [UIDevice currentDevice].identifierForVendor.UUIDString);
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
        NSDictionary *dict = @{
                               @"username":self.userNameTxt.text,
                               @"password":self.passwordTxt.text
                           };
    [manager POST:strUrl parameters:dict headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // 进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功---%@", responseObject);
        if ([responseObject objectForKey:@"status"] && [[responseObject objectForKey:@"status"] longLongValue] == 0)  {
            UserInfo *userInfo = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"][@"user"]];
            NSString *userToken = responseObject[@"recordset"][@"token"];
            if(userToken != nil){
                [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:@"userToken"];
            }
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //这里的id填刚刚设置的值,vc设置属性就可以给下个页面传参数了
            UIViewController *vc = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainNavVC"];
            
            [self.view.window setRootViewController:vc];
        }

        // 请求成功
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 请求失败
    }];

//    [manager POST:strUrl parameters:dict heaers: nil progress:^(NSProgress * _Nonnull downloadProgress) {
//            // 进度
//        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"请求成功---%@", responseObject);
//            if ([responseObject count] > 0) {
//                UserInfo *userInfo = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"][@"user"]];
//                NSString *userToken = responseObject[@"recordset"][@"token"];
//                if(userToken != nil){
//                    [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:@"userToken"];
//                }
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                //这里的id填刚刚设置的值,vc设置属性就可以给下个页面传参数了
//                UIViewController *vc = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainNavVC"];
//                
//                [self.view.window setRootViewController:vc];
//            }
//
//            // 请求成功
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            // 请求失败
//        }];
}

//组件的轮数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//返回组件行数，实际就是数据源数组的count
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.pickerArray count];
}
//给组件设置每行的内容
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.pickerArray objectAtIndex:row];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 250, 30)];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.textColor = UIColor.whiteColor;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentLeft;
        pickerLabel.font = [UIFont systemFontOfSize:14];
        
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

@end
