//
//  FontColorHeader.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/30.
//

#ifndef FontColorHeader_h
#define FontColorHeader_h


//字体
#define SystemFontOfSize(size)  [UIFont systemFontOfSize:size]
//等宽字体
#define EqualFontWithSize(asize) [UIFont fontWithName:@"HelveticaNeue" size:asize]


#define NumberToString(number)  [NSString stringWithFormat:@"%@",number]
#define UIRGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])


//颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 随机颜色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]
#define Color(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define ColorAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


//常用颜色
//深灰色背景色 #252525
#define BgGrayColor UIRGBColor(37, 37, 37, 1)
//绿色文字或背景
#define SelectGreenColor  UIRGBColor(86, 186, 111, 1)
//浅色字色#C6C6C6
#define LightGaryTextColor  UIRGBColor(198, 198, 198, 1)
#define LineColor  UIRGBColor(138, 138, 138, 0.5)

#define WeakSelf  __weak typeof(self)wSelf = self;
#define StrongSelf(inself)  __strong typeof(self)strongSelf = inself;

#endif /* FontColorHeader_h */
