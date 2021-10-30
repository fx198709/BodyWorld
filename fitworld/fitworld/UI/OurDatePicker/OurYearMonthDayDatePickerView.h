//
//  OurYearMonthDayDatePickerView.h
//  Ework
//
//  Created by Yiche on 2019/10/22.
//  Copyright © 2019 crm. All rights reserved.
//

#import "BaseOurPickerView.h"

typedef NS_ENUM(NSInteger, DateModeType){
    DateModeTypeYearMonthDay,
    DateModeTypeDate,
};
@class OurYearMonthDayDatePickerView;
@protocol OurYearMonthDayDatePickerViewDelegate <NSObject>
@optional

/**
 *  这个返回的是一个时间
 *
 *  @param selectedDate <#selectedDate description#>
 */
- (void)seletedDate:(NSDate *)selectedDate andview:(OurYearMonthDayDatePickerView *)pickerView;


/**
 *  这个是选中了2个时间 中间用~隔开的
 *
 *  @param selectedDate <#selectedDate description#>
 */
- (void)seletedTwoHourAndMinuteDate:(NSString*)startTime emdTime:(NSString *)endTime;


- (void)dateViewCancelButtonClicked;

@end
@interface OurYearMonthDayDatePickerView : BaseOurPickerView
@property(nonatomic,strong)UIDatePicker *datePicker;//弹出时间选择器视图 选择日期的
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, assign) DateModeType dateMode;
@property (nonatomic, weak)id<OurYearMonthDayDatePickerViewDelegate> pickerDelegate;
- (void)pickerViewWithView:(UIView *)view;
@end

