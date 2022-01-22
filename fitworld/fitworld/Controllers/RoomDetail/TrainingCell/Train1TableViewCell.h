//
//  Train1TableViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/20.
//

#import <UIKit/UIKit.h>
#import "Room.h"
NS_ASSUME_NONNULL_BEGIN

@interface Train1TableViewCell : BaseTableViewCell

- (void)changeDateWithRoomInfo:(Room*)roominfo andTimeDur:(NSTimeInterval)timeDur;

@end

NS_ASSUME_NONNULL_END
