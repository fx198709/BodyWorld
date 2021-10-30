//
//  OurNormalPickerView.h
//  Ework
//
//  Created by feixiang on 2016/12/2.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "BaseServer.h"
#import "BaseOurPickerView.h"

typedef enum
{
    OnePicker = 0,
}NormalPickerType;


@protocol OurNormalPickerViewDelegate <NSObject>

/**
 *  选中的时间
 *
 *  @param selectedDate <#selectedDate description#>
 */
- (void)seletedNormalTwoHourAndMinuteDate:(NSString*)selectedDate;


@end
/**
 * 普通的pickerview
 */

@interface OurNormalPickerView : BaseOurPickerView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, assign)NormalPickerType pickertype;
@property (nonatomic, strong)UIPickerView *leftPicker;
@property (nonatomic, strong)UIPickerView *rightPicker;

@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, assign)int leftSelectedIndex;
@property (nonatomic, assign)int rightSelectedIndex;

@property (nonatomic, strong)NSArray *leftArray;
@property (nonatomic, strong)NSArray *rightArray;
@property (nonatomic, strong)NSMutableArray *realrightArray;//由于有限制，右边的数组

@property (nonatomic, strong)id indate; //传入的值
@property (nonatomic, strong)id rightIndate;//右边的传入date

@property (nonatomic, weak)id<OurNormalPickerViewDelegate> pickerDelegate;

- (void)pickerViewWithView:(UIView*)view;


@end
