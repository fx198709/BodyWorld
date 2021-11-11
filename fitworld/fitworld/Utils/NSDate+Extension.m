//
//  NSDate+Extension.m
//  BitAutoCRM
//
//  Created by C.K.Lian on 16/3/29.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
static char yearKey;
static char monthKey;
static char dayKey;
static char hourKey;
static char minuteKey;
static char secondKey;

- (void)setYcYear:(NSString *)year {
    objc_setAssociatedObject(self, &yearKey, year, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ycYear {
    NSString *value = objc_getAssociatedObject(self, &yearKey);
    if (value && value.length > 0) {
        return value;
    }else{
        NSString *timeStr = [NSDate getDataTimeStr:self];
        NSRange range = [timeStr rangeOfString:@"年"];
        NSString *yearStr = [timeStr substringWithRange:NSMakeRange(0, range.location-0)];
        self.ycYear = yearStr;
        return yearStr;
    }
}
- (void)setYcMonth:(NSString *)month {
    objc_setAssociatedObject(self, &monthKey, month, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ycMonth {
    NSString *value = objc_getAssociatedObject(self, &monthKey);
    if (value && value.length > 0) {
        return value;
    }else{
        NSString *timeStr = [NSDate getDataTimeStr:self];
        NSRange yearRange = [timeStr rangeOfString:@"年"];
        NSRange monthRange = [timeStr rangeOfString:@"月"];
        NSString *monthStr = [timeStr substringWithRange:NSMakeRange(yearRange.location+yearRange.length, monthRange.location-(yearRange.location+yearRange.length))];
        self.ycMonth = monthStr;
        return monthStr;
    }
}
- (void)setYcDay:(NSString *)day {
    objc_setAssociatedObject(self, &dayKey, day, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ycDay {
    NSString *value = objc_getAssociatedObject(self, &dayKey);
    if (value && value.length > 0) {
        return value;
    }else{
        NSString *timeStr = [NSDate getDataTimeStr:self];
        NSRange monthRange = [timeStr rangeOfString:@"月"];
        NSRange dayRange = [timeStr rangeOfString:@"日"];
        NSString *dayStr = [timeStr substringWithRange:NSMakeRange(monthRange.location+monthRange.length, dayRange.location-(monthRange.location+monthRange.length))];
        self.ycDay = dayStr;
        return dayStr;
    }
}

- (void)setYcHour:(NSString *)hour {
    objc_setAssociatedObject(self, &hourKey, hour, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ycHour {
    NSString *value = objc_getAssociatedObject(self, &hourKey);
    if (value && value.length > 0) {
        return value;
    }else{
        NSString *timeStr = [NSDate getDataTimeStr:self];
        NSRange dayRange = [timeStr rangeOfString:@"日"];
        NSRange hourRange = [timeStr rangeOfString:@"时"];
        NSString *hourStr = [timeStr substringWithRange:NSMakeRange(dayRange.location+dayRange.length, hourRange.location-(dayRange.location+dayRange.length))];
        self.ycHour = hourStr;
        return hourStr;
    }
}

- (void)setYcMinute:(NSString *)minute {
    objc_setAssociatedObject(self, &minuteKey, minute, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ycMinute {
    NSString *value = objc_getAssociatedObject(self, &minuteKey);
    if (value && value.length > 0) {
        return value;
    }else{
        NSString *timeStr = [NSDate getDataTimeStr:self];
        NSRange hourRange = [timeStr rangeOfString:@"时"];
        NSRange minuteRange = [timeStr rangeOfString:@"分"];
        NSString *minuteStr = [timeStr substringWithRange:NSMakeRange(hourRange.location+hourRange.length, minuteRange.location-(hourRange.location+hourRange.length))];
        self.ycMinute = minuteStr;
        return minuteStr;
    }
}
- (void)setYcSecond:(NSString *)second {
    objc_setAssociatedObject(self, &secondKey, second, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ycSecond {
    NSString *value = objc_getAssociatedObject(self, &secondKey);
    if (value && value.length > 0) {
        return value;
    }else{
        NSString *timeStr = [NSDate getDataTimeStr:self];
        NSRange minuteRange = [timeStr rangeOfString:@"分"];
        NSRange secondRange = [timeStr rangeOfString:@"秒"];
        NSString *secondStr = [timeStr substringWithRange:NSMakeRange(minuteRange.location+minuteRange.length, secondRange.location-(minuteRange.location+minuteRange.length))];
        self.ycSecond = secondStr;
        return secondStr;
    }
}


+ (NSDate *)toLocalDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSString *)getLocaleTimeStr:(NSString *)str {
    NSDate *inputDate = [self changeToDate:str];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日 hh:mm:ss"];
    NSString *timeStr = [outputFormatter stringFromDate:inputDate];
    //    CRMLog(@"timeStr = %@", timeStr);
    return timeStr;
}

+ (NSDate *)changeToDate:(NSString *)str {
    if (!str || str.length == 0) {
        return nil;
    }
    NSString *oldStr = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    oldStr = [oldStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    oldStr = [oldStr stringByReplacingOccurrencesOfString:@"T" withString:@""];
    oldStr = [oldStr stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *inputDate = [inputFormatter dateFromString:oldStr];
    //    CRMLog(@"inputDate = %@", inputDate);
    return inputDate;
}

/** yyyy-MM-dd'T'HH:mm:ss.SSS zz:z 2016-01-20T17:24:08.000+08:00 */
+ (NSDate *)dateWithString:(NSString *)str {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS zz:z"];
    NSDate *date = [CommonTools dateFromInDate:[str stringByReplacingOccurrencesOfString:@"+" withString:@" "]];
    // 先将"+"替换成@" "
//    NSDate *date = [dateFormatter dateFromString:[str stringByReplacingOccurrencesOfString:@"+" withString:@" "]];
    return date;
}

/** yyyy-MM-dd'T'HH:mm:ss          2016-01-20T17:24:08 */
/** yyyy-MM-dd'T'HH:mm:ss.SSS      2016-01-20T17:24:08.000 */
/** yyyy-MM-dd'T'HH:mm:ss.SSS zz:z 2016-01-20T17:24:08.000+08:00*/
/** yyyy-MM-dd   HH:mm:ss          2017-12-09 00:00:00*/
+ (NSDate *)dateFormatterString:(NSString *)str {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateStr = str;
    if ([str rangeOfString:@"+"].location != NSNotFound) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS zz:z"];
        // 先将"+"替换成@" "
        dateStr = [dateStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    else if ([str rangeOfString:@"."].location != NSNotFound) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        
    }
    //不包含 T
    else if ([str rangeOfString:@"T"].location == NSNotFound) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    if (!date) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        date = [dateFormatter dateFromString:dateStr];
    }
    return date;
}

+ (NSString *)getDataTimeStr:(NSDate *)date {
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];//时差转换
    [formate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formate setDateFormat:@"yyyy年MM月dd日HH时mm分ss秒"];
    NSString *dateStr;
    dateStr = [formate stringFromDate:date];
    return dateStr;
}

+ (NSString *)getYYYYMMDDStr:(NSDate *)date {
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];//时差转换
    [formate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formate setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr;
    dateStr = [formate stringFromDate:date];
    return dateStr;
}

+ (NSString *)dateToStr:(NSDate *)date formatStr:(NSString *)formatStr {
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];//时差转换
    [formate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formate setDateFormat:formatStr];
    NSString *str;
    str = [formate stringFromDate:date];
    return str;
}

+ (NSDate *)strToDate:(NSString *)str formatStr:(NSString *)formatStr {
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];//时差转换
    [formate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formate setDateFormat:formatStr];
    NSDate *date;
    date = [formate dateFromString:str];
    return date;
}

+ (NSDate *)extractDateYMD:(NSDate *)date {
    //get seconds since 1970
    NSTimeInterval interval = [date timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    
    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}
@end
