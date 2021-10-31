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

@end

NS_ASSUME_NONNULL_END
