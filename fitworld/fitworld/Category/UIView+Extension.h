//
//  UIView+Extension.h
//  221
//
//  Created by C.K.Lian on 16/3/23.
//  Copyright © 2016年 C.K.Lian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGSize afterLayoutSize;

/**
*  设置圆角
*
*  @param corners     设置哪个角(可多选)
*  @param cornerRadii 圆角大小
*/
- (void)setCorner:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;

/**
 *  设置四个圆角
 *
 *  @param cornerRadius 圆角大小
 */
- (void)setAllCornerRadius:(CGFloat)cornerRadius;

/**
 *  取消圆角
 */
- (void)setNoneCorner;

/** 在指定view上绘制虚线
 ** lineView:       需要绘制成虚线的view
 ** lineLength:     虚线的宽度
 ** lineSpacing:    虚线的间距
 ** lineColor:      虚线的颜色
 **/
+ (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

/**
 从视图获取指定视图

 @param view 最底层父视图
 @param viewClassName 指定视图的名称
 @return 指定视图
 */
+ (UIView *)getSpecifyViewFromView:(UIView *)view specifyViewClassName:(NSString *)viewClassName;


/**
 对指定view添加渐变颜色

 @param view 指定view
 @param fromColor 起始颜色
 @param toColor   结束颜色
 @param startPoint 设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
 @param endPoint 设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
 @return 渐变层CAGradientLayer
 */
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(UIColor *)fromColor toColor:(UIColor *)toColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
@end
