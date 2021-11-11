//
//  UIView+MTWindow.m
//  BAIHC
//
//  Created by xiejc on 2019/4/29.
//  Copyright © 2019 YYCloud. All rights reserved.
//

#import "UIView+MTWindow.h"


#define Screen_Width        [UIScreen mainScreen].bounds.size.width
#define Screen_Height       [UIScreen mainScreen].bounds.size.height

#define MTViewWinndowAnimatedTime 0.4

@implementation UIView (MTWindow)


- (void)showAlphaAnimated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock {
    [self removeFromSuperview];
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    self.alpha = 0.0;
    UIWindow *currentWindow = [UIView getCurrentWindow];
    [currentWindow addSubview:self];
    if (animated) {
        [UIView animateWithDuration:MTViewWinndowAnimatedTime animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            if (completedBlock) {
                completedBlock();
            }
        }];
    } else {
        self.alpha = 1.0;
        if (completedBlock) {
            completedBlock();
        }
    }
}

- (void)hideAlphaAnimated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock {
    if (animated) {
        [UIView animateWithDuration:MTViewWinndowAnimatedTime delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self hideAlphaAnimated:NO completedBlock:completedBlock];
        }];
    } else {
        [self removeFromSuperview];
        if (completedBlock) {
            completedBlock();
        }
    }
}

- (void)showPopAnimated:(BOOL)animated containerView:(UIView *)containerView completedBlock:(void (^)(void))completedBlock {
    [self removeFromSuperview];
    self.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    containerView.center = CGPointMake(self.width * 0.5, self.height + containerView.height);
    UIWindow *currentWindow = [UIView getCurrentWindow];
    [currentWindow addSubview:self];

    if (animated) {
        [UIView animateWithDuration:MTViewWinndowAnimatedTime animations:^{
            containerView.center = CGPointMake(self.width * 0.5, self.height - containerView.height);
        } completion:^(BOOL finished) {
            if (completedBlock) {
                completedBlock();
            }
        }];
    } else {
        containerView.center = CGPointMake(self.width * 0.5, self.height - containerView.height);
        if (completedBlock) {
            completedBlock();
        }
    }
}

- (void)hidePopAnimated:(BOOL)animated containerView:(UIView *)containerView completedBlock:(void (^)(void))completedBlock {
    if (animated) {
        [UIView animateWithDuration:MTViewWinndowAnimatedTime delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            containerView.center = CGPointMake(self.width * 0.5, self.height + containerView.height);
        } completion:^(BOOL finished) {
            [self hidePopAnimated:NO containerView:containerView completedBlock:completedBlock];
        }];
    } else {
        [self removeFromSuperview];
        containerView.center = CGPointMake(self.width * 0.5, self.height - containerView.height);
        
        if (completedBlock) {
            completedBlock();
        }
    }
}

@end

