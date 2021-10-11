#import <UIKit/UIKit.h>

#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}
#endif

@interface ToolFunc : NSObject

+ (BOOL)isMainThread;

+ (uint64_t)parseUint64String:(NSString *)str;
+ (NSString *)jsonMessage:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryMessage:(NSString *)str;
+ (NSDictionary *)dictionaryWithJSONData:(NSData *)jsonData;

+ (UIView*)newView;
+ (UIButton*)newButton:(NSString*)title;
+ (UITextField*)newTextFiled:(NSString*)title;
+ (UILabel*)newLabel:(NSString*)title;

// 生成指定长度的字符串
+ (NSString *)randomStringWithLength:(NSInteger)len;
// 指定字符串随机生成指定长度的新字符串
+ (NSString *)randomStringWithLength:(NSInteger)len fromString:(NSString *)letters;

+ (NSString*)getAppVersionName;
+ (NSDictionary*)getAllVersionInfo;

+ (void)alertWithHostVC:(UIViewController*)vc Title:(NSString *)title message:(NSString *)message ButtonArray:(NSArray *)array LastAlertAction:(void(^)(NSInteger index))block;

@end
