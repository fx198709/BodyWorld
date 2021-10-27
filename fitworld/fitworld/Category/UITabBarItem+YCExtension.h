//
//  UITabBarItem+YCExtension.h
//  BitAutoCRM
//
//  Created by ChiJinLian on 16/9/22.
//  Copyright © 2016年 crm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (YCExtension)
- (instancetype _Nonnull)initWithTitle:(nullable NSString *)title
                     imageStr:(nullable NSString *)imageStr
             selectedImageStr:(nullable NSString *)selectedImageStr
             titleNormalColor:(nullable UIColor *)titleNormalColor
             titleSelectColor:(nullable UIColor *)titleSelectColor;
@end
