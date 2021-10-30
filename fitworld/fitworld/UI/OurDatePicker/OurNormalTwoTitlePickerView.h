//
//  OurNormalTwoTitlePickerView.h
//  Ework
//
//  Created by feixiang on 2018/1/29.
//  Copyright © 2018年 crm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseScreenModel.h" //这个是选中的model
#import "BaseOurPickerView.h"

@protocol OurNormalTwoTitlePickerViewDelegate <NSObject>

/**
 *  选中的Model
 *
 *  @param selectedValue
 */
- (void)seletedNormalLeftVlaue:(id)leftModel rightVlaue:(id)rightModel;


@end

@interface OurNormalTwoTitlePickerView : BaseOurPickerView<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    UIView *coverView;
}
@property (nonatomic, strong)UIPickerView *leftPicker;
@property (nonatomic, strong)UIPickerView *rightPicker;

@property (nonatomic, strong)NSArray *titleArray;
@property (nonatomic, assign)int leftSelectedIndex;
@property (nonatomic, assign)int rightSelectedIndex;

@property (nonatomic, strong)NSArray *leftArray;
@property (nonatomic, strong)NSMutableArray *realrightArray;//由于有限制，右边的数组

@property (nonatomic, strong)id indate; //传入的值
@property (nonatomic, strong)id rightIndate;//右边的传入date

@property (nonatomic, weak)id<OurNormalTwoTitlePickerViewDelegate> pickerDelegate;

- (void)pickerViewWithView:(UIView*)view;

@end
