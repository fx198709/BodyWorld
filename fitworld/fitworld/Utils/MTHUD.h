//
//  MTHUD.h
//  ZhongCaiHuaXiaCRM_iOS
//
//  Created by xiejc on 2019/2/12.
//  Copyright © 2019 xiejc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTHUD : UIView


/**
 弹出闪现的成功提示窗口
 */
+ (void)showDurationNoticeHUD:(NSString *)message;

/**
 弹出闪现的成功提示窗口

 @param message 信息
 @param animated 是否需要动画
 @param completedBlock 完成Block
 */
+ (void)showDurationNoticeHUD:(NSString *)message animated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock;

/**
 弹出加载中图文提示窗口
 */
+ (void)showLoadingHUD;


/**
 隐藏HUD弹出窗口
 */
+ (void)hideHUD;

/**
 隐藏HUD弹出窗口

 @param animated 是否需要动画
 @param completedBlock 结束回调
 */
+ (void)hideHUD:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock;

@end

NS_ASSUME_NONNULL_END
