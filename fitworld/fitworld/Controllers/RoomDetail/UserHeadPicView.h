//
//  UserHeadPicView.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "Room.h"
#import "UserInfo.h"
#import "CoachComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserHeadPicView : UIView

@property (nonatomic, retain)UIButton *userBtn;
- (void)changeHeadData:(BaseObject*)headModel;
- (void)changeCoachModelData:(CoachModel*)headModel;
- (void)changeUserInfoModelData:(UserInfo*)headModel;

- (void)changeRoomModelData:(Room*)roomModel;
- (void)changeCommentModelData:(CoachComment*)roomModel;


@end

NS_ASSUME_NONNULL_END
