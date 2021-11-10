//
//  NSDate+MT.h
//  ARThirdTools
//
//  Created by xiejc on 2019/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (MT)

+ (NSDate *)mt_dateFromString:(NSString *)dateString format:(NSString *)format;

+ (uint64_t)mt_timeStampForMillisecond;

- (uint64_t)mt_timeStampForMillisecond;

- (NSString *)mt_formatString:(NSString *)dateFormat;

- (BOOL)mt_isSameDay:(NSDate *)date;

#pragma mark - 日期

/**
 
 获取所在月份的第一天
 
 @return 第一天
 */
- (NSDate *)mt_firstDayOfMonth;


/**
 获取所在月份的最后一天
 
 @return 最后一天
 */
- (NSDate *)mt_endDayOfMonth;


/**
 获取当前月份的第一天和最后一天
 
 @return @【第一天，最后一天】
 */
- (NSArray *)mt_getMonthFirstAndLastDay;

/**
 前一天
 
 @return 前一天
 */
- (NSDate *)mt_previousDate;

/**
 明天
 
 @return 明天
 */
- (NSDate *)mt_nextDate;

/**
 获取上个月日期
 
 @return 上个月
 */
- (NSDate *)mt_previousMonthDate;

/**
 获取下个月日期
 
 @return 下个月
 */
- (NSDate *)mt_nextMonthDate;

/**
 获取所在月份的天数
 
 @return 天数
 */
- (NSInteger)mt_daysInMonth;

/**
 获取当前月第一天是周几
 
 @return 周几
 */
- (NSInteger)mt_firstWeekDayInMonth;

/**
 当前年
 
 @return 年
 */
- (NSInteger)mt_year;

/**
 当前月
 
 @return 月
 */
- (NSInteger)mt_month;

/**
 当前天
 
 @return 天
 */
- (NSInteger)mt_day;


@end

NS_ASSUME_NONNULL_END
