//
//  FriendRoomPageInfo.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/29.
//

#import "BaseJSONModel.h"
#import "Room.h"

@protocol Room;

NS_ASSUME_NONNULL_BEGIN

@interface FriendRoomPageInfo : BaseJSONModel

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<Room> *rows;

@end

NS_ASSUME_NONNULL_END
