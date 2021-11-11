//
//  UIImage+Extension.h
//  weibo
//
//  Created by yushuwei on 15/3/29.
//  Copyright (c) 2015年 weibo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
//将view转成image
+ (UIImage *)convertViewToImage:(UIView *)view;
-(UIImage *)nomalizeImage;
+(UIImage *)imageWithName:(NSString *)name;
+(UIImage *)resizedImage:(NSString *)name;

/**
 *  根据输入颜色，返回一个纯色UIImage
 *
 *  @param color 
 *
 *  @return UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  根据name以及renderingMode生产图片
 *
 *  @param name
 *  @param renderingMode :
 UIImageRenderingModeAutomatic        // 根据图片的使用环境和所处的绘图上下文自动调整渲染模式(默认属性)。
 UIImageRenderingModeAlwaysOriginal   // 始终绘制图片原始状态，设置Tint Color属性无效。
 UIImageRenderingModeAlwaysTemplate   // 始终根据Tint Color绘制图片（颜色）显示，忽略图片的颜色信息（也就是图片原本的东西是不显示的）。
 *
 *  @return
 */
+ (UIImage *)imageNamed:(NSString *)name renderingMode:(UIImageRenderingMode)renderingMode;

/**
 质量压缩和尺寸压缩图片
 质量压缩最多压缩3次，如果仍不满足则进行尺寸压缩

 @param image         压缩原图
 @param maxSizeKB     压缩的最大大小（以KB为单位）
 @param resultIsImage 压缩返回 UIImage 还是 NSData （YES:UIImage，NO:NSData）
 @param qualityCompressFirst     是否优先进行质量压缩
 @param completed     完成回调
 @return              YES:UIImage，NO:NSData
 */
+ (id)compressImage:(UIImage *)image
          maxSizeKB:(NSInteger)maxSizeKB
      resultIsImage:(BOOL)resultIsImage
qualityCompressFirst:(BOOL)qualityCompressFirst
          completed:(void(^)(NSData *data, UIImage *image))completed;

/**
 压缩jpge图片，如果是png，则不压缩。压缩单位（KB）

 @param image 需要压缩的原图
 @param maxByte 图片最大值（以KB为单位）
 @return
 */
+ (NSData *)compressJPGEImage:(UIImage *)image maxByte:(CGFloat)maxByte;

/*
*  指定Size压缩图片 (图片会压缩变形)
*  @param size  压缩size
*
*  @return 压缩后的图片
*/
- (UIImage *)scaleImageToSize:(CGSize)size;

@end
