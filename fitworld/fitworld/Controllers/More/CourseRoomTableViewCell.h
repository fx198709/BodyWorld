//
//  CourseRoomTableViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/13.
//

#import <UIKit/UIKit.h>
#import "Room.h"
NS_ASSUME_NONNULL_BEGIN

@interface CourseRoomTableViewCell : UITableViewCell

- (void)createSubviewWithRoomInfo:(Room*)roomInfo;

@end

NS_ASSUME_NONNULL_END
