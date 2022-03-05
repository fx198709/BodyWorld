//
//  BaseLoginViewController.h
//  FFitWorld
//
//  Created by TinaXie on 2022/1/3.
//

#import "BaseNavViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseLoginViewController : BaseNavViewController

@property (weak, nonatomic) IBOutlet UIButton *zhLanguageBtn;
@property (weak, nonatomic) IBOutlet UIButton *enLanguageBtn;

@property (weak, nonatomic) IBOutlet UIButton *isEmailBtn;
@property (weak, nonatomic) IBOutlet UIButton *isMobileBtn;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCodeWidth;

@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCountryBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (assign, nonatomic)  int loginType;


//修改语言
- (IBAction)ChangeLanguage:(UIButton *)sender;

//切换中英文文字
- (void)reloadTextView;

//切换登录方式
- (IBAction)selectLoginType:(id)sender;

//获取登录类型
- (NSString *)getAccountType;

//改变登录方式，这个方法需要覆盖
- (void)changeLoginType:(int)type;

@end

NS_ASSUME_NONNULL_END
