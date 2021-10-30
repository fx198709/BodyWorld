//
//  OurNormalTitlePickerView.h
//  Ework
//
//  Created by feixiang on 2017/11/9.
//  Copyright © 2017年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NormalTitlePickerModel.h"
#import "BaseOurPickerView.h"
//普通的pickerView 加到window上的
@interface OurNormalTitlePickerView : BaseOurPickerView<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    
}

@property (nonatomic, strong)NSArray *currnetArray; //当前的数据源
@property (nonatomic, assign)int selectIndex;  //当前的选中项
@property (nonatomic, strong)NormalTitlePickerModel *currentModel;
@property (nonatomic, strong)UIPickerView *leftPicker;

@property (nonatomic, copy)void(^ConfirmButtonClicked)(NormalTitlePickerModel*);

- (void)changDateWithPickerModel:(NormalTitlePickerModel*)pickermodel;


@end
