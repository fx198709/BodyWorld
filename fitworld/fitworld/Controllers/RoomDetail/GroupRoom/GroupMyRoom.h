//
//  GroupMyRoom.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/6.
//

#import "BaseJSONModel.h"
#import "RoomUser.h"
@protocol RoomUser;
NS_ASSUME_NONNULL_BEGIN

@interface GroupMyRoom : BaseJSONModel

@property (nonatomic , strong) NSArray<RoomUser>  *room_user;
@property (nonatomic , strong) NSString *sub_room_id;
@property (nonatomic , strong) NSString *user_id;
@property (nonatomic , strong) NSString *event_id;
@property (nonatomic , assign) BOOL is_accept; //0待接受  1已接受  2已拒绝
@property (nonatomic , assign) BOOL is_creator;
@property (nonatomic , strong) NSString *creator_nick_name;
@property (nonatomic , strong) NSString *creator_user_name;

@end



NS_ASSUME_NONNULL_END
//"sub_room_id": "2021120616_aptddn",
//"user_id": "46009524363987460",
//"event_id": "384374590878517764",
//"is_accept": 1,
//"is_creator": true,
//"creator_nick_name": "186****1163",
//"creator_user_name": "+86:18601061163"
