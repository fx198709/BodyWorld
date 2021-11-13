//
//  BaseViewController.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : BaseNavViewController

#pragma mark - 弹窗提示

- (void)showChangeFailedError:(NSError *)error;

- (void)showSuccessNoticeAndPopVC;


#pragma mark - MJRefresh

/**
 给TableView添加下拉刷新和上拉加载更多

 @param tableView tableView
 */
- (void)addMJRefreshToTable:(UITableView *)tableView;


/**
 MJ下拉刷新
 */
- (void)MJRefreshData;

/**
 MJ上拉加载
 */
- (void)MJRequestMoreData;

//结束刷新
- (void)finishMJRefresh:(UITableView *)tableView isFinished:(BOOL)isFinished;


@end

NS_ASSUME_NONNULL_END
