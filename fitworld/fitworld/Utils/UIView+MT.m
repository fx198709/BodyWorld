//
//  UIView+MT.m
//  TToolsHelper
//
//  Created by xiejc on 2017/7/31.
//  Copyright © 2017年 Xiejc. All rights reserved.
//

#import "UIView+MT.h"
#import "UIImage+Extension.h"

@implementation UIView (MT)

+ (UIWindow *)getCurrentWindow {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window == nil) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    if (window == nil) {
        window = [[UIApplication sharedApplication] windows].firstObject;
    }
    return window;
}


+ (id)viewByNib:(NSString *)nibName {
    UIView *aView = nil;
    NSArray *viewList = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    if (viewList.count > 0) {
        aView = viewList.firstObject;
    }
    return aView;
}

- (UIViewController *)viewControllerOwnner {
    UIView *next = [self superview];
    while (next) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        next = [next superview];
    }
    return nil;
}


- (UIImage *)captureImage {
    UIImage *image = nil;
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self;
        UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, NO, scrollView.layer.contentsScale);
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        scrollView.contentOffset = CGPointMake(0, scrollView.contentSize.height-scrollView.frame.size.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
        
        UIGraphicsEndImageContext();
    } else {
        CGRect rect = self.frame;
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.layer renderInContext:context];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

- (void)clearAllSubViews {
    for (UIView *aView in self.subviews) {
        [aView removeFromSuperview];
    }
}

#pragma mark - corner

- (void)cornerWithRadius:(float)cornerR borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerR;
    if (borderColor) {
        self.layer.borderWidth = borderWidth;
        self.layer.borderColor = borderColor.CGColor;
    }
}

- (void)cornerWithRadius:(float)cornerR borderColor:(UIColor *)borderColor {
    [self cornerWithRadius:cornerR borderColor:borderColor borderWidth:1];
}

- (void)cornerWithRadius:(float)cornerR {
    [self cornerWithRadius:cornerR borderColor:self.backgroundColor];
}

- (void)cornerHalf {
    [self cornerHalfWithBorderColor:self.backgroundColor];
}

- (void)cornerHalfWithBorderColor:(UIColor *)borderColor {
    [self cornerWithRadius:CGRectGetHeight(self.frame) * 0.5 borderColor:borderColor];
}

- (void)cornerTopWithRadius:(float)cornerR borderColor:(UIColor *)borderColor {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(cornerR, cornerR)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    if (borderColor) {
        maskLayer.borderColor = borderColor.CGColor;
    }
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)cornerLeftHalf {
    [self cornerWithRadius:CGRectGetHeight(self.frame) * 0.5];
}

- (void)cornerLeftWithRadius:(float)cornerR {
    [self cornerLeftWithRadius:cornerR borderColor:self.backgroundColor];
}

- (void)cornerLeftWithRadius:(float)cornerR borderColor:(UIColor *)borderColor {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(cornerR, cornerR)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    if (borderColor) {
        maskLayer.borderColor = borderColor.CGColor;
    }
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


-(void)shadowWithColor:(UIColor *)color {
    [self shadowWithOffset:0 raduis:4.0 color:color opacity:0.1];
}

- (void)shadowWithOffset:(float)offset raduis:(float)cornerR color:(UIColor *)color opacity:(float)opacity {
    // 阴影颜色
    self.layer.shadowColor = color.CGColor;
    // 阴影透明度
    self.layer.shadowOpacity = opacity;
    // 阴影偏移
    self.layer.shadowOffset = CGSizeMake(offset, offset);
    // 阴影半径
    self.layer.shadowRadius = cornerR;
    self.layer.cornerRadius = cornerR * 2.0;
}


#pragma mark - frame

- (CGFloat)x {
    return self.frame.origin.x;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)resetWidthFrame:(float)w {
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (void)resetHeightFrame:(float)h {
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (void)resetXFrame:(float)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (void)resetYFrame:(float)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

+ (void)setupSearchBar2:(UISearchBar *)searchBar {
    searchBar.backgroundColor = UIColor.blackColor;
    for (UIView *view in searchBar.subviews.lastObject.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            view.layer.contents = nil;
            break;
        }
    }
    searchBar.backgroundImage = [UIImage imageWithColor:BgGrayColor];
}

+ (void)setupSearchBar:(UISearchBar *)searchBar {
    searchBar.backgroundColor = BgGrayColor;
    searchBar.tintColor = [UIColor whiteColor];
    for (UIView *view in searchBar.subviews.lastObject.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            view.layer.contents = nil;
            break;
        }
    }
    searchBar.backgroundImage = [UIImage imageWithColor:BgGrayColor];
    UITextField *searchField;
    if (@available(iOS 13.0, *)) {
        searchField = searchBar.searchTextField;
    } else {
        searchField = [searchBar valueForKey:@"_searchField"];
    }
    
    searchField.textColor = [UIColor whiteColor];
    searchField.font = [UIFont systemFontOfSize:14.0];
    searchField.backgroundColor = BgGrayColor;
    
    //设置搜索图片
    
    [searchBar setImage:[UIImage imageNamed:@"icon_search_find"]
       forSearchBarIcon:UISearchBarIconSearch
                  state:UIControlStateNormal];
}

@end
