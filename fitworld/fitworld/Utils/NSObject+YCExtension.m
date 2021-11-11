//
//  NSObject+YCExtension.m
//  Ework
//
//  Created by ChiJinLian on 2017/12/26.
//  Copyright © 2017年 crm. All rights reserved.
//

#import "NSObject+YCExtension.h"

@implementation NSObject (YCExtension)

+ (void)swizzleOriginalSEL:(SEL)originalSEL withSwizzlingSEL:(SEL)swizzlingSEL targetClass:(id)targetClass {
    
    Method originalMethod = class_getInstanceMethod(targetClass, originalSEL);
    Method swizzlingMethod = class_getInstanceMethod(targetClass, swizzlingSEL);
    
    /*
     * 先判断，为了防止所替换子类的实例方法是从父类继承，而且并没在子类中重写该方法。
       直接调用 method_exchangeImplementations那么 会直接替换父类中的方法实现，
       导致继承于此父类的所有子类对应的实例方法都被重写
     */
    BOOL isAddMethod = class_addMethod(targetClass, originalSEL,
                                       method_getImplementation(swizzlingMethod),
                                       method_getTypeEncoding(swizzlingMethod));
    if (isAddMethod) {
        class_replaceMethod(targetClass, swizzlingSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzlingMethod);
    }
}

@end
