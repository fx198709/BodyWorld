//
//  LogHelper.m
//  Ework
//
//  Created by ChiJinLian on 2017/8/1.
//  Copyright © 2017年 crm. All rights reserved.
//

#import "LogHelper.h"
#import "AFNetworking.h"
#import "NSMutableDictionary+YCExtension.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "KeychainDeviceID.h"
#define DEFAULT_LOG_FILE   @"YCDefaultLog"

@interface LogHelper()
/**
 沙盒文件夹路径
 */
@property (nonatomic, copy) NSString *fileStoragePath;
/**
 记录日志的NSMutableArray
 */
@property (nonatomic, strong) NSMutableArray *logArray;
@end

@implementation LogHelper

+ (instancetype)sharedInstance {
    static LogHelper *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[LogHelper alloc] init];
        manager.fileStoragePath = [LogHelper fileStorage];
        manager.logArray = [NSMutableArray arrayWithCapacity:3];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ReleaseConfig" ofType:@"plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        BOOL logEnable = [[data valueForKey:@"LogEnable"] boolValue];
        manager.logEnable = logEnable;
        
//#warning fixme  为了测试打卡，特定设置
//        NSString *userID = [Login getUserID];
//        manager.logEnable = ([userID isEqualToString:@"12273"] || [userID isEqualToString:@"5941"] || [userID isEqualToString:@"6566"]);
        
        [self outDaysClearForumDetailReadHistory];
    });
    return manager;
}
//超过时间，清除bbs帖子详情阅读记录，匿名实名评论状态
+ (void)outDaysClearForumDetailReadHistory {
    NSMutableDictionary *readHistoryDic = [[NSMutableDictionary alloc] initWithStore:FORUM_DETAIL_READ_HISTORY];
    NSDate *creatDate = readHistoryDic[CREAT_FORUM_READ_HISTORY_TIME];
    //超过2个月
    if (creatDate && [[creatDate dateByAddingTimeInterval:2*30*24*60*60] compare:[NSDate date]] == NSOrderedAscending) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
        [dic setObject:[NSDate date] forKey:CREAT_FORUM_READ_HISTORY_TIME];
        [dic writeToStore:FORUM_DETAIL_READ_HISTORY];
    }
    
    NSMutableDictionary *anonymousHistoryDic = [[NSMutableDictionary alloc] initWithStore:FORUM_DETAIL_ANONYMOUS_HISTORY];
    NSDate *anonymousDate = anonymousHistoryDic[CREAT_FORUM_ANONYMOUS_HISTORY_TIME];
    //超过2个月
    if (anonymousDate && [[anonymousDate dateByAddingTimeInterval:2*30*24*60*60] compare:[NSDate date]] == NSOrderedAscending) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
        [dic setObject:[NSDate date] forKey:CREAT_FORUM_ANONYMOUS_HISTORY_TIME];
        [dic writeToStore:FORUM_DETAIL_ANONYMOUS_HISTORY];
    }
}

+ (void)clearForumHistory {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic setObject:[NSDate date] forKey:CREAT_FORUM_READ_HISTORY_TIME];
    [dic writeToStore:FORUM_DETAIL_READ_HISTORY];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic2 setObject:[NSDate date] forKey:CREAT_FORUM_ANONYMOUS_HISTORY_TIME];
    [dic2 writeToStore:FORUM_DETAIL_ANONYMOUS_HISTORY];
}

+ (NSString *)fileStorage {
    //沙盒document路径
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //沙盒document路径里面的YC_file_storage
    NSString *fileStorage = [documentDirectory stringByAppendingPathComponent:@"YC_file_storage"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:fileStorage isDirectory:&isDir] && isDir) {
        return fileStorage;
    }else{
        [fileManager createDirectoryAtPath:fileStorage
               withIntermediateDirectories:true
                                attributes:nil
                                     error:nil];
        return fileStorage;
    }
}
//上传到文件服务器的
+ (void)uploadLogFileName:(NSString *)fileName filePath:(NSString *)filePath completionHandler:(void (^)(void))completionHandler {
    
    NSString *contentType = AFContentTypeForPathExtension([filePath pathExtension]);
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@UploadBugAttach.ashx",@""] parameters:@{@"FileName":fileName} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:fileName mimeType:contentType error:nil];
    } error:nil];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error){
        if (error) {
            NSLog(@"上传日志Error: %@", error);
        } else {
            NSLog(@"上传日志Success");
//            NSLog(@"上传日志Success: %@ %@", response, responseObject);
            completionHandler();
        }
    }];
    [uploadTask resume];
    
}

#pragma 记录日志相关


+ (NSString *)loginKey {
    NSString *Key = [NSString stringWithFormat:@"key_%@",[APPObjOnce sharedAppOnce].currentUser.id];
    return Key;
}

+ (NSArray *)getLoginLogFile:(NSString *)file {
    NSString *filePath = [[LogHelper sharedInstance].fileStoragePath stringByAppendingPathComponent:file];
    // 读取数据
    NSArray *logArray = [NSArray arrayWithContentsOfFile:filePath];
    if (logArray.count == 0) {
        return @[];
    }
    return logArray;
}

#pragma mark 写入打卡log
//写入打卡log
+ (void)writeClockLog:(NSString *)log{
//    打卡日志，存放的点
    NSString *clockFilePath = [[LogHelper sharedInstance].fileStoragePath stringByAppendingPathComponent:@"YC_file_Colock"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:clockFilePath isDirectory:&isDir] && isDir) {
    }else{
        [fileManager createDirectoryAtPath:clockFilePath
               withIntermediateDirectories:true
                                attributes:nil
                                     error:nil];
     }
    NSDate *currentDate = [NSDate date];
    NSString *month = [CommonTools reachFormateDateStringFromInDate:currentDate withFormat:@"yyyyMM"];
//    用员工编号，生成一个月份的日志
    NSString *fileName =  [NSString stringWithFormat:@"%@-%@-%@-%@",ReachCurrentUserID,[APPObjOnce sharedAppOnce].currentUser.id,month,[KeychainDeviceID getOpenUDID]];
    NSString *writeFilePath = [clockFilePath stringByAppendingPathComponent:fileName];
    NSString *time = [CommonTools reachFormateDateStringFromInDate:[NSDate date] withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *logStr = [NSString stringWithFormat:@"%@_%@",log,time];
//    这边写入日志
    [LogHelper writeFile:writeFilePath content:logStr];
}

//写入错误log
+ (void)writeErrorLog:(NSString *)log{
    if ([log containsString:@"alogs.umengcloud.com"]) {
//        友盟的连接报错，这边不处理
        return;
    }
    NSLog(log);
    //    错误日志存放的位置
//    错误日志，每天生成一个文件，进来判断一下日期，然后直接上传到服务器
//    如果想上传日志，那把本地时间修改，就直接上传，这个方法写在从后台进前台那边，来回切换就上传，
//    本地和服务器之间有时间校准，相差不能超过2个小时，所以这个时候其他的方法会报错，但是上传不会
    NSString *errorFilePath = [[LogHelper sharedInstance].fileStoragePath stringByAppendingPathComponent:@"YC_Error_Colock"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:errorFilePath isDirectory:&isDir] && isDir) {
    }else{
        [fileManager createDirectoryAtPath:errorFilePath
               withIntermediateDirectories:true
                                attributes:nil
                                     error:nil];
    }
    NSDate *currentDate = [NSDate date];
    NSString *dayString = [CommonTools reachFormateDateStringFromInDate:currentDate withFormat:@"yyyyMMdd"];
    //    用员工编号，生成一个月份的日志
    NSString *fileName =  [NSString stringWithFormat:@"Error%@-%@-%@-%@",ReachCurrentUserID,[APPObjOnce sharedAppOnce].currentUser.id,dayString,[KeychainDeviceID getOpenUDID]];
    NSString *writeFilePath = [errorFilePath stringByAppendingPathComponent:fileName];
//    因为是每一天的记录，所以这边只要精确到秒就行了  日期可以去掉
    NSString *time = [CommonTools reachFormateDateStringFromInDate:[NSDate date] withFormat:@"HH:mm:ss"];
    NSString *logerrorStr = [NSString stringWithFormat:@"%@\\n%@",time,log];
    //    这边写入日志
    [LogHelper writeFile:writeFilePath content:logerrorStr];
}

//写入埋点log
+ (void)writeBuriedPointLog:(NSString *)log{
    if ([log containsString:@"alogs.umengcloud.com"]) {
//        友盟的连接报错，这边不处理
        return;
    }
    //    错误日志存放的位置
//    错误日志，每天生成一个文件，进来判断一下日期，然后直接上传到服务器
//    如果想上传日志，那把本地时间修改，就直接上传，这个方法写在从后台进前台那边，来回切换就上传，
//    本地和服务器之间有时间校准，相差不能超过2个小时，所以这个时候其他的方法会报错，但是上传不会
    NSString *errorFilePath = [[LogHelper sharedInstance].fileStoragePath stringByAppendingPathComponent:@"YC_Buried_Point_Colock"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if ([fileManager fileExistsAtPath:errorFilePath isDirectory:&isDir] && isDir) {
    }else{
        [fileManager createDirectoryAtPath:errorFilePath
               withIntermediateDirectories:true
                                attributes:nil
                                     error:nil];
    }
    NSDate *currentDate = [NSDate date];
    NSString *dayString = [CommonTools reachFormateDateStringFromInDate:currentDate withFormat:@"yyyyMMdd"];
    //    用员工编号，生成一个月份的日志
    NSString *fileName =  [NSString stringWithFormat:@"BuriedPoint%@-%@-%@-%@",ReachCurrentUserID,[APPObjOnce sharedAppOnce].currentUser.id,dayString,[KeychainDeviceID getOpenUDID]];
    NSString *writeFilePath = [errorFilePath stringByAppendingPathComponent:fileName];
//    因为是每一天的记录，所以这边只要精确到秒就行了  日期可以去掉
    NSString *time = [CommonTools reachFormateDateStringFromInDate:[NSDate date] withFormat:@"HH:mm:ss"];
    NSString *logerrorStr = [NSString stringWithFormat:@"%@\\n%@",time,log];
    //    这边写入日志
    [LogHelper writeFile:writeFilePath content:logerrorStr];
}
+ (void)writeFile:(NSString*)filePath content:(NSString*)conetnt {
    NSFileHandle *outFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if(outFile == nil)
    {
        NSData *buffer = [conetnt dataUsingEncoding:NSUTF8StringEncoding];
        [buffer writeToFile:filePath atomically:YES];
        NSLog(@"Open of file for writing failed");
    }
    else{
        //找到并定位到outFile的末尾位置(在此后追加文件)
        [outFile seekToEndOfFile];
       //读取inFile并且将其内容写到outFile中
//        NSString *bs = [NSString stringWithFormat:@"发送数据时间:%@--localMac:%@--remoteMac:%@--length:%d \n",[self currentTime],localMac,remoteMac,length];
        NSString *writeFileString = [NSString stringWithFormat:@"%@--%@",@"\n",conetnt];
        NSData *buffer = [writeFileString dataUsingEncoding:NSUTF8StringEncoding];
        [outFile writeData:buffer];
        //关闭读写文件
        [outFile closeFile];
    }
    
 
}
//上传埋点日志的日志文件
+ (void)uploadBuriedPointLogFile{
    NSString *clockFilePath = [[LogHelper sharedInstance].fileStoragePath stringByAppendingPathComponent:@"YC_Buried_Point_Colock"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:clockFilePath error:nil];
    for (NSString *filename in fileArray) {
        NSString *realFilePath = [clockFilePath stringByAppendingPathComponent:filename];
        NSDictionary *dic = [fileManager attributesOfItemAtPath:realFilePath error:nil];
        if (dic) {
//                NSString *fileName =  [NSString stringWithFormat:@"%@-%@-%@-%@",ReachCurrentUserID,[Login getUserName],dayString,[KeychainDeviceID getOpenUDID]];
//            根据命名规则，获取错误日志发生的时间，
            NSArray *nameArray = [filename componentsSeparatedByString:@"-"];
            if (nameArray.count < 3) {
                continue;
            }
            NSString *dayString = [nameArray objectAtIndex:2];
            NSString *currntString =[CommonTools reachFormateDateStringFromInDate:[NSDate date] withFormat:@"yyyyMMdd"];
             
            [LogHelper uploadLogFileName:filename filePath:realFilePath completionHandler:^(){
                //如果
                if (![dayString isEqualToString:currntString]){
                    [fileManager removeItemAtPath:realFilePath error:nil];
                }
                
            }];
            
        }
    }
}

//上传错误日志的日志文件
+ (void)uploadErrorLogFile:(BOOL)force{
    NSString *clockFilePath = [[LogHelper sharedInstance].fileStoragePath stringByAppendingPathComponent:@"YC_Error_Colock"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:clockFilePath error:nil];
    for (NSString *filename in fileArray) {
        NSString *realFilePath = [clockFilePath stringByAppendingPathComponent:filename];
        NSDictionary *dic = [fileManager attributesOfItemAtPath:realFilePath error:nil];
        //这个直接能转成一个date 比较牛逼
        if (dic) {
//                NSString *fileName =  [NSString stringWithFormat:@"%@-%@-%@-%@",ReachCurrentUserID,[Login getUserName],dayString,[KeychainDeviceID getOpenUDID]];
//            根据命名规则，获取错误日志发生的时间，
            NSArray *nameArray = [filename componentsSeparatedByString:@"-"];
            if (nameArray.count < 3) {
                continue;
            }
            NSString *dayString = [nameArray objectAtIndex:2];
            NSString *currntString =[CommonTools reachFormateDateStringFromInDate:[NSDate date] withFormat:@"yyyyMMdd"];
              //如果是当天的日志，不上传
            if ([dayString isEqualToString:currntString]) {
//                如果是强制的，这边还是需要上传的，上传之后，文件不删除
                if (force) {
                    [LogHelper uploadLogFileName:filename filePath:realFilePath completionHandler:^(){
                    }];
                }
            }
            else{
                //不是当天的日志，这边直接上传
                [LogHelper uploadLogFileName:filename filePath:realFilePath completionHandler:^(){
                    [fileManager removeItemAtPath:realFilePath error:nil];
                }];
            }
        }
    }
}

//上传打卡的日志文件
+ (void)uploadClockLogFile{
//    ClockLogTimeString 获取上次上传成功的日期，这个是以日为单位的，  每天只上传一次
    NSString *timeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"ClockLogTimeString"];
    NSString *currentTime = [CommonTools reachFormateDateStringFromInDate:[NSDate date] withFormat:@"yyyyMMdd"];
//    当前日期比上一次时间大，这个时候是需要上传的，每次上传都是上传2个月的打卡记录
    if (currentTime.integerValue > timeString.integerValue) {
        //        这边表示之前没上传过，需要重新上传
        //        在上传之前，先把过期的数据扔掉
        NSString *clockFilePath = [[LogHelper sharedInstance].fileStoragePath stringByAppendingPathComponent:@"YC_file_Colock"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:clockFilePath error:nil];
        for (NSString *filename in fileArray) {
            NSString *realFilePath = [clockFilePath stringByAppendingPathComponent:filename];
            NSDictionary *dic = [fileManager attributesOfItemAtPath:realFilePath error:nil];
            //这个直接能转成一个date 比较牛逼
            if (dic) {
                NSDate *creatDate = (NSDate*)[dic objectForKey:NSFileCreationDate];
                long timediff = [creatDate timeIntervalSinceNow];
//                这个是删除90天之前的文件，😁，保证本地只存在2-3个文件
                if (labs(timediff) > 90*24*3600) {
                    [fileManager removeItemAtPath:realFilePath error:nil];
                }
                else{
//                    没有被删除,上传文件
                    [LogHelper uploadLogFileName:filename filePath:realFilePath completionHandler:^(){
                        NSString *successTime = [CommonTools reachFormateDateStringFromInDate:[NSDate date] withFormat:@"yyyyMMdd"];
                        [[NSUserDefaults standardUserDefaults] setObject:successTime forKey:@"ClockLogTimeString"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                     }];
                }
            }
        }
    }
}



+ (void)clearLogFile:(NSString *)file {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[LogHelper sharedInstance].fileStoragePath stringByAppendingPathComponent:file];
    BOOL blDele = [fileManager removeItemAtPath:filePath error:nil];
    if (blDele) {
        NSLog(@"删除成功");
    }
}

static inline NSString * AFContentTypeForPathExtension(NSString *extension) {
#ifdef __UTTYPE__
    NSString *UTI = (__bridge_transfer NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)extension, NULL);
    NSString *contentType = (__bridge_transfer NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
    if (!contentType) {
        return @"application/octet-stream";
    } else {
        return contentType;
    }
#else
#pragma unused (extension)
    return @"application/octet-stream";
#endif
}


@end
