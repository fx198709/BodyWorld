//
//  UserInfoView.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/6.
//

#import <UIKit/UIKit.h>
#import "RoomUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserInfoView : UIView

@property(nonatomic, strong)UserInfo * user;
@property(nonatomic, strong)RoomUser * roomUser;
@property(nonatomic, strong)NSString * userID;
@property(nonatomic, strong)UIButton * deleteBtn;
- (void)changeDatawithModel:(UserInfo*)userInfo andIsCreater:(BOOL)isCreate;

- (void)changeDatawithRoomUser:(RoomUser*)userInfo andIsCreater:(BOOL)isCreate;


@end

NS_ASSUME_NONNULL_END
