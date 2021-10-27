//
//  NSMutableDictionary+YCExtension.h
//  Ework
//
//  Created by ChiJinLian on 2017/7/26.
//  Copyright © 2017年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (YCExtension)

/**
 从沙盒读取指定文件，并转化为NSMutableDictionary

 @param storeKey 需要存储的文件名
 @return NSMutableDictionary
 */
- (instancetype)initWithStore:(NSString *)storeKey;

/**
 将NSMutableDictionary存入沙盒，并指定文件名storeKey

 @param stroeKey 存储文件名
 */
- (void)writeToStore:(NSString *)stroeKey;

- (NSString *)filePathStore:(NSString *)storeKey;
@end
