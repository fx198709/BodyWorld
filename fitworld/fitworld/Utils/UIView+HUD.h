//
//  UIView+HUD.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (HUD)


//显示文字提示
- (void)showTextNotice:(NSString *)msg;

//显示标题 +文字提示
- (void)showTextNotice:(NSString *)title detail:(NSString *)detail;

@end

NS_ASSUME_NONNULL_END
