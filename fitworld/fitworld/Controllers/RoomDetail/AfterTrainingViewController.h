//
//  AfterTrainingViewController.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/20.
//

#import "BaseNavViewController.h"
#import "Room.h"
#import "UserInfo.h"
//训练之后的成功页面
NS_ASSUME_NONNULL_BEGIN

@interface AfterTrainingViewController : BaseNavViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *successTabelview;

@property (nonatomic, strong)NSString *event_id;
@property (nonatomic, strong)Room *currentRoom;
@property (nonatomic, strong)NSMutableArray *userList;
@property (nonatomic, weak)UIViewController *invc;




@end

NS_ASSUME_NONNULL_END
