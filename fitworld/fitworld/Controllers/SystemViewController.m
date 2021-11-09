//
//  UserCenterViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/7/20.
//

#import "SystemViewController.h"
#import "ResetPwdController.h"
#import "LoginController.h"

@interface SystemViewController ()

@end

@implementation SystemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系统设置";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = UIColor.blackColor;
}

//修改密码
-(IBAction)changePwd:(id)sender {
    
}

//修改头像
- (IBAction)changeHeadImg:(id)sender {
    
}

//修改昵称
-(IBAction)changeNickName:(id)sender {
    
}

//修改语言
-(IBAction)changeLanguage:(id)sender {
    
}

//修改性别
-(IBAction)changeSex:(id)sender {
    
}

//修改手机号
-(IBAction)changeMobile:(id)sender {
    
}

//修改生日
-(IBAction)changeBirthday:(id)sender {
    
}

//修改身高
-(IBAction)changeHeight:(id)sender {
    
}

//修改体重
-(IBAction)changeWeight:(id)sender {
    
}

//修改所在城市
-(IBAction)changeCity:(id)sender {
    
}

//修改介绍
-(IBAction)ChangeIntroduction:(id)sender {
    
}


- (IBAction)loginOut:(id)sender {
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"确定退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alter addAction:sure];
    [alter addAction:cancle];
    
    [self presentViewController:alter animated:YES completion:^{
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
