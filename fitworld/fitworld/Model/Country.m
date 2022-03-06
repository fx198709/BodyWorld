//
//  Country.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/12.
//

#import "Country.h"

@implementation Country


- (void)changeOrderString{
    if (ISChinese()) {
//        处理拼音
        if (self.pingying) {
            self.orderString = self.pingying;
        }else{
            self.orderString = [self transform:self.name];
        }
//        排序字段
        self.orderString = [self removeSpaceAndNewline:self.orderString];
        
    }else{
//        处理英文
        self.orderString = [self removeSpaceAndNewline:self.name_en];

    }
//    获取首字母
    self.firstWord = [self.orderString substringToIndex:1];
}

- (NSString *)removeSpaceAndNewline:(NSString *)str{
   
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

- (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
//    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}

@end
