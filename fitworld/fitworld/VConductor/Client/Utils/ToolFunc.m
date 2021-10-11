#import "ToolFunc.h"

#include <DeviceCheck/DeviceCheck.h>
#import <mach/mach.h>

#define RTCLogError NSLog

@implementation ToolFunc

+ (BOOL)isMainThread; {
  if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(dispatch_get_main_queue())) == 0) {
    return YES;
  }
  return NO;
}

+ (uint64_t)parseUint64String:(NSString *)str {
  NSScanner *scanner = [NSScanner scannerWithString:str];
  unsigned long long convertedValue = 0;
  [scanner scanUnsignedLongLong:&convertedValue];
  return convertedValue;
}

+ (NSString *)jsonMessage:(NSDictionary *)dict {
  NSData *message = [NSJSONSerialization dataWithJSONObject:dict
                                                    options:NSJSONWritingPrettyPrinted
                                                      error:nil];
  NSString *messageString = [[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding];
  return messageString;
}

+ (NSDictionary *)dictionaryMessage:(NSString *)str {
  NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
  NSError *err;
  NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableContainers
                                                        error:&err];
  return dic;
}

+ (NSDictionary *)dictionaryWithJSONData:(NSData *)jsonData {
  NSError *error = nil;
  NSDictionary *dict =
      [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
  if (error) {
    RTCLogError(@"Error parsing JSON: %@", error.localizedDescription);
  }
  return dict;
}

+ (UIView*)newView {
  UIView *v = [UIView new];
  return v;
}

+ (UIButton*)newButton:(NSString*)title {
  UIButton *bt = [UIButton new];
  
  [bt setTitle:title forState:UIControlStateNormal];
  bt.titleLabel.font = [UIFont boldSystemFontOfSize:12];
  [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  return bt;
}

+ (UITextField*)newTextFiled:(NSString*)title
{
  UITextField* tf = [[UITextField alloc] initWithFrame:CGRectZero ];
  tf.textColor = [UIColor darkGrayColor];
  tf.backgroundColor = [UIColor whiteColor];
  tf.tintColor = [UIColor redColor];
  tf.borderStyle = UITextBorderStyleRoundedRect;
  tf.text = title;
  return tf;
}

+ (UILabel*)newLabel:(NSString*)title
{
  UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectZero ];
  lbl.textColor = [UIColor greenColor];
  lbl.backgroundColor = [UIColor clearColor];
  lbl.tintColor = [UIColor redColor];
  lbl.textAlignment = NSTextAlignmentRight;
  [lbl setText:title];
  return lbl;
}

+ (NSString *)randomStringWithLength:(NSInteger)len {
  NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
  for (NSInteger i = 0; i < len; i++) {
    [randomString appendFormat: @"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
  }
  return randomString;
}

+ (NSString *)randomStringWithLength:(NSInteger)len fromString:(NSString *)letters {
  NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
  for (NSInteger i = 0; i < len; i++) {
    [randomString appendFormat: @"%C", [letters characterAtIndex:arc4random_uniform([letters length])]];
  }
  return randomString;
}

+ (NSString*)getAppVersionName {
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  // app名称
  NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
  // app版本
  NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
  // app build版本
  NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
  
  NSString *versionName = [NSString stringWithFormat:@"%@ v%@.%@", app_Name, app_Version, app_build];
  return versionName;
}

+ (NSDictionary*)getAllVersionInfo {
  NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
  // CFShow(infoDictionary);
  
  //手机序列号
  [[DCDevice currentDevice] generateTokenWithCompletionHandler:^(NSData * _Nullable token, NSError * _Nullable error) {
    NSLog(@"token = %@", token);
  }];
  
  //手机别名： 用户定义的名称
  NSString* userPhoneName = [[UIDevice currentDevice] name];
  NSLog(@"手机别名: %@", userPhoneName);
  //设备名称
  NSString* deviceName = [[UIDevice currentDevice] systemName];
  NSLog(@"设备名称: %@",deviceName );
  //手机系统版本
  NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
  NSLog(@"手机系统版本: %@", phoneVersion);
  //手机型号
  NSString* phoneModel = [[UIDevice currentDevice] model];
  NSLog(@"手机型号: %@",phoneModel );
  //地方型号  （国际化区域名称）
  NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
  NSLog(@"国际化区域名称: %@",localPhoneModel );
  
  // 当前应用名称
  NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
  NSLog(@"当前应用名称：%@",appCurName);
  // 当前应用软件版本  比如：1.0.1
  NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
  NSLog(@"当前应用软件版本:%@",appCurVersion);
  // 当前应用版本号码   int类型
  NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
  NSLog(@"当前应用版本号码：%@",appCurVersionNum);
  
  return infoDictionary;
}

+ (void)alertWithHostVC:(UIViewController*)vc Title:(NSString *)title message:(NSString *)message ButtonArray:(NSArray *)array LastAlertAction:(void(^)(NSInteger index))block {
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
  
  NSInteger alertActionNumber = array.count;
  for (uint32_t i = 0; i < alertActionNumber; i++)
  {
    if (i == array.count - 1)
    {
      UIAlertAction *alertAction = [UIAlertAction actionWithTitle:array[i] style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        if (block)
        {
          block(i);
        }
      }];
      [alertController addAction:alertAction];
    }else
    {
      UIAlertAction *alertAction = [UIAlertAction actionWithTitle:array[i] style:(UIAlertActionStyleDefault) handler:nil];
      [alertController addAction:alertAction];
    }
  }
  [vc presentViewController:alertController animated:YES completion:nil];
}
@end

NSInteger ARDGetCpuUsagePercentage() {
  // Create an array of thread ports for the current task.
  const task_t task = mach_task_self();
  thread_act_array_t thread_array;
  mach_msg_type_number_t thread_count;
  if (task_threads(task, &thread_array, &thread_count) != KERN_SUCCESS) {
    return -1;
  }

  // Sum cpu usage from all threads.
  float cpu_usage_percentage = 0;
  thread_basic_info_data_t thread_info_data = {};
  mach_msg_type_number_t thread_info_count;
  for (size_t i = 0; i < thread_count; ++i) {
    thread_info_count = THREAD_BASIC_INFO_COUNT;
    kern_return_t ret = thread_info(thread_array[i],
                                    THREAD_BASIC_INFO,
                                    (thread_info_t)&thread_info_data,
                                    &thread_info_count);
    if (ret == KERN_SUCCESS) {
      cpu_usage_percentage +=
          100.f * (float)thread_info_data.cpu_usage / TH_USAGE_SCALE;
    }
  }

  // Dealloc the created array.
  vm_deallocate(task, (vm_address_t)thread_array,
                sizeof(thread_act_t) * thread_count);
  return lroundf(cpu_usage_percentage);
}

