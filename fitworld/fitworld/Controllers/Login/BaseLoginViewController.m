//
//  BaseLoginViewController.m
//  FFitWorld
//
//  Created by TinaXie on 2022/1/3.
//

#import "BaseLoginViewController.h"

@interface BaseLoginViewController ()

@end

@implementation BaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *mobileStr = ChineseStringOrENFun(@"  手机号", @"  mobile");
    NSString *emailStr = ChineseStringOrENFun(@"  邮箱", @"  email");
    _loginType = 0;//默认是手机登录
    UIImage *selectedImg = [UIImage imageNamed:@"invite_friends_user_list_item_selected"];
    UIImage *unselectedImg = [UIImage imageNamed:@"invite_friends_user_list_item_unselected"];
    [self.isMobileBtn setTitle:mobileStr forState:UIControlStateNormal];
    [self.isMobileBtn setImage:unselectedImg forState:UIControlStateNormal];
    [self.isMobileBtn setImage:selectedImg forState:UIControlStateSelected];
    [self.isEmailBtn setTitle:emailStr forState:UIControlStateNormal];
    [self.isEmailBtn setImage:unselectedImg forState:UIControlStateNormal];
    [self.isEmailBtn setImage:selectedImg forState:UIControlStateSelected];
    
    [self selectLoginType:self.isMobileBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = nil;
    [APPObjOnce sharedAppOnce].isLogining = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [APPObjOnce sharedAppOnce].isLogining = NO;
}

//修改语言
- (IBAction)ChangeLanguage:(UIButton *)sender {
    LanguageEnum language;
    if (sender == self.enLanguageBtn) {
        language = LanguageEnum_English;
        [self.enLanguageBtn setTitleColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];
        [self.zhLanguageBtn setTitleColor:UIColor.lightGrayColor
                                 forState:UIControlStateNormal];
        self.zhLanguageBtn.titleLabel.font = SystemFontOfSize(16);
        self.enLanguageBtn.titleLabel.font = SystemFontOfSize(20);
        
    } else {
        language = LanguageEnum_Chinese;
        [self.zhLanguageBtn setTitleColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];
        [self.enLanguageBtn setTitleColor:UIColor.lightGrayColor
                                 forState:UIControlStateNormal];
        self.enLanguageBtn.titleLabel.font = SystemFontOfSize(16);
        self.zhLanguageBtn.titleLabel.font = SystemFontOfSize(18);
    }
    
    //保存当前语言
    [ConfigManager sharedInstance].language = language;
    [[ConfigManager sharedInstance] saveConfig];
    [self reloadTextView];
}

- (void)reloadTextView {
    if (ISChinese()) {
        [self.zhLanguageBtn setTitleColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];
        [self.enLanguageBtn setTitleColor:UIColor.lightGrayColor
                                 forState:UIControlStateNormal];
        
        self.enLanguageBtn.titleLabel.font = SystemFontOfSize(16);
        self.zhLanguageBtn.titleLabel.font = SystemFontOfSize(18);
    } else {
        [self.enLanguageBtn setTitleColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];
        [self.zhLanguageBtn setTitleColor:UIColor.lightGrayColor
                                 forState:UIControlStateNormal];
        self.zhLanguageBtn.titleLabel.font = SystemFontOfSize(16);
        self.enLanguageBtn.titleLabel.font = SystemFontOfSize(20);
       
    }
    [self changeLoginType:_loginType];
}

//切换登录方式
- (IBAction)selectLoginType:(id)sender {
    [self.nameField resignFirstResponder];
    if (sender == self.isEmailBtn) {
        [self.isEmailBtn setSelected:YES];
        [self.isMobileBtn setSelected:NO];
        self.leftView.hidden = YES;
        self.nameField.textAlignment = NSTextAlignmentCenter;
        self.nameField.keyboardType = UIKeyboardTypeDefault;
        [self changeLoginType:1];//邮箱登录
    } else {
        [self.isEmailBtn setSelected:NO];
        [self.isMobileBtn setSelected:YES];
        self.leftView.hidden = NO;
        self.nameField.textAlignment = NSTextAlignmentLeft;
        self.nameField.keyboardType = UIKeyboardTypeNumberPad;
        [self changeLoginType:0];//邮箱登录
    }
    self.leftCodeWidth.constant = self.leftView.hidden ? 0 : 72.0;
    [self.view updateConstraintsIfNeeded];
}

- (void)changeLoginType:(int)type{
    _loginType = type;
    if (type == 1) {
        
        [self.isEmailBtn setTitleColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];
        [self.isMobileBtn setTitleColor:UIColor.lightGrayColor
                                 forState:UIControlStateNormal];
        
        self.isEmailBtn.titleLabel.font = SystemFontOfSize(16);
        self.isMobileBtn.titleLabel.font = SystemFontOfSize(14);
        NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入Email", @"Email") attributes:attr];
    } else {
        [self.isMobileBtn setTitleColor:[UIColor whiteColor]
                                 forState:UIControlStateNormal];
        [self.isEmailBtn setTitleColor:UIColor.lightGrayColor
                                 forState:UIControlStateNormal];
        
        self.isMobileBtn.titleLabel.font = SystemFontOfSize(16);
        self.isEmailBtn.titleLabel.font = SystemFontOfSize(14);
        NSDictionary *attr = @{NSForegroundColorAttributeName:[UIColor lightGrayColor]};
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ChineseStringOrENFun(@"请输入手机号", @"Mobile number") attributes:attr];

       
       
    }
}

- (NSString *)getAccountType {
    NSString *account_type = self.isEmailBtn.isSelected ? @"email" : @"mobile";
    return account_type;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
