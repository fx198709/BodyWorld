//
//  Enum.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Enum : NSObject

//语言
typedef enum : NSUInteger {
    LanguageEnum_Chinese  = 0,  //中文
    LanguageEnum_English,      //英文
} LanguageEnum;

//性别
typedef enum : NSUInteger {
    GenderEnum_UnKnown  = 0,  //未知
    GenderEnum_Male,      //男
    GenderEnum_Female      //女
} GenderEnum;

@end

NS_ASSUME_NONNULL_END
