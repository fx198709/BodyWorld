//
//  UIScrollView+YCExtension.h
//  Ework
//
//  Created by ChiJinLian on 2017/7/4.
//  Copyright © 2017年 crm. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Y 轴方向滑动位置
 */
typedef enum : NSUInteger {
    OffsetTypeMin  = 0,  //滑到顶部
    OffsetTypeToUp,      //向上滑
    OffsetTypeToDown,    //向下滑
    OffsetTypeMax,       //滑到底部
} YCContentOffsetYType;

@interface UIScrollView (YCExtension)
/**
 开启 Y 轴方向滑动位置监听
 注意：！！开启后请在该 UIScrollView 所在的 父view 或者 ViewController 中的dealloc方法中调用
 */
@property (nonatomic, assign) BOOL enableContentOffsetYTypeKVO;
/**
 Y 轴方向滑动位置
 */
@property (nonatomic, assign, readonly) YCContentOffsetYType contentOffsetYType;

/**
 是否允许多个手势同时执行
 */
@property (nonatomic, copy) BOOL(^shouldRecognizeSimultaneouslyWithGestureRecognizer)(UIScrollView *scrollView);

/**
 滑动事件回调block
 */
@property (nonatomic, copy) void(^scrollViewDidScrollBlock)(UIScrollView *scrollView, YCContentOffsetYType contentOffsetYType);

/**
 设置下拉回弹视图的背景色

 @param color 背景色
 */
- (void)changeScrollOffsetViewBackColor:(UIColor *)color;

/**
 * 移除下拉回弹视图的监听
 * 注意：！！请在该 UIScrollView 所在的 父view 或者 ViewController 中的dealloc方法中调用
 * 设置下拉回弹视图的背景色后必须对应移除
 */
- (void)removeOffsetViewObserver;

/**
 更改contentOffset事件
 父view触发scrollViewDidScrollToTop事件事，请调用这个方法更改当前UIScrollView的contentOffset

 @param contentOffset    contentOffset
 @param animated         是否开启动画
 @param withoutMessage   是否回调scrollViewDidScrollBlock
 */
- (void)changeContentOffset:(CGPoint)contentOffset animated:(BOOL)animated withoutDidScrollBlockMessage:(BOOL)withoutMessage;
@end
