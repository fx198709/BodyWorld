//
//  BaseJSONModel.m
//  ZhongCaiHuaXiaCRM_iOS
//
//  Created by xiejc on 2019/1/29.
//  Copyright © 2019 xiejc. All rights reserved.
//

#import "BaseJSONModel.h"

@implementation BaseJSONModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}



- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {
        [self dealData];
    }
    return self;
}

- (void)dealData {
    
}

@end
