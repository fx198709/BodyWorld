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
    
}
@property(nonatomic,strong)UITableView*tableView;


@end

@implementation ChoosePeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    searchBar.delegate = self;
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.showsCancelButton = YES;
    searchBar.backgroundColor = UIColor.blackColor;
    [self.view addSubview:searchBar];
    for (UIView *view in searchBar.subviews.lastObject.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            // [view removeFromSuperview];
            view.layer.contents = nil;
            break;
        }
    }
    searchBar.showsCancelButton = YES;
    searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.height.mas_equalTo(40);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
    }];
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
        make.bottom.equalTo(self.view);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.backgroundColor = BuddyTableBackColor;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh];
    self.tableView.mj_header.backgroundColor = BuddyTableBackColor;
    self.tableView.mj_footer.backgroundColor = BuddyTableBackColor;

    [self reachHeadData];
    // Do any additional setup after loading the view.
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
    UserInfo *user = dataArr[indexPath.row];
    [cell changeViewWithModel:user];
    __weak AddPeopleTableViewCell *weakcell = cell;
    WeakSelf
    cell.cellBtnClick = ^(UserInfo* clickModel) {
        if (clickModel.hasSelect) {
//            最多只能选中5个
            NSInteger selectCount = 0;
            StrongSelf(wSelf)
            for (int index = 0; index < strongSelf->dataArr.count; index++) {
                UserInfo *indexUser = strongSelf->dataArr[index];
                if (indexUser.hasSelect) {
                    selectCount++;
                }
            }
            if (selectCount > 5) {
                [CommonTools showAlertDismissWithContent:@"最多选5项" showWaitTime:0 afterDelay:0.5 control:wSelf];
                __strong AddPeopleTableViewCell *strongcell = weakcell;
                clickModel.hasSelect =NO;
                [strongcell changeViewWithModel:clickModel];
            }
        }
       
    };
    return cell;
}

#pragma mark - 刷新房间数据
- (void) reachHeadData
{
    [dataArr removeAllObjects];
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
    [self.tableView.mj_footer resetNoMoreData];
    [self reachHeadData];
}


//下拉刷新


- (void)loadDateIsLoadHead:(BOOL)isLoadHead
{
    if (!isLoading) {
        isLoading = YES;
        [requestTask cancel];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
        
        [manager GET:@"user/other" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
            

                [self->_tableView reloadData];
            }
            self->isLoading = NO;
          
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _searchString = searchBar.text;
    [self headerRereshing];
    [self.view endEditing:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
}


@end

