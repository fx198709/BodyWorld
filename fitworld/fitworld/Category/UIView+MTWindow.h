//
//  UIView+MTWindow.h
//  BAIHC
//
//  Created by xiejc on 2019/4/29.
//  Copyright © 2019 YYCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MTWindow)


/**
 在window上显示，动画：从明到暗

 @param animated 是否需要动画
 @param completedBlock 动画
 */
- (void)showAlphaAnimated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock;

/**
 在window上隐藏，动画：从暗到明
 
 @param animated 是否需要动画
 @param completedBlock 动画
 */
- (void)hideAlphaAnimated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock;



/**
 在window上显示，动画：从下到上 - farme方式
 
 @param animated 是否需要动画
 @param completedBlock 动画
 */
- (void)showPopAnimated:(BOOL)animated containerView:(UIView *)containerView completedBlock:(nullable void(^)(void))completedBlock;

/**
 在window上隐藏，动画：从上到下 - farme方式
 
 @param animated 是否需要动画
 @param completedBlock 动画
 */
- (void)hidePopAnimated:(BOOL)animated containerView:(UIView *)containerView completedBlock:(nullable void(^)(void))completedBlock;


@end

NS_ASSUME_NONNULL_END
