//
//  NormalTitlePickerModel.m
//  Ework
//
//  Created by feixiang on 2017/11/9.
//  Copyright © 2017年 crm. All rights reserved.
//

#import "NormalTitlePickerModel.h"

@implementation NormalTitlePickerModel

- (id)init{
    self = [super init];
    if (self) {
        _currnetArray = [NSMutableArray array];
    }
    return self;
}

- (void)setComponentCount:(int)componentCount{
    _componentCount = componentCount;
    _selectedDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < _componentCount-1; i++) {
        [_selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",i]];
    }
}

@end
