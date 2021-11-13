//
//  BaseViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
        
    self.view.backgroundColor = UIColor.blackColor;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 弹窗提示

- (void)showChangeFailedError:(NSError *)error {
    NSString *msg = error == nil ? ChangeErrorMsg : error.localizedDescription;
    [MTHUD showDurationNoticeHUD:msg];
}

- (void)showSuccessNoticeAndPopVC {
    [MTHUD showDurationNoticeHUD:ChangeSuccessMsg animated:YES completedBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - MJRefresh

- (void)MJRefreshData {
    
}

- (void)MJRequestMoreData {
}

- (void)addMJRefreshToTable:(UITableView *)tableView {
    MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(MJRefreshData)];
    mjHeader.lastUpdatedTimeLabel.hidden = YES;
    [mjHeader setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [mjHeader setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [mjHeader setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    
    MJRefreshAutoNormalFooter *mjFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MJRequestMoreData)];
    [mjFooter setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [mjFooter setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [mjFooter setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [mjFooter setTitle:@"" forState:MJRefreshStateNoMoreData];
    tableView.mj_header = mjHeader;
    tableView.mj_footer = mjFooter;
}

- (void)finishMJRefresh:(UITableView *)tableView isFinished:(BOOL)isFinished {
    [tableView.mj_header endRefreshing];
    if (isFinished) {
        [tableView.mj_footer endRefreshingWithNoMoreData];
    } else {
        [tableView.mj_footer endRefreshing];
    }
}

@end
