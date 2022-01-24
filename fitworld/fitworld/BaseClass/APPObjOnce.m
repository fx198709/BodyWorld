//
//  APPObjOnce.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/10.
//

#import "APPObjOnce.h"
#import "UIView+MT.h"
#import "Room.h"
#import "RoomVC.h"
#import "GroupRoomViewControl.h"
#import "PrivateRoomViewControl.h"
#import "AppDelegate.h"

#define UserTokenKey @"userToken"
#define UserAccountTypeKey @"UserAccountType"

@implementation APPObjOnce

+ (instancetype)sharedAppOnce {
    static APPObjOnce *_sharedApp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedApp = [[APPObjOnce alloc] init];
    });
    
    return _sharedApp;
}

+ (NSString *)getUserToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserTokenKey];
}

+ (void)saveUserToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:UserTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearUserLoginInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserAccountTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAccountType {
    return [[NSUserDefaults standardUserDefaults] objectForKey:UserAccountTypeKey];
}

+ (void)saveAccountType:(NSString *)accountType {
    [[NSUserDefaults standardUserDefaults] setObject:accountType forKey:UserAccountTypeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSString*)getUserId{
    return _currentUser.id;
}

- (void)getUserinfo:(nullable void(^)(NSError * error))completedBlock {
    UserInfo * tempInfo = [[APPObjOnce sharedAppOnce] currentUser];

    [[AFAppNetAPIClient manager] GET:@"user_info" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject objectForKey:@"recordset"]) {
            self.currentUser = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"]];
            self.currentUser.msg = tempInfo.msg;
            self.currentUser.msg_cn = tempInfo.msg_cn;
        }
        if (completedBlock) {
            completedBlock(nil);
        }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [MTHUD showDurationNoticeHUD:error.localizedDescription];
           if (completedBlock) {
               completedBlock(error);
           }
    }];
}

- (void)showLoginView {
    if (_isLogining) {
        return;
    }
    UIViewController *loginVC = VCBySBName(@"LoginController");
    [self.mainRootVC setViewControllers:@[loginVC]];
}

- (void)showMainView {
    UIViewController *mainVC = VCBySBName(@"mainVC");
    [self.mainRootVC setViewControllers:@[mainVC]];
}

- (void)loginSuccess:(id _Nullable) responseObject {
    NSLog(@"请求成功---%@", responseObject);
    if ([responseObject objectForKey:@"status"] && [[responseObject objectForKey:@"status"] longLongValue] == 0) {
        UserInfo *userInfo = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"][@"user"]];
        userInfo.msg = responseObject[@"recordset"][@"msg"];
        userInfo.msg_cn = responseObject[@"recordset"][@"msg_cn"];
        [APPObjOnce sharedAppOnce].currentUser = userInfo;
        
        NSString *userToken = responseObject[@"recordset"][@"token"];
        if(userToken != nil){
            [APPObjOnce saveUserToken:userToken];
        }
        [self showMainView];
    } else {
        NSString *msg = [responseObject objectForKey:@"msg"];
        [MTHUD showDurationNoticeHUD:msg];
    }
}

- (void)joinRoom:(Room*)selectRoom withInvc:(UIViewController*)invc{
//    Room *selectRoom = [_dataArr objectAtIndex: recognizer.tag];
//    判断一下房间的状态
    int roomRealState = [selectRoom reachRoomDealState];
    if (roomRealState == 5) {
        NSString * nickName = [APPObjOnce sharedAppOnce].currentUser.nickname;
        [ConfigManager sharedInstance].eventId = selectRoom.event_id;
        [ConfigManager sharedInstance].nickName = nickName;
        [ConfigManager sharedInstance].userId = [APPObjOnce sharedAppOnce].currentUser.id;
        [[ConfigManager sharedInstance] saveConfig];
        
        NSDictionary *codeDict = @{@"eid":selectRoom.event_id, @"name":nickName};
        int type_int = [selectRoom reachRoomRealTypeInt];
        BaseRoomViewController *roomviewControl = nil;
        if (type_int == 1) {
//            团课 
            GroupRoomViewControl *roomVC = [[GroupRoomViewControl alloc] initWith:codeDict];
            [invc.navigationController pushViewController:roomVC animated:YES];
            roomVC.invc = invc;
            roomviewControl = roomVC;
        }else if (type_int == 2) {
//            私教
            PrivateRoomViewControl *roomVC = [[PrivateRoomViewControl alloc] initWith:codeDict];
            [invc.navigationController pushViewController:roomVC animated:YES];
            roomVC.invc = invc;
            roomviewControl = roomVC;
        }else{
            RoomVC *roomVC = [[RoomVC alloc] initWith:codeDict];
            [invc.navigationController pushViewController:roomVC animated:YES];
            roomVC.invc = invc;
            roomviewControl = roomVC;
        }
        if ([selectRoom.course.screen isEqualToString:@"landscape"]) {
            roomviewControl.needChangeOrientation = YES;
//            [roomviewControl performSelector:@selector(changeOrientation) withObject:nil afterDelay:2];
        }
    }
    
}


@end
