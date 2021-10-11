//
//  MainViewController.h
//  fitworld
//
//  Created by 王巍 on 2021/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UITableViewController

@property (weak, nonatomic) NSIndexPath *liveIndexPath;
@property (weak, nonatomic) NSIndexPath *groupIndexPath;
@property (weak, nonatomic) NSIndexPath *buddyIndexPath;

@end

NS_ASSUME_NONNULL_END
