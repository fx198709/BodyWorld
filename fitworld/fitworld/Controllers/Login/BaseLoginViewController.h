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

//修改语言
- (IBAction)ChangeLanguage:(UIButton *)sender;

//切换中英文文字
- (void)reloadTextView;

//切换登录方式
- (IBAction)selectLoginType:(id)sender;

//获取登录类型
- (NSString *)getAccountType;

@end

NS_ASSUME_NONNULL_END
