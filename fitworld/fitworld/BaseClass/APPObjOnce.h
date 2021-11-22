//
//  APPObjOnce.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

#define Notification_GetUserInfo @"Notification_GetUserInfo"
NS_ASSUME_NONNULL_BEGIN

@interface APPObjOnce : NSObject

@property (nonatomic, strong) UserInfo *currentUser;
@property (nonatomic, strong) NSString *userId;

+ (instancetype)sharedAppOnce;

//获取用户信息
- (void)getUserinfo:(nullable void(^)(bool isSuccess))completedBlock;

- (void)joinRoom:(id)room withInvc:(UIViewController*)vc;



@end

NS_ASSUME_NONNULL_END
