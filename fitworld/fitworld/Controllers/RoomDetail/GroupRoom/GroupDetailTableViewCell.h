//
//  GroupDetailTableViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/3.
//

#import "BaseTableViewCell.h"
#import "Room.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupDetailTableViewCell : BaseTableViewCell
@property (nonatomic, strong) Room *currentRoom;
- (void)changeDatewithRoom:(Room*)room;

@end

NS_ASSUME_NONNULL_END
