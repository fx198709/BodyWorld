//
//  MessageListViewController.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/4.
//

#import "BaseNavViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListViewController : BaseNavViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *messageTableview;
@end

NS_ASSUME_NONNULL_END
