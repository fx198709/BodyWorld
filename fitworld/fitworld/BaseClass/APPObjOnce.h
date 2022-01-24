//
//  APPObjOnce.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import "UserInfo.h"

#define Notification_GetUserInfo @"Notification_GetUserInfo"
NS_ASSUME_NONNULL_BEGIN

@interface APPObjOnce : NSObject

@property (nonatomic, strong) UserInfo *currentUser;
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, weak) UINavigationController *mainRootVC;
@property (nonatomic, assign) BOOL isLogining;

+ (instancetype)sharedAppOnce;


//获取usertoken
+ (NSString *)getUserToken;

//保存usertoken
+ (void)saveUserToken:(NSString *)token;

//清除用户账户信息
+ (void)clearUserLoginInfo;

//获取登录方式
+ (NSString *)getAccountType;

//保存登录方式
+ (void)saveAccountType:(NSString *)accountType;

//登录成功后保存信息
- (void)loginSuccess:(id _Nullable) responseObject;

//获取用户信息
- (void)getUserinfo:(nullable void(^)(NSError * error))completedBlock;


//显示登录页面（pop到MainView 后会根据有没有token进行登录页面展示）
- (void)showLoginView;
//显示主页面
- (void)showMainView;

- (void)joinRoom:(id)room withInvc:(UIViewController*)vc;



@end

NS_ASSUME_NONNULL_END
