//
//  UIColor+MT.h
//  AutoReport
//
//  Created by xiejc on 2017/10/24.
//  Copyright © 2017年 newbee. All rights reserved.
//

#import <UIKit/UIKit.h>


#define MTColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define MTColorHex(hexString) [UIColor colorWithHexString:hexString]


@interface UIColor (MT)

/**
 *  解析颜色字符串。字符串格式为: #RGB, #ARGB, #RRGGBB, #AARRGGBB
 *
 *  @param hexString 颜色字符串
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHexString: (NSString *)hexString;
/**
 *  解析颜色字符串。字符串格式为: #RGB, #ARGB, #RRGGBB, #AARRGGBB
 *
 *  @param hexString 颜色字符串   @param alpha 透明度
 *
 *  @return 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

- (UIColor *)colorWithAlpha:(CGFloat)alpha;


@end
