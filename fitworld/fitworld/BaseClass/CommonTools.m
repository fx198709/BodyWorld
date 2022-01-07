//
//  CommonTools.m
//  FFitWorld
//
//  Created by feixiang on 2021/10/30.
//

#import "CommonTools.h"
#import "Room.h"
#import "UserInfo.h"
#import "GroupRoomPrepareViewController.h"
#import "GroupRoomDetailViewController.h"
#import "CreateCourseSuccessViewController.h"
#import "CourseDetailViewController.h"


@implementation CommonTools

/*
 0 课程未开始  房主                                       显示立即进入     6   房东立即进入
 1 课程未开始  受邀好友   未预约                            显示预约     1
 2 课程未开始  受邀好友   已预约                            显示已预约    2
 3 课程未开始  陌生人              不允许陌生人              显示上锁      3
 4 课程未开始  陌生人    未预约     允许陌生人      未满6人    显示预约     1
 5 课程未开始  陌生人    未预约     允许陌生人      满6人     显示已约满     4
 6 课程未开始  陌生人    已预约                             显示已预约   2  (这种情况不存在）
 10 课程已开始  房主                                        显示立即进入     5
 11 课程已开始  受邀好友                                    显示立即进入     5
 12 课程已开始  陌生人              不允许陌生人              显示上锁      3
 13 课程已开始  陌生人              允许陌生人      未满6人    显示立即进入     5
 14 课程已开始  陌生人              允许陌生人      满6人     显示满员       4
 
 1  显示预约    -> 预约        绿色背景
 2  显示已预约  --> 取消预约    绿色背景
 3  显示上锁   -- >无操作       灰色
 4  已约满    --> 无操作       灰色
 5  立即进入   -->进入房间       红
 6  房东立即进入  -->进入准备页面   红
 */

+ (void)changeBtnState:(UIButton*)vbutn btnData:(Room*)roomData{
    NSString *joinTitle = ChineseStringOrENFun(@"已预约", @"You‘RE IN");
    UIImage *joinImage = [UIImage imageNamed:@"action_button_bg_green"];
    //    创建者的id 做一个兼容
    NSString * roomCreaterID = roomData.room_creator.id ? roomData.room_creator.id:roomData.creator_userid;
    if ([roomData isBegin]) {
        //        已经开始直播
        if ([roomCreaterID isEqualToString:[APPObjOnce sharedAppOnce].currentUser.id]) {
            //            房主
            joinTitle = ChineseStringOrENFun(@"立即进入", @"JOIN CLASS");
            joinImage = [UIImage imageNamed:@"action_button_bg_red"];
            roomData.roomDealState = 5;
        }else if(roomData.is_room_user){
            roomData.roomDealState = 5;
            joinTitle = ChineseStringOrENFun(@"立即进入", @"JOIN CLASS");
            joinImage = [UIImage imageNamed:@"action_button_bg_red"];
        }
        else{
            if (roomData.allow_watch) {
                long maxnumber = MAX(roomData.max_num, roomData.course.max_num);
                if (maxnumber > roomData.invite_count) {
                    roomData.roomDealState = 5;
                    //                    立即进入
                    joinTitle = ChineseStringOrENFun(@"立即进入", @"JOIN CLASS");
                    joinImage = [UIImage imageNamed:@"action_button_bg_red"];
                }else{
                    roomData.roomDealState = 4;
                    //                    已约满
                    joinTitle = ChineseStringOrENFun(@"已约满", @"COUNT ME IN");
                    joinImage = [UIImage imageNamed:@"action_button_bg_gray"];
                }
            }else{
                roomData.roomDealState = 3;
                //                上锁
                joinTitle = ChineseStringOrENFun(@"上锁", @"Lock");
                joinImage = [UIImage imageNamed:@"action_button_bg_gray"];
            }
        }
    }else{
        if ([roomCreaterID isEqualToString:[APPObjOnce sharedAppOnce].currentUser.id]) {
            //            创建人
            joinTitle = ChineseStringOrENFun(@"立即进入", @"JOIN CLASS");
            joinImage = [UIImage imageNamed:@"action_button_bg_red"];
            roomData.roomDealState = 6;
        }else if(roomData.is_room_user){ //被邀请人 或者加入人
            if (roomData.is_join) {
                roomData.roomDealState = 2;
                joinTitle = ChineseStringOrENFun(@"已预约", @"You‘RE IN");
                joinImage = [UIImage imageNamed:@"action_button_bg_green"];
                
            }else{
                roomData.roomDealState = 1;
                joinTitle = ChineseStringOrENFun(@"预约", @"COUNT ME IN");
                joinImage = [UIImage imageNamed:@"action_button_bg_gray"];
            }
        }else{
            if (roomData.allow_watch) {
                long maxnumber = MAX(roomData.max_num, roomData.course.max_num);
                if (maxnumber > roomData.invite_count) {
                    roomData.roomDealState = 1;
                    joinTitle = ChineseStringOrENFun(@"预约", @"COUNT ME IN");
                    joinImage = [UIImage imageNamed:@"action_button_bg_gray"];
                }else{
                    roomData.roomDealState = 4;
                    joinTitle = ChineseStringOrENFun(@"已约满", @"COUNT ME IN");
                    joinImage = [UIImage imageNamed:@"action_button_bg_gray"];
                }
            }else{
                roomData.roomDealState = 3;
                joinTitle = ChineseStringOrENFun(@"上锁", @"Lock");
                joinImage = [UIImage imageNamed:@"action_button_bg_gray"];
            }
        }
    }
    [vbutn setTitle:joinTitle forState:UIControlStateNormal];
    [vbutn setTitle:joinTitle forState:UIControlStateHighlighted];
    if (roomData.roomDealState == 3) {
        UIImage *lockImage = [UIImage imageNamed:@"activity_login_paasswd_img"];
        [vbutn setImage:lockImage forState:UIControlStateNormal];
        [vbutn setImage:lockImage forState:UIControlStateHighlighted];
        vbutn.imageEdgeInsets = UIEdgeInsetsMake(5, 15, 8, 20);
    }else{
        [vbutn setImage:nil forState:UIControlStateNormal];
        [vbutn setImage:nil forState:UIControlStateHighlighted];
        vbutn.imageEdgeInsets = UIEdgeInsetsZero;
        
    }
    [vbutn setBackgroundImage:joinImage forState:UIControlStateNormal];
    [vbutn setBackgroundImage:joinImage forState:UIControlStateHighlighted];
    if(!ISChinese()){
        vbutn.titleLabel.font = SystemFontOfSize(11);
    }
    
}

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
+ (NSString*)ReachTimeWithFormate:(NSTimeInterval) longtime andFormate:(NSString*)formate{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:longtime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //最结尾的Z表示的是时区，零时区表示+0000，东八区表示+0800
    [formatter setDateFormat:formate];
   // 使用formatter转换后的date字符串变成了当前时区的时间
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
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

+ (void)showNETErrorcontrol:(UIViewController*)control{
    NSString *error =ChineseStringOrENFun(@"网络错误", @"NET Error");
    [self showAlertDismissWithContent:error showWaitTime:0.2 afterDelay:2 control:control];
}

+ (void)showAlertDismissWithResponseContent:(id)response control:(UIViewController*)control{
    [self showAlertDismissWithContent:[response objectForKey:@"msg"] showWaitTime:0.2 afterDelay:2 control:control];
}


+ (void)showAlertDismissWithContent:(NSString*)content control:(UIViewController*)control{
    [self showAlertDismissWithContent:content showWaitTime:0.2 afterDelay:2 control:control];
}

+ (void)showAlertDismissWithContent:(NSString*)content showWaitTime:(NSTimeInterval)time afterDelay:(NSTimeInterval)delay control:(UIViewController*)control {
    __strong UIViewController * strongControl = control;
    NSString *alertString = ChineseStringOrENFun(@"提示", @"Alert");
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertString message:content preferredStyle:UIAlertControllerStyleAlert];
    
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
    NSString *leftString = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
    return leftString;
}



+ (void)findLocaltionCityName:(UserInfo*)user{
    
}

+ (UIViewController*)findControlWithView:(UIView*)inView{
    for (UIView* next = [inView superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

+ (UIEdgeInsets)safeAreaInsets{
    UIWindow *mainwindow = [CommonTools mainWindow];
    return mainwindow.safeAreaInsets;
}


+ (void)jumpNextVCwith:(Room*)selectRoom rootVC:(UIViewController*)rootVC{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //这里的id填刚刚设置的值,vc设置属性就可以给下个页面传参数了
    int type_int = selectRoom.course? (int)selectRoom.course.type_int: (int)selectRoom.type_int;
    if (type_int == 1) {
        //            团课的处理
        if (selectRoom.is_join) {
            GroupRoomPrepareViewController *vc =[[GroupRoomPrepareViewController alloc] initWithNibName:@"GroupRoomPrepareViewController" bundle:nil];
            vc.event_id = selectRoom.event_id;
            [rootVC.navigationController pushViewController:vc animated:YES];
        }else{
            GroupRoomDetailViewController *vc =[[GroupRoomDetailViewController alloc] initWithNibName:@"GroupRoomDetailViewController" bundle:nil];
            vc.selectRoom = selectRoom;
            [rootVC.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (type_int == 2) {
        //            团课的处理
        if (selectRoom.is_join) {
        }else{
            GroupRoomDetailViewController *vc =[[GroupRoomDetailViewController alloc] initWithNibName:@"GroupRoomDetailViewController" bundle:nil];
            vc.selectRoom = selectRoom;
            [rootVC.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        if (selectRoom.is_join) {
            CreateCourseSuccessViewController *vc =[[CreateCourseSuccessViewController alloc] initWithNibName:@"CreateCourseSuccessViewController" bundle:nil];
            vc.event_id = selectRoom.event_id;
            [rootVC.navigationController pushViewController:vc animated:YES];
        }else{
            CourseDetailViewController *vc = (CourseDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"courseDetailVC"];
            vc.selectRoom = selectRoom;
            [rootVC.navigationController pushViewController:vc animated:YES];
        }
    }
}


//得到中英文混合字符串长度 方法1
+ (NSUInteger)convertToInt:(NSString*)strtemp
{
    long strLength = 0;
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    char *p = (char *)[strtemp cStringUsingEncoding:encoding];
    //    [strtemp canBeConvertedToEncoding:encoding];
    if (!p) {
        NSData *data = [strtemp dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        return data.length;
    }
    
    NSUInteger lengthOfBytes = [strtemp lengthOfBytesUsingEncoding:encoding];
    for (int i = 0; i < lengthOfBytes; i++) {
        if (*p) {
            p++;
            strLength++;
        }
        else {
            p++;
        }
    }
    return strLength;
}

@end

