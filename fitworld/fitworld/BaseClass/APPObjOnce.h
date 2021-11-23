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

@property (nonatomic, strong) MainViewController *mainVC;

+ (instancetype)sharedAppOnce;


//获取usertoken
+ (NSString *)getUserToken;

//保存usertoken
+ (void)saveUserToken:(NSString *)token;

//清除用户token
+ (void)clearUserToken;

//获取用户信息
- (void)getUserinfo:(nullable void(^)(NSError * error))completedBlock;

//显示登录页面（pop到MainView 后会根据有没有token进行登录页面展示）
- (void)showLoginView;
//显示主页面
- (void)showMainView;

- (void)joinRoom:(id)room withInvc:(UIViewController*)vc;



@end

NS_ASSUME_NONNULL_END
