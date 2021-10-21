//
//  NSObject+YCExtension.h
//  Ework
//
//  Created by ChiJinLian on 2017/12/26.
//  Copyright © 2017年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YCExtension)

/**
 替换方法的实现

 @param originalSEL  需要替换的方法
 @param swizzlingSEL 新方法
 @param targetClass  目标类
 */
+ (void)swizzleOriginalSEL:(SEL)originalSEL withSwizzlingSEL:(SEL)swizzlingSEL targetClass:(id)targetClass;
@end
