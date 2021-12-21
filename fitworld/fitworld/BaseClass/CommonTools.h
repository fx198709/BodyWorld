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

//弹出alert内容  然后消失
+ (void)showAlertDismissWithContent:(NSString*)content control:(UIViewController*)control;

//专门问网络请求用的
+ (void)showAlertDismissWithResponseContent:(id)response control:(UIViewController*)control;


+ (void)showNETErrorcontrol:(UIViewController*)control;


+ (NSString*)reachLeftString:(double)diff;

/* 根据room的状态，改变按钮
 */
+ (void)changeBtnState:(UIButton*)vbutn btnData:(id)roomData;


+ (void)findLocaltionCityName:(id)user;

//找到视图归属的控制器，多用于tableview
+ (UIViewController*)findControlWithView:(UIView*)inView;

+ (UIEdgeInsets)safeAreaInsets;

//根据room的信息，进行跳转
+ (void)jumpNextVCwith:(id)roominfo rootVC:(UIViewController*)rootVC;

+ (NSUInteger)convertToInt:(NSString*)strtemp;

@end

NS_ASSUME_NONNULL_END
