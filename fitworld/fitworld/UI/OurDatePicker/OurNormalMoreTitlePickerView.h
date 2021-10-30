//
//  OurNormalMoreTitlePickerView.h
//  Ework
//
//  Created by feixiang on 2017/11/9.
//  Copyright © 2017年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NormalTitlePickerModel.h"
#import "BaseOurPickerView.h"
//普通的pickerView 加到window上的
@interface OurNormalMoreTitlePickerView : BaseOurPickerView<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSMutableDictionary *selectedDic;//选中之后的信息
}

@property (nonatomic, strong)NSArray *currnetArray; //当前的数据源
@property (nonatomic, strong)NormalTitlePickerModel *currentModel;
@property (nonatomic, strong)UIPickerView *leftPicker;
@property (nonatomic, strong)UIFont *textFont; //当前的数据源


@property (nonatomic, copy)void(^ConfirmButtonClicked)(NormalTitlePickerModel*);

- (void)changDateWithPickerModel:(NormalTitlePickerModel*)pickermodel;


@end
