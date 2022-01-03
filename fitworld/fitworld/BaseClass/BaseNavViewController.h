//
//  BaseNavViewController.h
//  FFitWorld
//
//  Created by syswin on 2021/10/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavViewController : UIViewController
@property (nonatomic, assign)BOOL isTapBack;

- (void)forceOrientationLandscape;
//强制竖屏
- (void)forceOrientationPortrait;

@end

NS_ASSUME_NONNULL_END
