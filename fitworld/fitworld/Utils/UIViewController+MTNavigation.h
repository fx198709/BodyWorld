//
//  UIViewController+MTNavigation.h
//  ARThirdTools
//
//  Created by xiejc on 2018/12/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MTNavigation)

#pragma mark - 导航栏


- (void)setRightButtonItemWithImage:(UIImage *)img action:(SEL)action;

- (void)setRightButtonItemWithTitle:(NSString *)title action:(SEL)action;

- (UIImageView *)findNavigationBarBottomLine;

#pragma mark - 跳转

- (id)preViewController;

- (id)preViewControllerWithPreCount:(NSUInteger)preCount;

- (void)replaceWithViewController:(UIViewController *)destinationViewController animated:(BOOL)animated;

- (void)pushViewController:(UIViewController *)destinationViewController fromPreCount:(NSUInteger)preCount animated:(BOOL)animated;

- (void)popToViewControllerWithPreCount:(NSUInteger)preCount animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
