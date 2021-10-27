//
//  NSDate+Extension.h
//  BitAutoCRM
//
//  Created by C.K.Lian on 16/3/29.
//  Copyright © 2016年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
@property (nonatomic, copy)NSString *ycYear;
@property (nonatomic, copy)NSString *ycMonth;
@property (nonatomic, copy)NSString *ycDay;
@property (nonatomic, copy)NSString *ycHour;
@property (nonatomic, copy)NSString *ycMinute;
@property (nonatomic, copy)NSString *ycSecond;

/**
 *  将GMT时间转换为本地时间
 *
 *  @param date <#date description#>
 *
 *  @return
 */
+ (NSDate *)toLocalDate:(NSDate *)date;

/**
 *  根据传入时间字符串转换为本地时间字符串
 *
 *  @param str
 *
 *  @return (2016年06月21日 16:53:02)
 */
+ (NSString *)getLocaleTimeStr:(NSString *)str;

/**
 *  转换为NSDate
 *
 *  @param str (2016-06-21T17:05:00)
 *
 *  @return (20160621170500)
 */
+ (NSDate *)changeToDate:(NSString *)str;

/**
 *  NSString转换为NSDate
 *
 *  @param str 字符串格式 2016-10-20T12:06:11.2491615+08:00
 *
 *  @return <#return value description#>
 */
+ (NSDate *)dateWithString:(NSString *)str;

/**
 *  NSString转换为NSDate
 *
 *  @param str 字符串格式 2016-10-20T12:06:11.2491615+08:00 
                    或者 2016-10-20T12:06:11.249 
                    或者 2016-01-20T17:24:08
                    或者 2017-12-09 00:00:00
 *
 *  @return <#return value description#>
 */
+ (NSDate *)dateFormatterString:(NSString *)str;

/**
 *  获取date时间的字符串
 *
 *  @param date
 *
 *  @return 
 */
+ (NSString *)getDataTimeStr:(NSDate *)date;

/**
 *  获取年月日的字符串
 *
 *  @param date
 *
 *  @return
 */
+ (NSString *)getYYYYMMDDStr:(NSDate *)date;

+ (NSString *)dateToStr:(NSDate *)date formatStr:(NSString *)formatStr;
+ (NSDate *)strToDate:(NSString *)str formatStr:(NSString *)formatStr;

/**
 *  只保留日期的年月日
 *
 *  @param date
 *
 *  @return
 */
+ (NSDate *)extractDateYMD:(NSDate *)date;
@end
