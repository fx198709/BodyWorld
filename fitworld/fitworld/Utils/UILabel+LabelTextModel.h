//
//  UILabel+GeneralTypeModel.h
//  BitAutoCRM
//
//  Created by 费翔 on 15/4/24.
//  Copyright (c) 2015年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelTextModel.h"
@interface UILabel(LabelTextModel)

- (void)changeLabelWithModel:(LabelTextModel*)model;

//text的单行高度
- (CGSize)sizeForLineHeight;

@end

