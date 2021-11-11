//
//  NSArray+YCCategory.h
//  Ework
//
//  Created by ChiJinLian on 2017/7/26.
//  Copyright © 2017年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YCCategory)

/**
 获取与toArray中不重复的数据（只会得到去重后的数据，不会替换相同的数据）

 @param nextList 需要判断的NSArray
 @param toArray  与之比较的NSArray
 @param isEqual  比较操作的block
 @return         返回去除了重复数据的NSArray
 */
+ (NSArray *)addArray:(NSArray *)nextList
     toArrayAndRemove:(NSArray *)toArray
              isEqual:(BOOL(^)(id firstItem, id seconeItem))isEqual;


/**
 NSArray数据去重（如果相同，则取newArray中的新数据替换replaceArray中的旧数据），并在后面追加不重复的新增数据

 @param newArray     新数据源
 @param replaceArray 需要替换判断的数据
 @param isEqual      比较操作的block
 @return             返回替换了重复数据，并追加了新增数据的NSArray
 */
+ (NSMutableArray *)newArray:(NSArray *)newArray
           toArrayAndReplace:(NSArray *)replaceArray
                     isEqual:(BOOL(^)(id firstItem, id seconeItem))isEqual;
@end
