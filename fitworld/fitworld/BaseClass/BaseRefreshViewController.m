//
//  BaseRefreshViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/29.
//

#import "BaseRefreshViewController.h"

@interface BaseRefreshViewController ()

@end

@implementation BaseRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = [NSMutableArray array];
    [self initView];
    [self resetData];
    if (![self needUpdateWhenViewAppear]) {
        [self MJRefreshData];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self needUpdateWhenViewAppear]) {
        [self MJRefreshData];
    }
}

- (void)initView {
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    Class cellClass = [self cellClass];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
    [self addMJRefreshToTable:self.tableView];
}


- (void)resetData {
    self.currentPage = 0;
    self.isFinished = NO;
    [self.dataList removeAllObjects];
}

- (BOOL)needUpdateWhenViewAppear {
    return NO;
}

#pragma mark - MJRefresh

- (void)MJRefreshData {
    [self resetData];
    [self getDataListFromServer:YES];
}

- (void)MJRequestMoreData {
    [self getDataListFromServer:NO];
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

#pragma mark - server

- (void)getDataListFromServer:(BOOL)isRefresh {
    //需要子类实现
}

- (Class)cellClass {
    return [UITableViewCell class];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
