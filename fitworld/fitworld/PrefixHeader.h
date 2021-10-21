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

#define WeakSelf  __weak typeof(self)wSelf = self;
#define StrongSelf(inself)  __strong typeof(self)strongSelf = inself;

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

UIKIT_STATIC_INLINE  int  RemoveSubviews(UIView* superview, NSArray * classArray){
    
    for (UIView *view in superview.subviews) {
        if (classArray && classArray.count > 0) {
            BOOL hasclass = NO;
            for (NSString *classString in classArray) {
                Class outclass = NSClassFromString(classString);
                if ([view isKindOfClass:[outclass class]]) {
                    hasclass = YES;
                }
            }
            if (!hasclass) {
                [view removeFromSuperview];
            }
        } else{
            [view removeFromSuperview];
        }
        
    }
    return 0;
}

#define ChineseOrEN(obj, key)   ({\
if(ISChinese()){\
NSString *keyString = [NSString stringWithFormat:@"%@_cn",key];\
return [obj objectForKey:keyString];\
}else{\
return [obj objectForKey:key];\
})


#define SystemFontOfSize(size)  [UIFont systemFontOfSize:size]
//等宽字体
#define EqualFontWithSize(asize) [UIFont fontWithName:@"HelveticaNeue" size:asize]


#define NumberToString(number)  [NSString stringWithFormat:@"%@",number]
#define UIRGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


