//
//  NSString+YCExtension.h
//  Ework
//
//  Created by ChiJinLian on 16/11/22.
//  Copyright © 2016年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YCExtension)
/**
 *  UTF8编码
 *
 *  @return
 */
- (NSString *)encodeURIComponent;

/**
 *  UTF8解码
 *
 *  @return 
 */
- (NSString *)decodeURIComponent;

/**
 整数字符串转换为数组

 @param intStr 整数字符
 @return NSArray
 */
+ (NSArray *)intStrToArray:(NSString *)intStr;
@end
