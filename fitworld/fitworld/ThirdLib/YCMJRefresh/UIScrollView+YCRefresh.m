//
//  UIScrollView+YCRefresh.m
//  test
//
//  Created by YiChe on 16/8/4.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import "UIScrollView+YCRefresh.h"
#import <objc/runtime.h>
#import "NSObject+YCExtension.h"

@implementation UIScrollView (YCRefresh)

- (void)addHeaderWithTarget:(id)target action:(SEL)action {
//    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
//    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//    [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
//    [header setTitle:@"正在刷新中..." forState:MJRefreshStateRefreshing];
//    header.stateLabel.textColor = [UIColor lightGrayColor];
//    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
//    self.mj_header = header;
    
    CJMJRefreshGifHeader *header = [CJMJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    NSMutableArray *imageArrays = [NSMutableArray array];
    for (int i =1; i< 9; i++) {
        UIImage *refreshImage = [UIImage imageNamed:[NSString stringWithFormat:@"car-image-%d",i]];
        [imageArrays addObject:refreshImage];
    }
    [header setImages:@[[UIImage imageNamed:@"car-image-1"]] forState:MJRefreshStateIdle];
    [header setImages:imageArrays
             duration:0.8
             forState:MJRefreshStatePulling];
    [header setImages:imageArrays
             duration:0.8
             forState:MJRefreshStateRefreshing];
    //icon_loading_first的图片宽度的一半
    header.labelLeftInset = -87/2.0;
    header.backgroundColor = UIColorFromRGB(0xf0eff5);
//    header.gifView.mj_y = 30;
//    header.gifView.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    self.mj_header = header;
}

- (void)addFooterWithTarget:(id)target action:(SEL)action {
//    CJMJRefreshBackNormalFooter *footer = [CJMJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
//    [footer setTitle:@"上拉加载更多数据" forState:MJRefreshStateIdle];
//    [footer setTitle:@"松开加载更多数据" forState:MJRefreshStatePulling];
//    [footer setTitle:@"正在加载中..." forState:MJRefreshStateRefreshing];
//    [footer setTitle:@"松开加载更多数据" forState:MJRefreshStateWillRefresh];
//    [footer setTitle:@"已经加载全部数据" forState:MJRefreshStateNoMoreData];
//    footer.stateLabel.textColor = [UIColor lightGrayColor];
//    self.mj_footer = footer;
    
    CJMJRefreshBackNormalFooter *footer = [CJMJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    [footer setTitle:@"一 End 一" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [UIColor lightGrayColor];
    footer.stateLabel.font = SystemFontOfSize(11);

    [footer setImages:@[[UIImage imageNamed:@"icon_loading_first"]] forState:MJRefreshStateIdle];
    [footer setImages:@[[UIImage imageNamed:@"icon_loading_first"],
                        [UIImage imageNamed:@"icon_loading_second"],
                        [UIImage imageNamed:@"icon_loading_third"]]
             duration:0.6
             forState:MJRefreshStateRefreshing];
    //9 为icon_loading_first的图片宽度的一半
    footer.labelLeftInset = -9;
    self.mj_footer = footer;
}

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader {
    [self.mj_header removeFromSuperview];
}

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter {
    [self.mj_footer removeFromSuperview];
}

@end


@implementation CJMJRefreshBackNormalFooter

+ (void)initialize {
    if ([NSStringFromClass([self class]) isEqualToString:@"CJMJRefreshBackNormalFooter"]) {
//        Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"resetNoMoreData"));
//        Method method2 = class_getInstanceMethod([self class], NSSelectorFromString(@"CJResetNoMoreData"));
//        method_exchangeImplementations(method1, method2);
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self swizzleOriginalSEL:NSSelectorFromString(@"resetNoMoreData")
                    withSwizzlingSEL:NSSelectorFromString(@"CJResetNoMoreData")
                         targetClass:[self class]];
        });
    }
    
}

/**
 *  =_= 坑爹！！！有坑
 *  更改state状态后，会自动修改stateLabel的标题，
 *  这种修改UI的行为应该是在 main_queue 线程执行才会有效果的啊
 */
- (void)CJResetNoMoreData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self CJResetNoMoreData];
    });
}

//针对iphoneX 上拉加载更多的适配
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.withoutChangeXIgnoredScrollContentInsetBottom && IsIphoneX) {
        CGRect scrollViewRect = [self.scrollView.superview convertRect:self.scrollView.frame toView:[CommonTools mainWindow]];
        CGRect iPhoneXBottomRect = CGRectMake(0, ScreenHeightWithType(AllHeight)-IphoneXBottomHeight, ScreenWidth, IphoneXBottomHeight);
        if (CGRectIntersectsRect(scrollViewRect, iPhoneXBottomRect)) {
            self.ignoredScrollViewContentInsetBottom = IphoneXBottomHeight;
        }else{
            self.ignoredScrollViewContentInsetBottom = 0;
        }
    }
}

@end

//新图 670 × 108  小车  212 × 120
//刷新控件高度
static const CGFloat kRefreshHeight       =  88;
//背景图片宽度
static const CGFloat kBackImageWidth      =  335;
static const CGFloat kBackImageHeight     =  54;
static const CGFloat kBackGifViewLeft     =  35;
//背景图动画时间
static const CGFloat kBackGifTimeInterval =  12;

@implementation CJMJRefreshGifHeader

- (void)prepare {
    [super prepare];
    self.mj_h = kRefreshHeight;
    //根据拖拽的情况自动切换透明度
    self.automaticallyChangeAlpha = YES;
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    [self backGifView];
}

- (void)placeSubviews {
    [super placeSubviews];
    self.gifView.contentMode = UIViewContentModeBottom;
    self.gifView.frame = CGRectMake((ScreenWidth- 106)/2, 10, 106, 60);
}

- (void)setState:(MJRefreshState)state {
    [super setState:state];
    if (state == MJRefreshStateIdle && self.alpha == 0) {
        [self backGIFStopAnimation];
    }
    else if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        [self backGIFStartAnimation];
    }
    
    if (state == MJRefreshStateIdle) {
        _ycStateLabel.text = @"下拉刷新";
    }
    
    if (state == MJRefreshStatePulling) {
        _ycStateLabel.text = @"该放手了，我要刷新了...";
    }
    
    if (state == MJRefreshStateRefreshing) {
        _ycStateLabel.text = @"正在刷新...";
    }
    
    /*

     */
    
}

- (void)backGifView {
    
    UIView *backGifView = [[UIView alloc]initWithFrame:CGRectMake(kBackGifViewLeft, 3, ScreenWidth-kBackGifViewLeft*2, kBackImageHeight)];
    backGifView.backgroundColor = [UIColor clearColor];
    backGifView.clipsToBounds = YES;
    [self addSubview:backGifView];
    [self sendSubviewToBack:backGifView];
    
    self.backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kBackImageWidth, kBackImageHeight)];
    self.backView.image = [UIImage imageNamed:@"gif_general_bg_first"];
    self.backView.contentMode = UIViewContentModeScaleAspectFill;
    [backGifView addSubview:self.backView];
    
    self.backView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kBackImageWidth, kBackImageHeight)];
    self.backView2.image = [UIImage imageNamed:@"gif_general_bg_first"];
    self.backView2.contentMode = UIViewContentModeScaleAspectFill;
    [backGifView addSubview:self.backView2];
    
    UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, kBackImageHeight)];
    leftView.image = [UIImage imageNamed:@"gradient_left"];
    [backGifView addSubview:leftView];
    [backGifView bringSubviewToFront:leftView];
    
    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-kBackGifViewLeft*2-20, 0, 20, kBackImageHeight)];
    rightView.image = [UIImage imageNamed:@"gradient_right"];
    [backGifView addSubview:rightView];
    [backGifView bringSubviewToFront:rightView];
    
    _ycStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 67, ScreenWidth, 18)];
    [self addSubview:_ycStateLabel];
    _ycStateLabel.font = SystemFontOfSize(11);
    _ycStateLabel.textColor = UIColorFromRGB(0x7A818D);
    _ycStateLabel.textAlignment = NSTextAlignmentCenter;

    
}

- (void)backGIFStartAnimation {
    if (self.animationing) {
        return;
    }
    self.animationing = NO;
    [self.backView.layer removeAllAnimations];
    [self.backView2.layer removeAllAnimations];
    
    CGPoint fromPoint = CGPointMake(0, kBackImageHeight/2.0);
    CGPoint toPoint   = CGPointMake(-kBackImageWidth,kBackImageHeight/2.0);
    CABasicAnimation *animation = GetPositionAnimation([NSValue valueWithCGPoint:fromPoint], [NSValue valueWithCGPoint:toPoint], kBackGifTimeInterval, @"transform.translation.x",YES);
    [self.backView.layer addAnimation:animation forKey:nil];
    
    CGPoint fromPoint2 = CGPointMake(kBackImageWidth, kBackImageHeight/2.0);
    CGPoint toPoint2   = CGPointMake(0,kBackImageHeight/2.0);
    CABasicAnimation *animation2 = GetPositionAnimation([NSValue valueWithCGPoint:fromPoint2], [NSValue valueWithCGPoint:toPoint2], kBackGifTimeInterval, @"transform.translation.x",YES);
    [self.backView2.layer addAnimation:animation2 forKey:nil];
    
    self.animationing = YES;
}

- (void)backGIFStopAnimation {
    if (self.animationing) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            self.animationing = NO;
            [self.backView.layer removeAllAnimations];
            [self.backView2.layer removeAllAnimations];
        });
    }
}

@end
