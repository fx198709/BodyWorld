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
@implementation APPObjOnce
+ (instancetype)sharedAppOnce {
    static APPObjOnce *_sharedApp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedApp = [[APPObjOnce alloc] init];
    });
    
    return _sharedApp;
}

- (void)getUserinfo:(nullable void(^)(bool isSuccess))completedBlock {    
    [[AFAppNetAPIClient manager] GET:@"user_info" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject objectForKey:@"recordset"]) {
            self.currentUser = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"]];
            if (completedBlock) {
                completedBlock(YES);
            }
        }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [MTHUD showDurationNoticeHUD:error.localizedDescription];
           if (completedBlock) {
               completedBlock(NO);
           }
    }];
}

- (void)joinRoom:(Room*)selectRoom withInvc:(UIViewController*)invc{
//    Room *selectRoom = [_dataArr objectAtIndex: recognizer.tag];
    NSString * nickName = [APPObjOnce sharedAppOnce].currentUser.nickname;
    [ConfigManager sharedInstance].eventId = selectRoom.event_id;
    [ConfigManager sharedInstance].nickName = nickName;
    [[ConfigManager sharedInstance] saveConfig];

    NSDictionary *codeDict = @{@"eid":selectRoom.event_id, @"name":nickName};
    RoomVC *roomVC = [[RoomVC alloc] initWith:codeDict];
    [invc.navigationController pushViewController:roomVC animated:YES];
    roomVC.invc = invc;
}


@end
