//
//  UIViewController+MTNavigation.m
//  ARThirdTools
//
//  Created by xiejc on 2018/12/20.
//

#import "UIViewController+MTNavigation.h"
#import "UIColor+MT.h"

@implementation UIViewController (MTNavigation)

#pragma mark - 导航栏
- (void)setRightButtonItemWithImage:(UIImage *)img action:(SEL)action {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setImage:img forState:UIControlStateNormal];
    [rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (void)setRightButtonItemWithTitle:(NSString *)title action:(SEL)action {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitleColor:MTColorHex(@"#414143") forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}

- (UIImageView *)findNavigationBarBottomLine {
    return [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}

//找到navigationBar下划线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] &&
        view.bounds.size.height <= 1.0 &&
        [view isKindOfClass:[UIImageView class]]) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}



#pragma mark - 跳转


- (id)preViewControllerWithPreCount:(NSUInteger)preCount {
    id preVC = nil;
    UINavigationController *navVC = self.navigationController;
    if (navVC) {
        NSUInteger index = [navVC.viewControllers indexOfObject:self];
        long preIndex = index - preCount;
        if (preIndex >= 0) {
            preVC = [navVC.viewControllers objectAtIndex:preIndex];
        }
    }
    return preVC;
}

- (id)preViewController {
    return [self preViewControllerWithPreCount:1];
}

- (void)replaceWithViewController:(UIViewController *)destinationViewController animated:(BOOL)animated {
    return [self pushViewController:destinationViewController fromPreCount:1 animated:animated];
}

- (void)pushViewController:(UIViewController *)destinationViewController fromPreCount:(NSUInteger)preCount animated:(BOOL)animated {
    UINavigationController *navVC = self.navigationController;
    
    if (navVC == nil || destinationViewController == nil) {
        NSLog(@"pushViewController nav or destinationViewController is nil");
        return;
    }
    
    NSUInteger index = [navVC.viewControllers indexOfObject:self];
    long preIndex = index - preCount;
    preIndex = MAX(0, preIndex);
    
    NSMutableArray *newVCList = [NSMutableArray array];
    for (int i = 0; i <= preIndex; i++) {
        [newVCList addObject:[navVC.viewControllers objectAtIndex:i]];
    }
    
    [newVCList addObject:destinationViewController];
    [navVC setViewControllers:newVCList animated:animated];
}

- (void)popToViewControllerWithPreCount:(NSUInteger)preCount animated:(BOOL)animated {
    UINavigationController *navVC = self.navigationController;
    
    if (navVC == nil) {
        NSLog(@"popToViewControllerWithPreCount navigation is nil");
        return;
    }
    
    NSUInteger index = [navVC.viewControllers indexOfObject:self];
    long preIndex = index - preCount;
    preIndex = MAX(0, preIndex);
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, preIndex + 1)];
    NSArray *newVCList = [navVC.viewControllers objectsAtIndexes:indexSet];
    [navVC setViewControllers:newVCList animated:animated];
}

@end
