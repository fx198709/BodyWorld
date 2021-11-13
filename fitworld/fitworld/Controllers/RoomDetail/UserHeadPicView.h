//
//  UserHeadPicView.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"
#import "Room.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserHeadPicView : UIView

- (void)changeHeadData:(BaseObject*)headModel;
- (void)changeCoachModelData:(CoachModel*)headModel;
- (void)changeRoomModelData:(Room*)roomModel;

@end

NS_ASSUME_NONNULL_END
