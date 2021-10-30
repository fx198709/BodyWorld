//
//  OurDatePickerView.h
//  Ework
//
//  Created by feixiang on 2016/9/30.
//  Copyright © 2016年 crm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseOurPickerView.h"
@class OurDatePickerView;
typedef enum
{
    YearMonDayAndHourMinute = 0, //年月日时分 需要2个时间选择器配合
    YearMonAndDay = 1,//年月日
    HourAndMinute= 2,//时分  带上午下午的
    MonDayAndHourMinute=3,//月日时分  这个和第一个的差别就是差一个年份
    ModeCountDownTimer = 4,
    TwoHourAndMinute = 5, //两个时间和分的
}DatePickerType;

@protocol OurDatePickerViewDelegate <NSObject>
@optional

/**
 *  这个返回的是一个时间
 *
 *  @param selectedDate <#selectedDate description#>
 */
- (void)seletedDate:(NSDate*)selectedDate andview:(OurDatePickerView*)pickerView;


/**
 *  这个是选中了2个时间 中间用~隔开的
 *
 *  @param selectedDate <#selectedDate description#>
 */
- (void)seletedTwoHourAndMinuteDate:(NSString*)selectedDate;


- (void)dateViewCancelButtonClicked;

@end

@interface OurDatePickerView : BaseOurPickerView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    int selectedYearID;
}

@property (nonatomic, assign)DatePickerType pickerType;
@property (nonatomic, strong)UIDatePicker *leftPicker;
@property (nonatomic, strong)UIDatePicker *rightPicker;
@property (nonatomic, strong)UIPickerView *yearPicker;
@property (nonatomic, strong)NSDate *miniDate;
@property (nonatomic, strong)NSDate *leftmaxDate;

@property (nonatomic, strong)NSString *title;
@property (nonatomic, assign)int minuteInterval;
@property (nonatomic, strong)id indate; //左边的传入date

@property (nonatomic, strong)id rightIndate;//右边的传入date
@property (nonatomic, strong)NSArray *yearArray;


@property (nonatomic, weak)id<OurDatePickerViewDelegate> pickerDelegate;

- (void)pickerViewWithView:(UIView*)view;
@end
