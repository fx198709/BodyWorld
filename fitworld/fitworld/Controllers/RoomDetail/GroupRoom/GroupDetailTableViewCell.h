//
//  GroupDetailTableViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/3.
//

#import "BaseTableViewCell.h"
#import "Room.h"
#import "CoachModel.h"
#import "StarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GroupDetailTableViewCell : BaseTableViewCell
@property (nonatomic, strong) Room *currentRoom;
@property (nonatomic, strong) StarView *starView;
@property (nonatomic, strong) CoachModel *coachModel;



- (void)changeDatewithRoom:(Room*)room;

- (void)changeCoachinfo:(CoachModel*)coachModel;

@end

NS_ASSUME_NONNULL_END
