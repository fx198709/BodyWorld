//
//  LogHelper.h
//  Ework
//
//  Created by ChiJinLian on 2017/8/1.
//  Copyright © 2017年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CLCOK_LOG   @"clockLog"

@interface LogHelper : NSObject

/**
 是否开启日志记录，请在ReleaseConfig.plist文件中设置
 */
@property (nonatomic, assign) BOOL logEnable;


+ (instancetype)sharedInstance;


/**
 写入埋点日志，主要是收集一些网络请求的日志
 @param log string
 */
+ (void)writeBuriedPointLog:(NSString *)log;
//上传埋点日志
+ (void)uploadBuriedPointLogFile;
/**
 写入错误日志，主要是收集一些网络请求的日志
 这个地方可能需要改造afnetworking
 @param log string
 */
+ (void)writeErrorLog:(NSString *)log;


//上传打卡的日志文件 现在把这个方法的触发条件写在了打卡页面，后续要改的话，改一下位置
+ (void)uploadErrorLogFile:(BOOL)force;

/**
 写入打卡log
 
 @param log 日志
 @param file 指定日志文件名称（值为nil 写入默认文件）
 */
+ (void)writeClockLog:(NSString *)log;

//上传打卡的日志文件
+ (void)uploadClockLogFile;

/**
 清空bbs帖子详情相关的历史信息（帖子阅读历史与匿名实名评论信息）
 */
+ (void)clearForumHistory;


/**
 删除指定日志文件（值为nil，删除本地所有日志文件）

 @param file 日志文件名
 */
+ (void)clearLogFile:(NSString *)file;

/*
 上传其他的日志
 */
+ (void)uploadThirdFile;

+ (void)openLog;
+ (void)stopLog;


@end
