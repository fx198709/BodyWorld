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
    
    UIImage *selectedImg = [UIImage imageNamed:@"invite_friends_user_list_item_selected"];
    UIImage *unselectedImg = [UIImage imageNamed:@"invite_friends_user_list_item_unselected"];
    [self.isMobileBtn setImage:unselectedImg forState:UIControlStateNormal];
    [self.isMobileBtn setImage:selectedImg forState:UIControlStateSelected];
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
    } else {
        language = LanguageEnum_Chinese;
    }
    
    //保存当前语言
    [ConfigManager sharedInstance].language = language;
    [[ConfigManager sharedInstance] saveConfig];
    [self reloadTextView];
}


- (void)reloadTextView {
    
}

//切换登录方式
- (IBAction)selectLoginType:(id)sender {
    UIButton *selectedBtn, *unSelectedBtn;
    if (sender == self.isEmailBtn) {
        selectedBtn = self.isEmailBtn;
        unSelectedBtn = self.isMobileBtn;
    } else {
        selectedBtn = self.isMobileBtn;
        unSelectedBtn = self.isEmailBtn;
    }
    [selectedBtn setSelected:YES];
    [unSelectedBtn setSelected:NO];
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
