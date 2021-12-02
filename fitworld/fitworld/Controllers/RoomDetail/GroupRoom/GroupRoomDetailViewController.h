//
//  GroupRoomDetailViewController.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/2.
//

#import "BaseNavViewController.h"
#import "Room.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupRoomDetailViewController : BaseNavViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) Room *selectRoom;
@end

NS_ASSUME_NONNULL_END

