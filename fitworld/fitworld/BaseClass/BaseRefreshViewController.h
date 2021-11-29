//
//  BaseRefreshViewController.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/29.
//
//  下拉刷新带tableview的页面
//

#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface BaseRefreshViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;
//当前页
@property (nonatomic, assign) NSInteger currentPage;
//是否已全部加在完毕
@property (nonatomic, assign) BOOL isFinished;
//是否正在请求中
@property (nonatomic, assign) BOOL isRequesting;

//初始化页面
- (void)initView;

//重制数据
- (void)resetData;

//获取数据列表接口 需要子类实现
- (void)getDataListFromServer:(BOOL)isRefresh;

//tableview的cell类型需要子类实现
- (Class)cellClass;

//是否需要每次都刷新页面
- (BOOL)needUpdateWhenViewAppear;

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
