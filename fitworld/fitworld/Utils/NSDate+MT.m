//
//  NSDate+MT.m
//  ARThirdTools
//
//  Created by xiejc on 2019/4/1.
//

#import "NSDate+MT.h"

@implementation NSDate (MT)

+ (uint64_t)mt_timeStampForMillisecond {
    return [[self date] mt_timeStampForMillisecond];
}

- (uint64_t)mt_timeStampForMillisecond{
    uint64_t timeStamp = (uint64_t)(self.timeIntervalSince1970 * 1000);
    return timeStamp;
}

- (NSString *)mt_formatString:(NSString *)dateFormat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter stringFromDate:self];
}

+ (NSDate *)mt_dateFromString:(NSString *)dateString format:(NSString *)format {
    if(!dateString || dateString.length == 0){
        return nil;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

- (BOOL)mt_isSameDay:(NSDate *)date {
    return self.mt_year == date.mt_year && self.mt_month == date.mt_month && self.mt_day == date.mt_day;
}

#pragma mark - 日期


/**
 获取所在月份的第一天
 
 @return 第一天
 */
- (NSDate *)mt_firstDayOfMonth {
    NSArray *days = [self mt_getMonthFirstAndLastDay];
    if (days) {
        return days.firstObject;
    }
    return nil;
}


/**
 获取所在月份的最后一天
 
 @return 最后一天
 */
- (NSDate *)mt_endDayOfMonth {
    NSArray *days = [self mt_getMonthFirstAndLastDay];
    if (days) {
        return days.lastObject;
    }
    return nil;
}


/**
 获取当前月份的第一天和最后一天
 
 @return @【第一天，最后一天】
 */
- (NSArray *)mt_getMonthFirstAndLastDay {
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:self];
    if (OK) {
        lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    } else {
        return nil;
    }
    return @[firstDate, lastDate];
}


/**
 前一天
 
 @return 前一天
 */
- (NSDate *)mt_previousDate {
    NSDate *preDate = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:([self timeIntervalSinceReferenceDate] - 24 * 3600)];
    return preDate;
}


/**
 明天
 
 @return 明天
 */
- (NSDate *)mt_nextDate {
    NSDate *nextDate = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:([self timeIntervalSinceReferenceDate] + 24 * 3600)];
    return nextDate;
}


/**
 获取上个月日期
 
 @return 上个月
 */
- (NSDate *)mt_previousMonthDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    components.day = 15;
    if (components.month == 1) {
        components.month = 12;
        components.year -= 1;
    } else {
        components.month -= 1;
    }
    
    NSDate *result = [calendar dateFromComponents:components];
    return result;
}

/**
 获取下个月日期
 
 @return 下个月
 */
- (NSDate *)mt_nextMonthDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    
    if (components.month == 12) {
        components.month = 1;
        components.year += 1;
    } else {
        components.month += 1;
    }
    
    NSDate *result = [calendar dateFromComponents:components];
    return result;
}


/**
 获取所在月份的天数
 
 @return 天数
 */
- (NSInteger)mt_daysInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}


/**
 获取当前月第一天是周几
 
 @return 周几
 */
- (NSInteger)mt_firstWeekDayInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    
    components.day = 1;
    NSDate *firstDay = [calendar dateFromComponents:components];
    if (firstDay == nil) {
        return 1;
    }
    NSInteger num = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDay];
    NSInteger result = num - 1;
    return result;
}


/**
 当前年
 
 @return 年
 */
- (NSInteger)mt_year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    NSInteger result = components.year;
    return result;
}

/**
 当前月
 
 @return 月
 */
- (NSInteger)mt_month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    NSInteger result = components.month;
    return result;
}

/**
 当前天
 
 @return 天
 */
- (NSInteger)mt_day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    NSInteger result = components.day;
    return result;
}

@end
