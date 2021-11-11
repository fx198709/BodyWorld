//
//  UIImage+Extension.m
//  weibo
//
//  Created by yushuwei on 15/3/29.
//  Copyright (c) 2015年 weibo.com. All rights reserved.
//

#import "UIImage+Extension.h"
#import "NSObject+YCExtension.h"
#import "UIImageView+WebCache.h"

@implementation UIImage (Extension)

+ (UIImage *)convertViewToImage:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)nomalizeImage{
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0,0,self.size}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsBeginImageContext(self.size);
    return image;
}
+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = nil;
//    if (是否ios7) {
//        // 在最后面添加_os7
//        NSString *newName = [name stringByAppendingString:@"_os7"];
//        image = [UIImage imageNamed:newName];
//    }
    if (image == nil) {
        image = [UIImage imageNamed:name];
    }
    return image;
}
+(UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageWithName:name];
    
    // 这个方法是保护的部分尺寸
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageNamed:(NSString *)name renderingMode:(UIImageRenderingMode)renderingMode {
    UIImage *image = [UIImage imageNamed:name];
    image = [image imageWithRenderingMode:renderingMode];
    return image;
}

+ (id)compressImage:(UIImage *)image
          maxSizeKB:(NSInteger)maxSizeKB
      resultIsImage:(BOOL)resultIsImage
qualityCompressFirst:(BOOL)qualityCompressFirst
          completed:(void(^)(NSData *data, UIImage *image))completed
{
    __strong id result = nil;
    @autoreleasepool {
        maxSizeKB = maxSizeKB * 1024;
        // 首先进行质量压缩
        CGFloat compression = 1;
        CGFloat lastCompression = compression;
        UIImage *resultImage = image;
        NSData *resultData = UIImageJPEGRepresentation(image, compression);
        //如果是JPG图片
        if (resultData) {
            if (qualityCompressFirst && resultData.length > maxSizeKB) {
                CGFloat max = 1;
                CGFloat min = 0;
                for (int i = 0; i < 3; ++i) {
                    lastCompression = compression;
                    compression = (max + min) / 2;
                    resultData = UIImageJPEGRepresentation(image, compression);
                    //压缩过度
                    if (resultData.length < maxSizeKB) {
                        min = compression;
                        resultData = UIImageJPEGRepresentation(image, lastCompression);
                        break;
                    } else if (resultData.length > maxSizeKB) {
                        max = compression;
                    } else {
                        break;
                    }
                }
                resultImage = [UIImage imageWithData:resultData];
                
                if (resultData.length <= maxSizeKB) {
                    if (resultIsImage) {
                        result = resultImage;
                    }else{
                        result = resultData;
                    }
//                    NSLog(@"压缩后图片大小 = %@ KB",@(resultData.length/1024));
                    if (completed) {
                        completed(resultData,resultImage);
                    }
                    return result;
                }
            }
        }
        //这是PNG图片
        else{
            resultData = UIImagePNGRepresentation(resultImage);
        }
        
        // 这里进行尺寸压缩
        NSUInteger lastDataLength = 0;
        while (resultData.length > maxSizeKB && resultData.length != lastDataLength) {
            lastDataLength = resultData.length;
            CGFloat ratio = (CGFloat)maxSizeKB / resultData.length;
            //width 和 height转换成整型，防止绘制的图片有白边
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
            UIGraphicsBeginImageContext(size);
            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            resultData = UIImageJPEGRepresentation(resultImage, compression);
        }
        
        if (resultIsImage) {
            result = resultImage;
        }else{
            result = resultData;
        }
        if (completed) {
            completed(resultData,resultImage);
        }
//        NSLog(@"压缩后图片大小 = %@ KB",@(resultData.length/1024));
        return result;
    }
}

+ (NSData *)compressJPGEImage:(UIImage *)image maxByte:(CGFloat)maxByte {
    NSLog(@"最大 maxByte = %@",@(maxByte));
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData == nil) {
        imageData = UIImagePNGRepresentation(image);
        NSLog(@"JPG无法压缩，生成PNG");
        return imageData;
    }
    
    CGFloat start = 0;
    CGFloat end = 1;
    CGFloat compressionQuality = 1.0;
    
    //不需要压缩
    NSData *data = UIImageJPEGRepresentation(image, compressionQuality);
    if (maxByte - data.length/1024.00 > 0) {
        NSLog(@"不需要压缩");
        return data;
    }
    
    NSInteger compressionTime = 1;
    while(start < end)
    {
        compressionQuality = (start + end)/2.00;
        NSLog(@"压缩系数 = %@",@(compressionQuality));
        NSData *data = UIImageJPEGRepresentation(image, compressionQuality);
        long long dataSize = data.length/1024.00;
        long long size = maxByte - dataSize;
        //继续压缩
        if(size < 0){
            NSLog(@"继续压缩");
            if (compressionTime > 10) {
                return data;
            }
            end = end - 0.1;
        }
        //压缩完成
        else if(size <= 150){
            NSLog(@"完成 dataSize = %@",@(dataSize));
            return data;
        }
        //压缩过了
        else if(size > 150){
            NSLog(@"压缩过了");
            if (compressionTime > 10) {
                return data;
            }
            start = compressionQuality;
        }
        else{
            NSLog(@"继续压缩");
            if (compressionTime > 10) {
                return data;
            }
            end = compressionQuality;
        }
        compressionTime ++;
    }
    data = UIImageJPEGRepresentation(image, compressionQuality);
    return data;
}

/**
 *  指定Size压缩图片 (图片会压缩变形)
 *
 *  @param size  压缩size
 *
 *  @return 压缩后的图片
 */
- (UIImage *)scaleImageToSize:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}


@end
