//
//  NormalTitlePickerModel.h
//  Ework
//
//  Created by feixiang on 2017/11/9.
//  Copyright © 2017年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseScreenModel.h"

@interface NormalTitlePickerModel : NSObject

@property (nonatomic, strong)NSString* viewTitle;  //这个view的title
@property (nonatomic, strong)NSMutableArray<BaseScreenModel*> *currnetArray; //当前的数据源
@property (nonatomic, assign)int selectIndex;  //当前的选中项
@property (nonatomic, strong)NSString* pickerTitle;  //当前的选中项

@property (nonatomic, strong)NSMutableDictionary *selectedDic; //多选的时候，这边用 key为commponent
@property (nonatomic, assign)int componentCount; //多选的时候，这边用

@end
