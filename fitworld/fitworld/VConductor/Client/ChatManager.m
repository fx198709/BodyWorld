#import "ChatManager.h"
#import <UIKit/UIKit.h>

#import "TUIKit.h"
#import "GenerateTestUserSig.h"

@interface ChatManager() <V2TIMSDKListener> {
  
}
@property (nonatomic, strong) NSString* mAppId;
@property (nonatomic, strong) NSString* mSecId;
@property (nonatomic, strong) NSString* mGroupId;
@property (nonatomic, strong) NSString* mUserName;
@property (nonatomic, strong) NSString* mSrvUserSig;
@end

@implementation ChatManager

@synthesize mAppId;
@synthesize mSecId;
@synthesize mGroupId;
@synthesize mUserName;
@synthesize mSrvUserSig;

+ (instancetype)sharedInstance {
  static ChatManager * instance;
  if (!instance) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[[self class] alloc] init];
    });
  }
  return instance;
}

- (void)initSDK {
  mAppId = @"1400430927";
  mSecId = @"880105dfa16bf2f4c876bd22c763b324e7da2eaa6378bc635903edb3c17e3795";
  
  [[TUIKit sharedInstance] setupWithAppId:1400430927];
}

- (void)joinChat:(NSString*)groupId withUserName:(NSString*)userName andUserSig:(NSString*)srvUserSig {
  mGroupId = groupId;
  mUserName = userName;
  mSrvUserSig = srvUserSig;
  
  NSString *localUserSig = [GenerateTestUserSig genTestUserSig:userName];
  
//  [[TUIKit sharedInstance] login:userName userSig:localUserSig succ:^{
//      NSLog(@"[TM]-----> 登录成功");
//    [[V2TIMManager sharedInstance] joinGroup:groupId msg:@"大家好" succ:^{
//      NSLog(@"[TM]-----> 加入群聊成功");
//    } fail:^(int code, NSString *desc) {
//      NSLog(@"[TM]-----> 加入群聊失败:%@", desc);
//    }];
//  } fail:^(int code, NSString *desc) {
//      NSLog(@"[TM]-----> 登录失败:%@", desc);
//  }];
  
}

- (void)quitChat {
  [[V2TIMManager sharedInstance] quitGroup:mGroupId succ:^{
    NSLog(@"[TM]-----> 退出群聊成功");
    [[V2TIMManager sharedInstance] logout:^{
      NSLog(@"[TM]-----> 注销成功");
    } fail:^(int code, NSString *desc) {
      NSLog(@"[TM]-----> 注销失败:%@", desc);
    }];
  } fail:^(int code, NSString *desc) {
    NSLog(@"[TM]-----> 退出群聊失败:%@", desc);
  }];
}

#pragma mark - V2TIMSDKListener

- (void)onConnecting {
  
}

- (void)onConnectSuccess {
}

- (void)onConnectFailed:(int)code err:(NSString*)err {
  
}

- (void)onKickedOffline {
  
}

- (void)onUserSigExpired {
  
}

- (void)onSelfInfoUpdated:(V2TIMUserFullInfo *)Info {
  
}

@end
