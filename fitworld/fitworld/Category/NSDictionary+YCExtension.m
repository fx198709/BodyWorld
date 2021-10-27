//
//  NSDictionary+YCExtension.m
//  Ework
//
//  Created by ChiJinLian on 16/11/22.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "NSDictionary+YCExtension.h"

@implementation NSDictionary (YCExtension)
- (NSString *)strValueWithKey:(NSString *)key {
    NSString *value = @"";
    id IDValue = ValueFromDic(self,key,@"");
    if ([IDValue isKindOfClass:[NSString class]]) {
        value = IDValue;
    }else if ([IDValue isKindOfClass:[NSNumber class]]) {
        value = [NSString stringWithFormat:@"%@",IDValue];
    }
    return value;
}

@end
