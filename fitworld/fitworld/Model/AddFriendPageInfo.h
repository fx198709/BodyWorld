//
//  AddFriendPageInfo.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import "BaseJSONModel.h"
#import "Friend.h"

@protocol Friend;

NS_ASSUME_NONNULL_BEGIN

@interface AddFriendPageInfo : BaseJSONModel

@property (nonatomic, assign) int page;
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<Friend> *rows;

@end

NS_ASSUME_NONNULL_END
