//
//  UITabBarItem+YCExtension.m
//  BitAutoCRM
//
//  Created by ChiJinLian on 16/9/22.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "UITabBarItem+YCExtension.h"

@implementation UITabBarItem (YCExtension)
- (instancetype)initWithTitle:(nullable NSString *)title
                     imageStr:(nullable NSString *)imageStr
             selectedImageStr:(nullable NSString *)selectedImageStr
             titleNormalColor:(nullable UIColor *)titleNormalColor
             titleSelectColor:(nullable UIColor *)titleSelectColor
{
    UIImage *image = [UIImage imageNamed:imageStr renderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageStr renderingMode:UIImageRenderingModeAlwaysOriginal];
    self = [self initWithTitle:title image:image selectedImage:selectedImage];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: titleNormalColor} forState:UIControlStateNormal];
    [self setTitleTextAttributes:@{NSForegroundColorAttributeName: titleSelectColor} forState:UIControlStateSelected];
//    [self setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    //文字垂直方向向上移动2像素
    if (IsIphoneX) {
        [self setTitlePositionAdjustment:UIOffsetMake(0, 10)];
        self.imageInsets = UIEdgeInsetsMake(10, 0, -10, 0);
    }else{
        [self setTitlePositionAdjustment:UIOffsetMake(0, -2)];
//        self.imageInsets = UIEdgeInsetsMake(2, 0, -2, 0);
    }
    
    return self;
}
@end
