//
//  UIPickerView+YCExtension.m
//  Ework
//
//  Created by ChiJinLian on 16/11/17.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "UIPickerView+YCExtension.h"
#import "NSObject+YCExtension.h"

@implementation UIPickerView (YCExtension)

+ (void)load {
//    Method orginalMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"layoutSubviews"));
//    Method newMethod = class_getInstanceMethod([self class], @selector(YClayoutSubviews));
//    //交换方法
//    method_exchangeImplementations(orginalMethod, newMethod);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleOriginalSEL:NSSelectorFromString(@"layoutSubviews")
                withSwizzlingSEL:@selector(YClayoutSubviews)
                     targetClass:[self class]];
    });
}

- (void)YClayoutSubviews {
    if (iOS_VERSION >= 10) {
        //设置分割线的颜色
        for(UIView *singleLine in self.subviews){
            if (singleLine.frame.size.height < 1){
                singleLine.backgroundColor = UIRGBColor(189,190,191,0.8);
            }
        }
    }
    [self YClayoutSubviews];
}
@end
