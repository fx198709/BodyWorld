//
//  NSArray+YCCategory.m
//  Ework
//
//  Created by ChiJinLian on 2017/7/26.
//  Copyright © 2017年 crm. All rights reserved.
//

#import "NSArray+YCCategory.h"

@implementation NSArray (YCCategory)
+ (NSArray *)addArray:(NSArray *)nextList
     toArrayAndRemove:(NSArray *)toArray
              isEqual:(BOOL(^)(id firstItem, id seconeItem))isEqual
{
    if (0 == nextList.count) {
        return nil;
    }
    else {
        // 去掉重复的数据
        NSMutableArray *nextMutableList = [NSMutableArray arrayWithArray:nextList];
        NSMutableIndexSet *repeatIndex = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0, count = nextList.count; i < count; i++) {
            id addObj = [nextList objectAtIndex:i];
            for (id toArrayObj in toArray) {
                if (isEqual(addObj, toArrayObj)) {
                    [repeatIndex addIndex:i];
                    break;
                }
            }
        }
        [nextMutableList removeObjectsAtIndexes:repeatIndex];
        return nextMutableList;
    }
    
}

+ (NSMutableArray *)newArray:(NSArray *)newArray
           toArrayAndReplace:(NSArray *)replaceArray
                     isEqual:(BOOL(^)(id firstItem, id seconeItem))isEqual
{
    if (0 == newArray.count) {
        return [NSMutableArray arrayWithArray:replaceArray];
    }
    else {
        //这是重复的数据
        NSMutableArray *replaceList = [NSMutableArray arrayWithCapacity:3];
        
        //获取重复数据的IndexSet
        NSMutableIndexSet *repeatIndex = [NSMutableIndexSet indexSet];
        for (NSInteger i = 0; i < newArray.count; i++) {
            id addObj = [newArray objectAtIndex:i];
            for (id toArrayObj in replaceArray) {
                if (isEqual(addObj, toArrayObj)) {
                    [repeatIndex addIndex:i];
                    [replaceList addObject:addObj];
                    break;
                }
            }
        }
        //这是不重复的数据
        NSMutableArray *newAddList = [NSMutableArray arrayWithArray:newArray];
        [newAddList removeObjectsAtIndexes:repeatIndex];
        
        NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:4];
        for (NSInteger j = 0; j < replaceArray.count; j++) {
            id item = [replaceArray objectAtIndex:j];
            for (id replaceObj in replaceList) {
                if (isEqual(item, replaceObj)) {
                    //替换新数据
                    item = replaceObj;
                    break;
                }
            }
            [resultArray addObject:item];
        }
        
        if (newAddList.count > 0) {
            [resultArray addObjectsFromArray:newAddList];
        }
        
        return resultArray;
    }
    
}

@end
