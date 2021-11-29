//
//  FriendRoomCell.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/29.
//

#import <UIKit/UIKit.h>
#import "Room.h"


NS_ASSUME_NONNULL_BEGIN

@interface FriendRoomCell : UITableViewCell

@property (nonatomic, copy) BaseCallBack btnCallBack;


- (void)loadRoom:(Room *)room;

@end

NS_ASSUME_NONNULL_END
