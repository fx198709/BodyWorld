//
//  FriendPageInfo.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import "BaseJSONModel.h"
#import "UserInfo.h"

@protocol UserInfo;

NS_ASSUME_NONNULL_BEGIN

@interface FriendPageInfo : BaseJSONModel

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<UserInfo> *rows;

@end

NS_ASSUME_NONNULL_END
