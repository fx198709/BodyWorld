//
//  PrefixHeader.h
//  日历
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 HEJJY. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h

#import "UIView+Extension.h"
#import "BaseObject.h"
// 屏幕尺寸
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

// 随机颜色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]
#define Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define ColorAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#endif /* PrefixHeader_h */

static inline  int ISChinese(){
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
       NSArray* languagesArray = [defaults objectForKey:@"AppleLanguages"];
       NSString* systemlanguage = [languagesArray objectAtIndex:0];
    if([systemlanguage.lowercaseString containsString:@"zh-"]){
        return YES;
    }
    return NO;
}

UIKIT_STATIC_INLINE  NSString* ChineseOrENFun(BaseObject* obj, NSString* key){
    if(ISChinese()){
        NSString *keyString = [NSString stringWithFormat:@"%@_cn",key];
        return [obj valueForKey:keyString];
    }else{
        return [obj valueForKey:key];;//[obj objectForKey:key];
    }
}

#define ChineseOrEN(obj, key)   ({\
if(ISChinese()){\
NSString *keyString = [NSString stringWithFormat:@"%@_cn",key];\
return [obj objectForKey:keyString];\
}else{\
return [obj objectForKey:key];\
})




