//
//  UIScrollView+YCRefresh.h
//  test
//
//  Created by YiChe on 16/8/4.
//  Copyright © 2016年 YiChe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

/**
 MJRefresh的封装：
 
 1. 添加头部控件的方法
  [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
 
 2. 添加尾部控件的方法
  [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
  
 3. 在UIScrollView+YCRefresh分类的 addHeaderWithTarget:action: 和 addFooterWithTarget:action: 
    方法中统一定义了显示的文字内容和文字颜色
 
 4.自动进入刷新状态
  [self.tableView.mj_header beginRefreshing];
  [self.tableView.mj_footer beginRefreshing];
 
 5.结束刷新
  [self.tableView.mj_header endRefreshing];
  [self.tableView.mj_footer endRefreshing];
 
 6.提示没有更多的数据（已加载全部数据）
  [self.tableView.mj_footer endRefreshingWithNoMoreData];
 
 7.重置没有更多的数据（消除没有更多数据的状态）
  [self.tableView.mj_footer resetNoMoreData];
 
 8.移除刷新控件
  [self.tableView removeHeader];
  [self.tableView removeFooter];
 */


@interface UIScrollView (YCRefresh)

/**
 *  添加一个下拉刷新头部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addHeaderWithTarget:(id)target action:(SEL)action;

/**
 *  添加一个上拉刷新尾部控件
 *
 *  @param target 目标
 *  @param action 回调方法
 */
- (void)addFooterWithTarget:(id)target action:(SEL)action;

/**
 *  移除下拉刷新头部控件
 */
- (void)removeHeader;

/**
 *  移除上拉刷新尾部控件
 */
- (void)removeFooter;

@end


/**
 *  继承后替换resetNoMoreData方法
 */
@interface CJMJRefreshBackNormalFooter : MJRefreshBackGifFooter
/**
 iPHoneX 上无需修改上拉加载更多的距离
 */
@property (nonatomic, assign) BOOL withoutChangeXIgnoredScrollContentInsetBottom;
@end

@interface CJMJRefreshGifHeader : MJRefreshGifHeader
@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UIImageView *backView2;
@property (nonatomic, strong) UILabel *ycStateLabel;
@property (nonatomic, assign) BOOL animationing;
@end
