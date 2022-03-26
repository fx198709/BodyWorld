//
//  CommonFunc.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/30.
//

#ifndef CommonFunc_h
#define CommonFunc_h


// 屏幕尺寸
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define SafeAreaInsets \
({UIEdgeInsets edge;\
if (@available(iOS 11.0, *)) { edge = [UIApplication sharedApplication].delegate.window.safeAreaInsets; } else { edge = UIEdgeInsetsZero; }\
(edge);\
})

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


UIKIT_STATIC_INLINE  NSString*  ReachCutomerWeekTime(NSInteger longtime,NSString * formarter){
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:longtime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //最结尾的Z表示的是时区，零时区表示+0000，东八区表示+0800
//    [formatter setDateFormat:@"MM/dd HH:mm"];
    [formatter setDateFormat:formarter];
   // 使用formatter转换后的date字符串变成了当前时区的时间
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    //ios 8.0 之后 不想看见警告用下面这个
    NSInteger unitFlags = NSCalendarUnitYear |NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday | NSCalendarUnitHour |NSCalendarUnitMinute |NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    if (!ISChinese()) {
        arrWeek=[NSArray arrayWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil];
    }
    NSString *weekString =  [arrWeek objectAtIndex:week-1];
    NSString *timeString = [NSString stringWithFormat:@"%@  %@",weekString,dateStr];
    return timeString;
}

UIKIT_STATIC_INLINE  NSString*  ReachWeekTime(NSInteger longtime){
    
    NSString *timeString = ReachCutomerWeekTime(longtime,@"MM-dd HH:mm");
    return timeString;
}

UIKIT_STATIC_INLINE  NSString*  ReachYearAndWeekTime(NSInteger longtime){
    NSString *timeString = ReachCutomerWeekTime(longtime,@"yyyy-MM-dd HH:mm");
    return timeString;
}

UIKIT_STATIC_INLINE  NSString*  ReachYearANDTime(NSInteger longtime){
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:longtime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //最结尾的Z表示的是时区，零时区表示+0000，东八区表示+0800
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
   // 使用formatter转换后的date字符串变成了当前时区的时间
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}



//中英文对照
UIKIT_STATIC_INLINE  NSString* ChineseStringOrENFun(NSString *chinses, NSString* engString){
    if(ISChinese()){
        return chinses;
    }else{
        return engString;//[obj objectForKey:key];
    }
}

UIKIT_STATIC_INLINE  NSString* SexNameFormGender(long gender){
    NSString *genderString = ChineseStringOrENFun(@"未知", @"unknow");
    if (gender == 1) {
//            男
        genderString = ChineseStringOrENFun(@"男", @"Male");
    }
    if (gender == 2) {
//           女
        genderString = ChineseStringOrENFun(@"女", @"Female");
    }
    return  genderString;
}


//电池条高度
UIKIT_STATIC_INLINE  int statusBarHeight(){
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    return rectStatus.size.height;
}

typedef void(^AnyBtnBlock)(id clickModel);


static inline NSString *_Nonnull NSStringFromDic(NSDictionary *_Nullable info, NSString *_Nullable key, NSString *_Nullable defaultValue) {
    if (![info isKindOfClass:[NSDictionary class]]) {
        return defaultValue;
    }
    NSString *value = @"";
    if (!((defaultValue)==nil || (defaultValue)==NULL || (NSNull *)(defaultValue)==[NSNull null] || (defaultValue).length == 0)) {
        value = defaultValue;
    }
    NSString *valuestring = info[key];
    if ([valuestring isKindOfClass:NSNumber.class]) {
        valuestring = [NSString stringWithFormat:@"%@",valuestring];
        return  valuestring;
    }
    if (!((info[key])==nil || (info[key])==NULL || (NSNull *)(info[key])==[NSNull null] || [(info[key])length] == 0)) {
        value = info[key];
    }
    return value;
}


static inline long  LongValueFromDic(NSDictionary *_Nullable info, NSString * _Nullable key, long defaultValue) {
    if (![info isKindOfClass:[NSDictionary class]]) {
        return defaultValue?defaultValue:0;
    }
    id value;
    if (!((info[key])==nil || (info[key])==NULL || (NSNull *)(info[key])==[NSNull null])) {
        value = info[key];
    }
    NSString *str = @"";
    if ([value isKindOfClass:[NSString class]]) {
        str = value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        
        str = value;

    }
    
    return [str longLongValue];
}

static inline BOOL BOOLValueFromDic(NSDictionary * _Nonnull info, NSString * _Nullable key, BOOL  defaultValue) {
    if (![info isKindOfClass:[NSDictionary class]]) {
        return defaultValue;
    }
    id value;
    if (!((info[key])==nil || (info[key])==NULL || (NSNull *)(info[key])==[NSNull null])) {
        value = info[key];
    }
    NSString *str = @"";
    if ([value isKindOfClass:[NSString class]]) {
        str = value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *num = (NSNumber *)value;
        str = [NSString stringWithFormat:@"%@",@([num integerValue])];
    }
    
    if ([str isEqualToString:@"1"]||[str isEqualToString:@"ture"]) {
        return YES;
    }
    return NO;
}

UIKIT_STATIC_INLINE  BOOL CheckResponseObject(id responseObject){
    return [responseObject objectForKey:@"status"] && [[responseObject objectForKey:@"status"] longLongValue] == 0;
}
//UIKIT_STATIC_INLINE  BOOL ShowErrorResponseObject(id responseObject,UIViewController *control){
//    NSString *errorMessage = [responseObject objectForKey:@"msg"];
//    if (errorMessage == nil) {
//        errorMessage = ChineseStringOrENFun(@"未知错误", @"Unknown Error");
//    }
//    [CommonTools showAlertDismissWithContent:errorMessage showWaitTime:0.2 afterDelay:2 control:control];
//}

#endif /* CommonFunc_h */


#define YCisNull(a) ((a)==nil || (a)==NULL || (NSNull *)(a)==[NSNull null])

#define isEmptyString(a) ((a)==nil || (a)==NULL || (NSNull *)(a)==[NSNull null] || [(NSString *)(a) length]==0)



#define FORUM_DETAIL_READ_HISTORY       @"ForumDetailReadHistory"
#define CREAT_FORUM_READ_HISTORY_TIME   @"creatReadHistoryTime"

#define FORUM_DETAIL_ANONYMOUS_HISTORY       @"ForumDetailAnonymousHistory"
#define CREAT_FORUM_ANONYMOUS_HISTORY_TIME   @"creatAnonymousHistoryTime"
#define ReachCurrentUserID ([[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUserID"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"CurrentUserID"] :@"-1")
