//
//  MeetingRoomDatePickerView.h
//  Ework
//
//  Created by Yiche on 2019/9/18.
//  Copyright © 2019 crm. All rights reserved.
//

#import "BaseNewPickerView.h"

@class MeetingRoomDatePickerView;


@protocol MeetingRoomDatePickerViewDelegate <NSObject>
@optional

/**
 *  这个返回的是一个时间
 *
 *  @param selectedDate <#selectedDate description#>
 */
- (void)seletedDate:(NSDate*)selectedDate andview:(MeetingRoomDatePickerView *)pickerView;


/**
 *  这个是选中了2个时间 中间用~隔开的
 *
 *  @param selectedDate <#selectedDate description#>
 */
- (void)seletedTwoHourAndMinuteDate:(NSString*)startTime emdTime:(NSString *)endTime;


- (void)dateViewCancelButtonClicked;

@end
@interface MeetingRoomDatePickerView : BaseNewPickerView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    int selectedYearID;
}
@property (nonatomic, strong)UIDatePicker *leftPicker;
@property (nonatomic, strong)UIDatePicker *rightPicker;
@property (nonatomic, strong)UIPickerView *yearPicker;


@property (nonatomic, strong)NSDate *leftmaxDate;

@property (nonatomic, assign)int minuteInterval;
@property (nonatomic, strong)id indate; //左边的传入date

@property (nonatomic, strong)id rightIndate;//右边的传入date

@property (nonatomic, strong)id maxdate;
@property (nonatomic, strong)id mindate;
@property (nonatomic, strong)NSArray *yearArray;


@property (nonatomic, weak)id<MeetingRoomDatePickerViewDelegate> pickerDelegate;

- (void)pickerViewWithView:(UIView*)view;
@end

