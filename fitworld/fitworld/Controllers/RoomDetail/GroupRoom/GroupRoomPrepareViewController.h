//
//  GroupRoomPrepareViewController.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/7.
//

#import "BaseNavViewController.h"
#import "TableHeadview.h"
#import "Room.h"
NS_ASSUME_NONNULL_BEGIN

@interface GroupRoomPrepareViewController : BaseNavViewController
@property (weak, nonatomic) IBOutlet UIButton *tillBtn;
@property (weak, nonatomic) IBOutlet UIButton *startNowBtn;
@property (weak, nonatomic) IBOutlet UIView *actionbackview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionBtnTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tillBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *headview;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *headTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startNowBtnHeightCon;
@property (nonatomic, strong) NSDictionary *extended_data;

@property (nonatomic, strong) NSString * event_id;
//随机房间 还是自定义房间
- (void)createSubRoomOrDelete:(int)type;
@end

NS_ASSUME_NONNULL_END
