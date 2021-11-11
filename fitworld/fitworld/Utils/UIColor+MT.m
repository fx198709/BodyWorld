//
//  UIColor+MT.m
//  AutoReport
//
//  Created by xiejc on 2017/10/24.
//  Copyright © 2017年 newbee. All rights reserved.
//

#import "UIColor+MT.h"

@implementation UIColor (MT)

+ (UIColor *)colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    BOOL successFlag = YES;
    NSUInteger colorLength = [colorString length];
    if (colorLength == 3) {
        // #RGB
        alpha = 1.0f;
        red   = [self colorComponentFrom: colorString start: 0 length: 1];
        green = [self colorComponentFrom: colorString start: 1 length: 1];
        blue  = [self colorComponentFrom: colorString start: 2 length: 1];
    } else if (colorLength == 4) {
        // #ARGB
        alpha = [self colorComponentFrom: colorString start: 0 length: 1];
        red   = [self colorComponentFrom: colorString start: 1 length: 1];
        green = [self colorComponentFrom: colorString start: 2 length: 1];
        blue  = [self colorComponentFrom: colorString start: 3 length: 1];
    } else if (colorLength == 6) {
        // #RRGGBB
        alpha = 1.0f;
        red   = [self colorComponentFrom: colorString start: 0 length: 2];
        green = [self colorComponentFrom: colorString start: 2 length: 2];
        blue  = [self colorComponentFrom: colorString start: 4 length: 2];
    } else if (colorLength == 8) {
        // #AARRGGBB
        alpha = [self colorComponentFrom: colorString start: 0 length: 2];
        red   = [self colorComponentFrom: colorString start: 2 length: 2];
        green = [self colorComponentFrom: colorString start: 4 length: 2];
        blue  = [self colorComponentFrom: colorString start: 6 length: 2];
    } else {
        successFlag = NO;
        alpha = red = blue = green = 0.0f;
    }
    
    if (successFlag) {
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    } else {
        return nil;
    }
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}



- (UIColor *)colorWithAlpha:(CGFloat)alpha {
    CGFloat r = 0.0;
    CGFloat g = 0.0;
    CGFloat b = 0.0;
    CGFloat a = 0.0;
    [self getRed:&r green:&g blue:&b alpha:&a];
    
    UIColor *result = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    return result;
}

@end
