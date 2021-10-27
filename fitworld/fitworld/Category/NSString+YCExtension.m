//
//  NSString+YCExtension.m
//  Ework
//
//  Created by ChiJinLian on 16/11/22.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "NSString+YCExtension.h"

@implementation NSString (YCExtension)
- (NSString *)encodeURIComponent
{
    NSString *result =
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                              kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              CFSTR("!*'();:@&=+$,/?%#[] "),
                                                              kCFStringEncodingUTF8));
    return result;
}

- (NSString *)decodeURIComponent
{
    NSString *result =
    CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                              kCFAllocatorDefault,
                                                                              (CFStringRef)self,
                                                                              CFSTR(""),
                                                                              kCFStringEncodingUTF8));
    return result;
}

+ (NSArray *)intStrToArray:(NSString *)intStr {
    NSMutableArray *array = [NSMutableArray array];
    NSInteger length = intStr.length;
    if (length == 0) {
        return array;
    }
    else if (length == 1) {
        [array addObject:intStr];
        return array;
    }
    else{
        NSInteger i = 0;
        while (i < length) {
            [array addObject:[intStr substringWithRange:NSMakeRange(i, 1)]];
            i++;
        }
        return array;
    }
}
@end
