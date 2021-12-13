//
//  HasJoinGroupRoomView.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/13.
//

#import <UIKit/UIKit.h>
#import "GroupMyRoom.h"
NS_ASSUME_NONNULL_BEGIN

@interface HasJoinGroupRoomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *userNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstUserImageview;
@property (weak, nonatomic) IBOutlet UIImageView *secondUserImageview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstarint;

- (void)changeviewWithUselist:(NSArray*)userList;

@end

NS_ASSUME_NONNULL_END
