//
//  UIActionSheet+YCExtension.m
//  Ework
//
//  Created by ChiJinLian on 2017/11/1.
//  Copyright © 2017年 crm. All rights reserved.
//

#import "UIActionSheet+YCExtension.h"
#import "NSObject+YCExtension.h"

#define YCACTIONSHEET_DISMISS_NOTIFICATION   @"YCActionSheet_dismiss_notification"

@implementation UIActionSheet (YCExtension)
+ (void)load {
    if ([NSStringFromClass([self class]) isEqualToString:@"UIActionSheet"]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //        Method showInViewMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"showInView:"));
            //        Method YCShowInViewMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"YCShowInView:"));
            //        method_exchangeImplementations(showInViewMethod, YCShowInViewMethod);
            
            [self swizzleOriginalSEL:NSSelectorFromString(@"showInView:")
                    withSwizzlingSEL:NSSelectorFromString(@"YCShowInView:")
                         targetClass:[self class]];
            
            //        Method showFromRectMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"showFromRect:inView:animated:"));
            //        Method YCShowFromRectMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"YCShowFromRect:inView:animated:"));
            //        method_exchangeImplementations(showFromRectMethod, YCShowFromRectMethod);
            
            [self swizzleOriginalSEL:NSSelectorFromString(@"showFromRect:inView:animated:")
                    withSwizzlingSEL:NSSelectorFromString(@"YCShowFromRect:inView:animated:")
                         targetClass:[self class]];
            
            //        Method showFromBarButtonItemMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"showFromBarButtonItem:animated:"));
            //        Method YCShowFromBarButtonItemMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"YCShowFromBarButtonItem:animated:"));
            //        method_exchangeImplementations(showFromBarButtonItemMethod, YCShowFromBarButtonItemMethod);
            
            [self swizzleOriginalSEL:NSSelectorFromString(@"showFromBarButtonItem:animated:")
                    withSwizzlingSEL:NSSelectorFromString(@"YCShowFromBarButtonItem:animated:")
                         targetClass:[self class]];
            
            //        Method showFromTabBarMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"showFromTabBar:"));
            //        Method YCShowFromTabBarMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"YCShowFromTabBar:"));
            //        method_exchangeImplementations(showFromTabBarMethod, YCShowFromTabBarMethod);
            
            [self swizzleOriginalSEL:NSSelectorFromString(@"showFromTabBar:")
                    withSwizzlingSEL:NSSelectorFromString(@"YCShowFromTabBar:")
                         targetClass:[self class]];
            
            //        Method showFromToolbarMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"showFromToolbar:"));
            //        Method YCShowFromToolbarMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"YCShowFromToolbarMethod:"));
            //        method_exchangeImplementations(showFromToolbarMethod, YCShowFromToolbarMethod);
            
            [self swizzleOriginalSEL:NSSelectorFromString(@"showFromToolbar:")
                    withSwizzlingSEL:NSSelectorFromString(@"YCShowFromToolbarMethod:")
                         targetClass:[self class]];
        });
    }
}

- (void)YCShowInView:(UIView *)view {
    [self YCShowInView:view];
    [self addNotificationCenter];
}

- (void)YCShowFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {
    [self YCShowFromRect:rect inView:view animated:animated];
    [self addNotificationCenter];
}

- (void)YCShowFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated {
    [self YCShowFromBarButtonItem:item animated:animated];
    [self addNotificationCenter];
}

- (void)YCShowFromTabBar:(UITabBar *)view {
    [self YCShowFromTabBar:view];
    [self addNotificationCenter];
}

- (void)YCShowFromToolbar:(UIToolbar *)view {
    [self YCShowFromToolbar:view];
    [self addNotificationCenter];
}

- (instancetype)initWithTitle:(NSString *)title YCDelegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [self initWithTitle:title YCDelegate:delegate cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil];
    
    if (self) {
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:3];
        
        if (cancelButtonTitle) {
            [titleArray addObject:cancelButtonTitle];
        }
        
        if (otherButtonTitles) {
            
            [titleArray addObject:otherButtonTitles];
            
            id buttonTitle = nil;
            va_list argumentList;
            va_start(argumentList, otherButtonTitles);
            while ((buttonTitle=(__bridge NSString *)va_arg(argumentList, void *))) {
                if (buttonTitle) {
                    [titleArray addObject:buttonTitle];
                }
            }
            va_end(argumentList);
            
        }
        
        for (NSString *title in titleArray) {
            [self addButtonWithTitle:title];
        }
        
        [self addNotificationCenter];
    }
    return self;
}

- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YCACTIONSHEET_DISMISS_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismiss:)
                                                 name:YCACTIONSHEET_DISMISS_NOTIFICATION
                                               object:nil];
}

- (void)dismiss:(NSNotification *)notification {
    [self dismissWithClickedButtonIndex:0 animated:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YCACTIONSHEET_DISMISS_NOTIFICATION object:nil];
}

+ (void)YCActionSheetDissmissNotic {
    [[NSNotificationCenter defaultCenter] postNotificationName:YCACTIONSHEET_DISMISS_NOTIFICATION
                                                        object:nil
                                                      userInfo:nil];
}
@end
