//
//  ChoosePeopleViewController.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/13.
//

#import "ChoosePeopleViewController.h"
#import "AddPeopleTableViewCell.h"
#import "UIImage+Extension.h"
#import "TableHeadview.h"

@interface ChoosePeopleViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    BOOL isLoading;
    int _pageCount;
    BOOL _isLoadAllData; //是否加载所有的数据，每次刷新的时候，都设置成no， 接口返回的数据小于需要的数量时，设置成yes
    int  _orderbyType; //排序类型 0最新创建，1最近执行
    NSURLSessionDataTask *requestTask;//请求用的task
    NSMutableArray *dataArr;
    NSString *_searchString;
    UISearchBar *searchBar;
    NSArray * lastLevelSelectUsers;
    BOOL hasUserlistReady; //已添加的人
    BOOL allPeoplelistRequestReady; //所有人
    
}
@property(nonatomic,strong)UITableView*tableView;


@end

@implementation ChoosePeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ChineseStringOrENFun(@"添加健身伙伴", @"添加健身伙伴");
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-70, 40)];
    searchBar.delegate = self;
    searchBar.backgroundColor = UIColor.blackColor;
    [self.view addSubview:searchBar];
    for (UIView *view in searchBar.subviews.lastObject.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            // [view removeFromSuperview];
            view.layer.contents = nil;
            break;
        }
    }
    searchBar.backgroundImage = [UIImage imageWithColor:BuddyTableBackColor];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.height.mas_equalTo(40);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-105);
    }];
    
    UIView *bottomview =[[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:bottomview];
    bottomview.backgroundColor = BuddyTableBackColor;
    [bottomview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(140);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    UIButton *searchBtn = [[UIButton alloc] init];
    [self.view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.height.mas_equalTo(40);
        make.left.equalTo(searchBar.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-15);
    }];
    NSString *searchString = ChineseStringOrENFun(@"搜索", @"Search");
    [searchBtn setTitle:searchString forState:UIControlStateHighlighted];
    [searchBtn setTitle:searchString forState:UIControlStateNormal];
    [searchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [searchBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    searchBtn.backgroundColor = UIRGBColor(28, 28, 30, 1);
    searchBtn.layer.cornerRadius = 8;
    searchBtn.clipsToBounds = YES;
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];

    TableHeadview *tableheadview = (TableHeadview *)[[[NSBundle mainBundle] loadNibNamed:@"TableHeadview" owner:self options:nil] lastObject];
    [self.view addSubview:tableheadview];
    [tableheadview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBar.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
    }];
    tableheadview.clipsToBounds = YES;
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableheadview.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.backgroundColor = BuddyTableBackColor;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [self setupRefresh];
    self.tableView.mj_header.backgroundColor = BuddyTableBackColor;
    self.tableView.mj_footer.backgroundColor = BuddyTableBackColor;

    
    UIButton *sumbitBtn = [[UIButton alloc] init];
    [self.view addSubview:sumbitBtn];
    [sumbitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom).offset(10);
        
        make.bottom.equalTo(self.view).offset(-20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(200);
        make.centerX.equalTo(self.view);
    }];
    NSString *submitString = ChineseStringOrENFun(@"确认", @"OK");
    UIImage *backImage = [UIImage imageNamed:@"action_button_bg_green1"];
    [sumbitBtn setTitle:submitString forState:UIControlStateHighlighted];
    [sumbitBtn setTitle:submitString forState:UIControlStateNormal];
    [sumbitBtn setBackgroundImage:backImage forState:UIControlStateHighlighted];
    [sumbitBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [sumbitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [sumbitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [sumbitBtn addTarget:self action:@selector(submittedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self reachHeadData];
    [self getuserData];
}

- (void)submittedBtnClicked{
    NSMutableArray *userIds = [NSMutableArray array];
    for (UserInfo * user in dataArr) {
//        上一级没选中， 本级选中了
        if (user.hasSelect && !user.lastLevelSelect) {
            [userIds addObject:user.id];
        }
    }
    if (userIds.count < 1) {
        [CommonTools showAlertDismissWithContent:@"请选择用户" showWaitTime:0 afterDelay:2 control:self];
        return;
    }
    NSString *userIdsString = [userIds componentsJoinedByString:@","];
    NSDictionary *baddyParams = @{
                           @"event_id": _currentRoom.event_id,
                           @"friend_ids":userIdsString
                       };
    [[AFAppNetAPIClient manager] POST:@"room/invite" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (CheckResponseObject(responseObject)) {
            [CommonTools showAlertDismissWithContent:@"添加成功" showWaitTime:0 afterDelay:1 control:self];
            
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"]  control:self];
        }
       
            
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [CommonTools showNETErrorcontrol:self];
    }];

}


- (void)getuserData{
     
    NSDictionary *baddyParams = @{
                           @"event_id": _currentRoom.event_id,
                       };
    [[AFAppNetAPIClient manager] GET:@"room/user" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        self->hasUserlistReady = YES;
        if (CheckResponseObject(responseObject)) {
            NSArray *userlist = responseObject[@"recordset"];
            if ([userlist isKindOfClass:[NSArray class]]) {
                NSMutableArray *list = [NSMutableArray array];
                for (NSDictionary *dic in userlist) {
                    UserInfo * user = [[UserInfo alloc] initWithJSON:dic];
                    [list addObject:user.id];
                }
                self->lastLevelSelectUsers = list;
            }
            
        }
        if (self->allPeoplelistRequestReady && self->hasUserlistReady) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self->_tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self->hasUserlistReady = YES;
        if (self->allPeoplelistRequestReady && self->hasUserlistReady) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self->_tableView reloadData];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark TableViewDelegate&DataSource



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"AddPeopleTableViewCellString";
    AddPeopleTableViewCell* cell = (AddPeopleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell =  [[[NSBundle mainBundle] loadNibNamed:@"AddPeopleTableViewCell" owner:self options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserInfo *user = dataArr[indexPath.row];
    [cell changeViewWithModel:user];
//    已经选择过的用户， 不让点击
    if (lastLevelSelectUsers && [lastLevelSelectUsers containsObject:user.id]) {
        user.hasSelect = YES;
        user.lastLevelSelect = YES; //上一层就已经选中了
        cell.contentView.userInteractionEnabled = NO;
    }else{
        cell.contentView.userInteractionEnabled = YES;

    }
    __weak AddPeopleTableViewCell *weakcell = cell;
    WeakSelf
    cell.cellBtnClick = ^(UserInfo* clickModel) {
        StrongSelf(wSelf);
        if (clickModel.hasSelect) {
            if (clickModel.hasSelect) {
    //            最多只能选中5个
                int maxselected = (int)(5- self->lastLevelSelectUsers.count);
                NSInteger selectCount = 0;
                for (int index = 0; index < strongSelf->dataArr.count; index++) {
                    UserInfo *indexUser = strongSelf->dataArr[index];
                    if (indexUser.hasSelect) {
                        selectCount++;
                    }
                }
                if (selectCount > maxselected) {
                    NSString * alertTitle = [NSString stringWithFormat:@"最多选%d项",maxselected];
                    [CommonTools showAlertDismissWithContent:alertTitle showWaitTime:0 afterDelay:0.5 control:wSelf];
                    __strong AddPeopleTableViewCell *strongcell = weakcell;
                    clickModel.hasSelect =NO;
                    [strongcell changeViewWithModel:clickModel];
                }
            }
//            其他的 都为不选中

        }
       
    };
    return cell;
}

#pragma mark - 刷新房间数据
- (void) reachHeadData
{
//    [dataArr removeAllObjects];
    _isLoadAllData =NO;
    [self loadDateIsLoadHead:YES];
}

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
//开始进入刷新状态
- (void)headerRereshing
{
    //下拉刷新，先还原上拉“已加载全部数据”的状态
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.tableView.mj_footer resetNoMoreData];
    [self reachHeadData];
}


//下拉刷新


- (void)loadDateIsLoadHead:(BOOL)isLoadHead
{
    if (!isLoading) {
        isLoading = YES;
        [requestTask cancel];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
        NSString *search = _searchString?_searchString:@"";
        int size = 20;
        int page = 1;
        if (!isLoadHead) {
//            加载更多
            page = _pageCount+1;
        }
        NSDictionary *baddyParams = @{
                               @"kw": search,
                               @"page": [NSString stringWithFormat:@"%d",page],
                               @"row": [NSString stringWithFormat:@"%d",size]
                           };
        
        [manager GET:@"friends" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            self->allPeoplelistRequestReady = YES;
            if (self->allPeoplelistRequestReady && self->hasUserlistReady) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            if (responseObject && responseObject[@"recordset"] ) {
                NSArray *dataArray = responseObject[@"recordset"][@"rows"];
                if (dataArray.count < size) {
                    self->_isLoadAllData = YES;
                }
                if (isLoadHead) {
                    self->_pageCount = 1;
                }
                else
                {
                    self->_pageCount =self->_pageCount+1;
                }
                if (isLoadHead) {
                    self->dataArr = [[NSMutableArray alloc] init];
                }
                for (int i = 0; i < [dataArray count]; i++) {
                    UserInfo *user = [[UserInfo alloc] initWithJSON: dataArray[i]];
                    [self->dataArr addObject: user];
                }
                
                if (isLoadHead) {
                    [self.tableView.mj_header endRefreshing];
                }
                else
                {
                    [self loadNextPageData];
                }
                if (self->allPeoplelistRequestReady && self->hasUserlistReady) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self->_tableView reloadData];
                }
            }
            self->isLoading = NO;
          
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            self->allPeoplelistRequestReady = YES;
            if (self->allPeoplelistRequestReady && self->hasUserlistReady) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }];
    }
    else
    {
    }
 
}

//上拉加载更多
- (void)loadMore
{
    if (!_isLoadAllData) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadDateIsLoadHead:NO];
    }
    else
    {
        [self loadNextPageData];
    }
}

- (void)footerRereshing
{
    [self loadMore];
}

-(void)loadNextPageData{

    [self.tableView.mj_footer endRefreshing];
    if (_isLoadAllData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}

- (void)searchBtnClick{
    _searchString = searchBar.text;
    [self headerRereshing];
    [self.view endEditing:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
//    输入文字改变
    _searchString = searchBar.text;
    [self.tableView.mj_footer resetNoMoreData];
    [self reachHeadData];;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _searchString = searchBar.text;
    [self.tableView.mj_footer resetNoMoreData];
    [self reachHeadData];
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}


@end

