//
//  Train2TableViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/20.
//

#import "BaseTableViewCell.h"
#import "Room.h"

NS_ASSUME_NONNULL_BEGIN

@interface Train2TableViewCell : BaseTableViewCell
- (void)changeDateWithRoomInfo:(Room*)roominfo;

@end

NS_ASSUME_NONNULL_END
