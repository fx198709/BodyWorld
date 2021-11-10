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

@end

NS_ASSUME_NONNULL_END
