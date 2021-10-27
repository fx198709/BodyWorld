//
//  UIAlertView+YCExtension.m
//  Ework
//
//  Created by ChiJinLian on 2017/11/1.
//  Copyright © 2017年 crm. All rights reserved.
//

#import "UIAlertView+YCExtension.h"
#import "NSObject+YCExtension.h"

#define YCALERTVIEW_DISMISS_NOTIFICATION   @"YCAlertView_dismiss_notification"

@implementation UIAlertView (YCExtension)
+ (void)load {
    if ([NSStringFromClass([self class]) isEqualToString:@"UIAlertView"]) {
//        Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"show"));
//        Method method2 = class_getInstanceMethod([self class], NSSelectorFromString(@"YCShow"));
//        method_exchangeImplementations(method1, method2);
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self swizzleOriginalSEL:NSSelectorFromString(@"show")
                    withSwizzlingSEL:NSSelectorFromString(@"YCShow")
                         targetClass:[self class]];
        });
    }
    
}

- (void)YCShow {
    [self YCShow];
    [self addNotificationCenter];
}

- (void)addNotificationCenter {
    if (self.tag == ALERT_TAG_ZHIWEN) {
        return;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YCALERTVIEW_DISMISS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismiss:)
                                                 name:YCALERTVIEW_DISMISS_NOTIFICATION
                                               object:nil];
}

- (void)dismiss:(NSNotification *)notification {
    [self dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YCALERTVIEW_DISMISS_NOTIFICATION object:nil];
}

+ (void)YCAlertViewDissmissNotic {
    [[NSNotificationCenter defaultCenter] postNotificationName:YCALERTVIEW_DISMISS_NOTIFICATION
                                                        object:nil
                                                      userInfo:nil];
}

@end

