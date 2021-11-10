//
//  NSString+MT.m
//  ARThirdTools
//
//  Created by xiejc on 2019/1/29.
//

#import "NSString+MT.h"

//电话号码
#define RegularExpressionPhoneStr @"1[0-9]{10}"
//密码
#define RegularExpressionPwdStr @"[a-z_A-Z_0-9]{6}"

#define NUMBERSPERIOD @"0123456789"


@implementation NSString (MT)

+ (NSString *)trimString:(NSString *)string {
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)isRealNilStr:(NSString *)string {
    return string == nil || ![string isKindOfClass:[NSString class]] || [string isEqualToString:@""];
}

+ (BOOL)isNullString:(NSString *)string {
    return [self isRealNilStr:string] || [[string lowercaseString] isEqualToString:@"(null)"];
}

+ (BOOL)isPhoneNumber:(NSString *)string {
    if ([NSString isNullString:string]) {
        return NO;
    }
    NSString *regex = @"^(1[2-9])[0-9]{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:string];
}

+ (BOOL)isNumberString:(NSString *)string {
    if ([NSString isRealNilStr:string]) {
        return NO;
    }
    NSString *Regex = @"^\\d*$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
    return [pre evaluateWithObject:string];
}

+ (BOOL)isEmailString:(NSString *)string {
    if ([NSString isRealNilStr:string]) {
        return NO;
    }
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [pre evaluateWithObject:string];
}

+ (BOOL)isChineseWordString:(NSString *)string {
    if ([NSString isRealNilStr:string]) {
        return NO;
    }

    NSString *phoneRegex = @"[\u4e00-\u9fa5]+$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL result = [phoneTest evaluateWithObject:string];
    return result;
}

+ (BOOL)isMixedWordString:(NSString *)string {
    if ([NSString isRealNilStr:string]) {
        return NO;
    }

    NSString *phoneRegex = @"[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    BOOL result = [phoneTest evaluateWithObject:string];
    return result;
}

+ (BOOL)isIDNumber:(NSString *)IDNumber {
    if (IDNumber.length < 18) {
        return NO;
    }

    NSMutableArray *IDArray = [NSMutableArray array];
    // 遍历身份证字符串,存入数组中
    for (int i = 0; i < 18; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    // 系数数组
    NSArray *coefficientArray = [NSArray arrayWithObjects:@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2", nil];
    // 余数数组
    NSArray *remainderArray = [NSArray arrayWithObjects:@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2", nil];
    // 每一位身份证号码和对应系数相乘之后相加所得的和
    int sum = 0;
    for (int i = 0; i < 17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    // 这个和除以11的余数对应的数
    NSString *str = remainderArray[(sum % 11)];
    // 身份证号码最后一位
    NSString *string = [IDNumber substringFromIndex:17];
    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
    if ([str isEqualToString:string]) {
        
        NSString *birthdayYer = [IDNumber substringWithRange:NSMakeRange(6, 4)];
        NSString *birthdayMan = [IDNumber substringWithRange:NSMakeRange(10, 2)];
        NSString *birthdayDay = [IDNumber substringWithRange:NSMakeRange(12, 2)];
        if ([birthdayYer intValue]<1900||[birthdayMan intValue]==0||[birthdayMan intValue]>12||[birthdayDay intValue]==1||[birthdayDay intValue]>31) {
            return NO;
        }
        
        
        return YES;
        
    } else {
        return NO;
    }
}

#pragma mark - formatter

+ (NSString *)formateToDotValueString:(float)value dotNumber:(int)dotNumber {
    NSString *formatStr = @"%0.";
    formatStr = [formatStr stringByAppendingFormat:@"%df", dotNumber];
    formatStr = [NSString stringWithFormat:formatStr, value];
    NSLog(@"formatStr %@", formatStr);
    return formatStr;
}


+ (NSString *)formateToMoneyString:(NSString *)numString {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    id result;
    if ([numberFormatter numberFromString:numString])
    {
        result=[NSNumber numberWithInteger:[numString integerValue]];
    } else {
        result=numString ;
    }
    
    return [numberFormatter stringFromNumber:result];
}

/**
 删除小数点后面多余的0
 
 @param floatValue 小数
 @return 整除小数
 */
+ (NSString *)changeFloatToString:(CGFloat)floatValue {
    NSString *stringFloat = [NSString stringWithFormat:@"%f", (double)floatValue];
    NSInteger length = [stringFloat length];
    if ([stringFloat containsString:@"."]) {
        for(NSInteger i = length - 1; i >= 0; i--) {
            NSString *subString = [stringFloat substringFromIndex:i];
            if(![subString isEqualToString:@"0"]) {
                if ([subString isEqualToString:@"."]) {
                    return [stringFloat substringToIndex:[stringFloat length] - 1];
                } else {
                    return stringFloat;
                }
            } else {
                stringFloat = [stringFloat substringToIndex:i];
            }
        }
    }
    return 0;
}

+ (NSString *)formateToNumberString:(int)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *numStr = [numberFormatter stringFromNumber:[NSNumber numberWithInt:number]];
    return numStr;
}


+ (NSString *)formateToSecretPhone:(NSString *)phone {
    phone = [NSString trimString:phone];
    if (phone.length < 7) {
        return phone;
    }
    
    NSRange secretRange = NSMakeRange(3, MAX(1, phone.length - 7));
    NSString *replaceStr = @"";
    for (int i = 0; i < secretRange.length; i++) {
        replaceStr = [replaceStr stringByAppendingString:@"*"];
    }
    return [phone stringByReplacingCharactersInRange:secretRange withString:replaceStr];
}

+ (NSString *)generateNumberPassword:(int)pwdLength {
    NSString *pwd = @"";
    for (int i = 0; i < pwdLength; i++) {
        pwd = [pwd stringByAppendingString:[NSString stringWithFormat:@"%d", ((arc4random() % 10))]];
    }
    return pwd;
}



- (NSString *)matchRegularExpression:(NSString *)expression {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:0 error:&error];
    
    if (error) {
        NSLog(@"matchRegularExpression error %@",error);
        return @"";
    }
    
    NSTextCheckingResult *firstMatch = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
    if (firstMatch) {
        NSRange resultRange = [firstMatch rangeAtIndex:0];
        //从urlString中截取数据
        return [self substringWithRange:resultRange];
    } else {
        return @"";
    }
}


@end
