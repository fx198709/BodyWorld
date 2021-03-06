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
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
}

+ (void)saveUserToken:(NSString *)token {
    //test
//    token = @"123";
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)clearUserToken {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
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
    [self.mainVC.navigationController popToRootViewControllerAnimated:NO];
}

- (void)showMainView {
    [self.mainVC.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loginSuccess:(id _Nullable) responseObject {
    NSLog(@"????????????---%@", responseObject);
    if ([responseObject objectForKey:@"status"] && [[responseObject objectForKey:@"status"] longLongValue] == 0) {
        UserInfo *userInfo = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"][@"user"]];
        userInfo.msg = responseObject[@"recordset"][@"msg"];
        userInfo.msg_cn = responseObject[@"recordset"][@"msg_cn"];
        [APPObjOnce sharedAppOnce].currentUser = userInfo;
        
        NSString *userToken = responseObject[@"recordset"][@"token"];
        if(userToken != nil){
            [APPObjOnce saveUserToken:userToken];
        }
        UIViewController *presentedVC = self.mainVC.presentedViewController;
        [presentedVC dismissViewControllerAnimated:YES completion:^{
            [self.mainVC reloadData];
        }];
    } else {
        NSString *msg = [responseObject objectForKey:@"msg"];
        [MTHUD showDurationNoticeHUD:msg];
    }
}

- (void)joinRoom:(Room*)selectRoom withInvc:(UIViewController*)invc{
//    Room *selectRoom = [_dataArr objectAtIndex: recognizer.tag];
//    ???????????????????????????
    int roomRealState = [selectRoom reachRoomDealState];
    if (roomRealState == 5) {
        NSString * nickName = [APPObjOnce sharedAppOnce].currentUser.nickname;
        [ConfigManager sharedInstance].eventId = selectRoom.event_id;
        [ConfigManager sharedInstance].nickName = nickName;
        [ConfigManager sharedInstance].userId = [APPObjOnce sharedAppOnce].currentUser.id;
        [[ConfigManager sharedInstance] saveConfig];
        
        NSDictionary *codeDict = @{@"eid":selectRoom.event_id, @"name":nickName};
        BOOL isbuddy = YES;
        if (selectRoom.course.type_int == 1) {
            isbuddy  = NO;
        }
        if (selectRoom.type_int == 1) {
            isbuddy  = NO;
        }
        if (!isbuddy) {
//            ??????
            GroupRoomViewControl *roomVC = [[GroupRoomViewControl alloc] initWith:codeDict];
            [invc.navigationController pushViewController:roomVC animated:YES];
            roomVC.invc = invc;
        }else{
            RoomVC *roomVC = [[RoomVC alloc] initWith:codeDict];
            [invc.navigationController pushViewController:roomVC animated:YES];
            roomVC.invc = invc;
        }
       
    }
    
}


@end
