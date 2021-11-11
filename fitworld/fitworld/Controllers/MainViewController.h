//
//  MainViewController.h
//  fitworld
//
//  Created by 王巍 on 2021/7/4.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN
@interface MainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) NSIndexPath *liveIndexPath;
@property (weak, nonatomic) NSIndexPath *groupIndexPath;
@property (weak, nonatomic) NSIndexPath *buddyIndexPath;
@property (strong, nonatomic) UITableView *mainTableview;
@property (strong, nonatomic) UserInfo * userInfo;
@end

NS_ASSUME_NONNULL_END
