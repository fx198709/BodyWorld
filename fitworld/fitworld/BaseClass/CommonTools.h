//
//  CommonTools.h
//  FFitWorld
//
//  Created by feixiang on 2021/10/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonTools : NSObject

+ (NSDate*)dateFromInDate:(id)inDate;

+ (UIWindow *)mainWindow;

+ (void)showAlertDismissWithContent:(NSString*)content showWaitTime:(NSTimeInterval)time afterDelay:(NSTimeInterval)delay control:(UIViewController*)control;

+ (void)showAlertDismissWithContent:(NSString*)content control:(UIViewController*)control;

+ (void)showNETErrorcontrol:(UIViewController*)control;


+ (NSString*)reachLeftString:(double)diff;

/* 根据room的状态，改变按钮
 */
+ (void)changeBtnState:(UIButton*)vbutn btnData:(id)roomData;


+ (void)findLocaltionCityName:(id)user;

//找到视图归属的控制器，多用于tableview
+ (UIViewController*)findControlWithView:(UIView*)inView;


@end

NS_ASSUME_NONNULL_END
