//
//  UIView+HUD.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import "UIView+HUD.h"
#import "MBProgressHUD.h"

@implementation UIView (HUD)


//显示文字提示
- (void)showTextNotice:(NSString *)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2.0];
}

@end
