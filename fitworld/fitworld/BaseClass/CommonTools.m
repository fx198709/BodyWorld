//
//  CommonTools.m
//  FFitWorld
//
//  Created by feixiang on 2021/10/30.
//

#import "CommonTools.h"

@implementation CommonTools
+ (NSString *)reachDateFromInDate:(id)inDate{
    NSDate *date = [CommonTools dateFromInDate:inDate];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    dateFormate.dateFormat = @"yyyy-MM-dd";
    NSString *returnString = [dateFormate stringFromDate:date];
    return returnString;
}

+ (NSString *)reachDateNOYearFromInDate:(NSString*)inDate
{
    if (inDate.length < 6) {
        return inDate;
    }
    NSDate *date = [CommonTools dateFromInDate:inDate];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    dateFormate.dateFormat = @"MM-dd HH:mm";
    NSString *returnString = [dateFormate stringFromDate:date];
    return returnString;
}

+ (NSDate*)dateFromInDate:(id)inDate
{
    if (!inDate) {
        return [NSDate date];
    }
    
    if ([inDate isKindOfClass:[NSDate class]]) {
        return inDate;
    }
    NSString *inDateString = (NSString *)inDate;
    NSMutableString  *realinDate = [[NSMutableString alloc] initWithString:inDateString];
    [realinDate replaceOccurrencesOfString:@"T" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(1,inDateString.length-1)];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    //    [dateFormate setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];
    //    [dateFormate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    dateFormate.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *date = [dateFormate dateFromString:realinDate];
    if (date == nil) {
        dateFormate.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        date = [dateFormate dateFromString:realinDate];
    }
    
    if (date == nil) {
        dateFormate.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
        date = [dateFormate dateFromString:realinDate];
    }
    
    if (date == nil) {
        dateFormate.dateFormat = @"yyyy-MM-dd";
        date = [dateFormate dateFromString:realinDate];
    }
    
    if (date == nil) {
        dateFormate.dateFormat = @"HH:mm";
        date = [dateFormate dateFromString:realinDate];
    }
    if (date == nil) {
        
        dateFormate.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS zz:z";
        date = [dateFormate dateFromString:realinDate];
    }
    
    if (date == nil) {
        dateFormate.dateFormat = @"yyyyMMdd";
        date = [dateFormate dateFromString:realinDate];
    }
    
    if (realinDate.length > 20 && date == nil) {
        //iOS13 没有识别 yyyy-MM-dd HH:mm:ss.SSS zz:z 这种格式
        NSString * subDateString = [realinDate substringToIndex:19];
        return [CommonTools dateFromDateStr:subDateString];
    }
    return date;
}
+ (NSDate *)dateFromDateStr:(NSString *)dateStr{
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormate setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    dateFormate.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormate dateFromString:dateStr];
    return date;
}




+ (NSString *)reachTimeDateFromString:(id)inDate
{
    NSDate *date = inDate;
    if ([inDate isKindOfClass:[NSString class]]) {
        date = [CommonTools dateFromInDate:inDate];
    }
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    dateFormate.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [dateFormate stringFromDate:date];
    return dateString;
}






+ (NSString *)weekDayStr:(NSInteger)weekDay {
    NSString *str = @"";
    if (weekDay == 1) {
        str = @"周日";
    }
    else if (weekDay == 2) {
        str = @"周一";
    }
    else if (weekDay == 3) {
        str = @"周二";
    }
    else if (weekDay == 4) {
        str = @"周三";
    }
    else if (weekDay == 5) {
        str = @"周四";
    }
    else if (weekDay == 6) {
        str = @"周五";
    }
    else if (weekDay == 7) {
        str = @"周六";
    }
    return str;
}









//
+ (NSString *)reachHourAndMinuteFromInDate:(NSString*)inDateString
{
    NSDate *date = [CommonTools dateFromInDate:inDateString];
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    dateFormate.dateFormat = @"HH:mm";
    NSString *returnString = [dateFormate stringFromDate:date];
    return returnString;
}


+ (NSString*)reachFormateDateStringFromInDate:(id)inDate withFormat:(NSString*)formatString
{
    NSDate *dealDate = inDate;
    if ([inDate isKindOfClass:[NSString class]]) {
        dealDate = [CommonTools dateFromInDate:inDate];
    }
    
    NSDateFormatter *dateFormate = [[NSDateFormatter alloc] init];
    dateFormate.dateFormat = formatString;//@"yyyy.MM.dd";
    //    设置时区
    [dateFormate setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];
    NSString *dateString = [dateFormate stringFromDate:dealDate];
    return dateString;
}

+ (NSString *)reachDateStringFromTimeStamp:(NSString *)timeStamp{
    NSTimeInterval interval = [timeStamp doubleValue] / 1000.0;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}

+ (UIWindow *)mainWindow
{
    if([[[UIApplication sharedApplication] delegate] window]) {
        return[[[UIApplication sharedApplication] delegate] window];
    }else{
        if(@available(iOS 13.0, *)) {
            NSArray *array =[[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene* windowScene = (UIWindowScene*)array[0];
            //如果是普通App开发，可以使用
            //            SceneDelegate * delegate = (SceneDelegate *)windowScene.delegate;
            //            UIWindow * mainWindow = delegate.window;
            
            //由于在sdk开发中，引入不了SceneDelegate的头文件，所以需要用kvc获取宿主app的window.
            UIWindow* mainWindow = [windowScene valueForKeyPath:@"delegate.window"];
            if(mainWindow) {
                return mainWindow;
            }else{
                return[UIApplication sharedApplication].windows.lastObject;
            }
            
        }else{
            return[UIApplication sharedApplication].keyWindow;
        }
    }
}

+ (void)showAlertDismissWithContent:(NSString*)content afterDelay:(NSTimeInterval)delay control:(UIViewController*)control{
    [self showAlertDismissWithContent:content showWaitTime:0.2 afterDelay:delay control:control];
}

+ (void)showAlertDismissWithContent:(NSString*)content showWaitTime:(NSTimeInterval)time afterDelay:(NSTimeInterval)delay control:(UIViewController*)control {
    __strong UIViewController * strongControl = control;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC));
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [strongControl presentViewController:alert animated:YES completion:nil];
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            [CommonTools dismissControl:alert];
        });
    });
}

+ (void)dismissControl:(UIAlertController*)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

+ (NSString*)reachLeftString:(double)diff{
    int hour = (int)diff/3600;
    int hourleft = (long)diff % 3600;
    int min = hourleft/60;
    int sec = hourleft%60;
    NSString *leftString = [NSString stringWithFormat:@"%d:%02d:%02d",hour,min,sec];
    return leftString;
}





@end
