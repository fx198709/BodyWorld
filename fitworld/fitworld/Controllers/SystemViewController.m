//
//  UserCenterViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/7/20.
//

#import "SystemViewController.h"
#import "ResetPwdController.h"
#import "LoginController.h"
#import "UIView+MT.h"

@interface SystemViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pwdTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *headTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nickTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;

@property (weak, nonatomic) IBOutlet UILabel *languageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;


@property (weak, nonatomic) IBOutlet UILabel *sexTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;


@property (weak, nonatomic) IBOutlet UILabel *mobileTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;


@property (weak, nonatomic) IBOutlet UILabel *birthdayTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;


@property (weak, nonatomic) IBOutlet UILabel *heightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;


@property (weak, nonatomic) IBOutlet UILabel *weightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;


@property (weak, nonatomic) IBOutlet UILabel *cityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


@property (weak, nonatomic) IBOutlet UILabel *introductionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;


@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation SystemViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = ChineseStringOrENFun(@"系统设置",@"PERSONAL SETTING");
    
    [self initUI];
}

- (void)initUI {
    self.pwdTitleLabel.text = ChineseStringOrENFun(@"修改密码", @"Change the password");
    self.headTitleLabel.text = ChineseStringOrENFun(@"头像", @"Head portrait");
    self.nickTitleLabel.text = ChineseStringOrENFun(@"昵称", @"Nickname");
    self.sexTitleLabel.text = ChineseStringOrENFun(@"性别", @"Gender");
    self.mobileTitleLabel.text = ChineseStringOrENFun(@"手机号", @"Telephone");
    self.birthdayTitleLabel.text = ChineseStringOrENFun(@"生日", @"Date of birth");
    self.heightTitleLabel.text = ChineseStringOrENFun(@"身高", @"Height");
    self.weightTitleLabel.text = ChineseStringOrENFun(@"体重", @"Weight");
    self.cityTitleLabel.text = ChineseStringOrENFun(@"所在城市", @"Location");
    self.introductionTitleLabel.text = ChineseStringOrENFun(@"介绍", @"Motto");
    
    
    [self.headImg cornerHalfWithBorderColor:[UIColor darkGrayColor]];
    [self.logoutBtn cornerWithRadius:4.0 borderColor:[self.logoutBtn backgroundColor]];

}

//修改密码
-(IBAction)changePwd:(id)sender {
    ResetPwdController *nextVC = VCBySBName(@"ResetPwdController");
    [self.navigationController pushViewController:nextVC animated:YES];
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
