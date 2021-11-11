//
//  NSString+MT.h
//  ARThirdTools
//
//  Created by xiejc on 2019/1/29.
//

#import <Foundation/Foundation.h>

#define StringWithDefaultValue(str, defaultStr) (str == nil ? defaultStr : str)

#define IntToString(value) [NSString stringWithFormat:@"%ld", (long)value]
#define FloatToString(floatValue) [NSString changeFloatToString:floatValue]


@interface NSString (MT)

/**
 移除字符串头尾空格

 @param string 字符串
 @return 字符串
 */
+ (NSString *)trimString:(NSString *)string;

/**
 验证是否为nil或为空字符串或(null)
 
 @param string 字符串
 @return YES/NO
 */
+ (BOOL)isNullString:(NSString *)string;

/**
 验证是否为nil或空字符串类型或@""
 
 @param string 字符串
 @return YES/NO
 */
+ (BOOL)isRealNilStr:(NSString *)string;

/**
 验证是否为纯数字字符串
 
 @param string 字符串
 @return YES/NO
 */
+ (BOOL)isNumberString:(NSString *)string;

/**
 验证是否为字母数字下划线混合
 
 @param string 字符串
 @return YES/NO
 */
+ (BOOL)isMixedWordString:(NSString *)string;

/**
 验证是否为纯中文
 
 @param string 字符串
 @return YES/NO
 */
+ (BOOL)isChineseWordString:(NSString *)string;


/**
 验证是否为手机号码

 @param string 字符串
 @return YES/NO
 */
+ (BOOL)isPhoneNumber:(NSString *)string;


/**
 验证是否为邮箱

 @param string 字符串
 @return YES/NO
 */
+ (BOOL)isEmailString:(NSString *)string;


/**
 验证是否为身份证号码

 @param IDNumber 号码
 @return YES/NO
 */
+ (BOOL)isIDNumber:(NSString *)IDNumber;


#pragma mark - formatter

/**
 *  保留小数点后几位
 *
 *  @param value         浮点型数值
 *  @param dotNumber    小数点位数
 *
 *  @return 格式后字符串
 */
+ (NSString *)formateToDotValueString:(float)value dotNumber:(int)dotNumber;

/**
 *  格式化Money ex:10000 -> 1,000
 */
+ (NSString *)formateToNumberString:(int)number;


/**
 删除小数点后面多余的0
 
 @param floatValue 小数
 @return 整除小数
 */
+ (NSString *)changeFloatToString:(CGFloat)floatValue;


/**
 *  将数字字符串转换成金钱格式，例如"12300" -> "12,300"
 *
 *  @param numString 数字字符串
 *
 *  @return 格式化好的字符串
 */

+ (NSString *)formateToMoneyString:(NSString *)numString;


/**
 *  保密格式手机号码 ex: 13010236377 -> 130****6377
 *
 *  @param phone 手机号
 *
 *  @return 保密格式的号码
 */
+ (NSString *)formateToSecretPhone:(NSString *)phone;


/**
 *  生成数字随机密码
 *
 *  @param pwdLength 密码长度
 *
 *  @return 随机密码
 */
+ (NSString *)generateNumberPassword:(int)pwdLength;


/**
 *  正则表达式获取字符串中的匹配字符串
 *
 *  @param expression 正则表达式
 *
 *  @return 匹配字符串
 */
- (NSString *)matchRegularExpression:(NSString *)expression;

@end

