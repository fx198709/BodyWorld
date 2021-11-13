//
//  Friend.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import "BaseJSONModel.h"

typedef enum {
    FriendStatus_wait = 1, // 待添加
    FriendStatus_added = 2 // 已添加
}FriendStatus;

NS_ASSUME_NONNULL_BEGIN

@interface Friend : BaseJSONModel

@property (nonatomic , assign) int id;
@property (nonatomic , assign) int status;
@property (nonatomic , copy) NSString *avatar;
@property (nonatomic , copy) NSString *city;
@property (nonatomic , copy) NSString *country;
@property (nonatomic , copy) NSString *friend_id;
@property (nonatomic , copy) NSString *friend_name;
@property (nonatomic , assign) int gender;

@end

NS_ASSUME_NONNULL_END
