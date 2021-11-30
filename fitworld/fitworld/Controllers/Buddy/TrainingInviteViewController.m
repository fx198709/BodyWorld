//
//  YJListViewController.m
//  YJPageController
//

#import "TrainingViewController.h"
#import "YJPageControlView.h"
#import "UIDeps.h"
#import "AFNetworking.h"
#import "FITAPI.h"
#import "UserInfo.h"
#import <math.h>
#import "TrainingInviteViewController.h"
#import "ConfigManager.h"
#import "RoomVC.h"
#import "TableHeadview.h"
#import "SelectClassHeadview.h"
#import "TableSearchView.h"
#import "AddPeopleTableViewCell.h"
#import "CreateCourseSuccessViewController.h"

@interface TrainingInviteViewController ()<UITableViewDelegate, UITableViewDataSource,TableSearchViewDelegate>{
    BOOL isLoading;
    int _pageCount;
    BOOL _isLoadAllData; //是否加载所有的数据，每次刷新的时候，都设置成no， 接口返回的数据小于需要的数量时，设置成yes
    int  _orderbyType; //排序类型 0最新创建，1最近执行
    NSURLSessionDataTask *requestTask;//请求用的task
    NSMutableArray *dataArr;
    NSMutableArray *selectedItems;
}
@property(nonatomic,strong)UITableView*tableView;
@end

@implementation TrainingInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    
    self.title = ChineseStringOrENFun(@"邀请朋友", @"INVITE FRIENDS");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];

    SelectClassHeadview *topFlowImg = (SelectClassHeadview *)[[[NSBundle mainBundle] loadNibNamed:@"SelectClassHeadview" owner:self options:nil] lastObject];
    [self.view addSubview:topFlowImg];
    [topFlowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(80);
    }];
    [topFlowImg changeStep:3];
    TableHeadview *tableheadview = (TableHeadview *)[[[NSBundle mainBundle] loadNibNamed:@"TableHeadview" owner:self options:nil] lastObject];
    [self.view addSubview:tableheadview];
    [tableheadview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topFlowImg.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    TableSearchView *tableSearchView = (TableSearchView *)[[[NSBundle mainBundle] loadNibNamed:@"TableSearchView" owner:self options:nil] lastObject];
    [self.view addSubview:tableSearchView];
    tableSearchView.searchviewDelegate = self;
    [tableSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableheadview.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(120);
    }];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableSearchView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view).offset(-40);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.backgroundColor = BuddyTableBackColor;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh];
    
    UIView *btnview = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:btnview];
    [btnview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(70);

    }];
    btnview.backgroundColor = BuddyTableBackColor;

    UIButton *submittedBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 5, ScreenWidth-40*2, 40)];
//    48 109  72
    [btnview addSubview:submittedBtn];
    submittedBtn.backgroundColor = UIRGBColor(48, 109, 72, 1);
    [submittedBtn addTarget:self action:@selector(submittedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSString *title = ChineseStringOrENFun(@"确认", @"OK");
    [submittedBtn setTitle:title forState:UIControlStateHighlighted];
    [submittedBtn setTitle:title forState:UIControlStateNormal];
    [submittedBtn setTitleColor: UIColor.whiteColor forState:UIControlStateNormal];
    [submittedBtn setTitleColor: UIColor.whiteColor forState:UIControlStateHighlighted];
    submittedBtn.layer.cornerRadius = 20;
    [self reachHeadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)submittedBtnClick{
    NSString *startTime = [self getTimeStamp];
    NSString *friendIds = @"";
    NSMutableArray *frendIdArray = [NSMutableArray array];
    for(int i = 0; i < dataArr.count; i++){
        UserInfo *user = [dataArr objectAtIndex:i];
        if (user.hasSelect) {
            [frendIdArray addObject:user.id];
        }
        
    }
    if (frendIdArray.count > 0) {
        friendIds = [frendIdArray componentsJoinedByString:@","];
    }
    NSString *allowWatch = _allowOtherType == 1?@"false":@"true";
    NSDictionary *baddyParams = @{
                           @"start_time": startTime,
                           @"friend_ids": friendIds,
                           @"course_id": _selectCourse.course_id,
                           @"name": _selectCourse.name,
                           @"allow_watch": allowWatch
                       };
    

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFAppNetAPIClient *manager = [AFAppNetAPIClient sharedClient];

    [manager POST:@"room/battle" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"status"] longValue] == 0) {
            NSLog(@"responseObject ---- %@", responseObject);
            NSDictionary *dict = responseObject[@"recordset"];
            NSString *eventId = dict[@"event_id"];
            NSLog(@"eventId ----  %@", eventId);

            CreateCourseSuccessViewController * successVC = [[CreateCourseSuccessViewController alloc] initWithNibName:@"CreateCourseSuccessViewController" bundle:nil];
            successVC.event_id = eventId;
            [self.navigationController pushViewController:successVC animated:YES];
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error %@",error.description);
    }];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectBtn{
    NSLog(@"select");
    	
   
}

- (NSString *) getTimeStamp{
    NSString *timeLocal = @"";
    UInt64 recordTime = 0;
    if (self.afterminute > 0) {
        recordTime = [[NSDate date] timeIntervalSince1970];
        recordTime = self.afterminute * 60 + recordTime;
    }else{
        recordTime = [self.inselectDate timeIntervalSince1970];
    }
    timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];

    return timeLocal;
}

#pragma mark - 刷新房间数据
- (void) reachHeadData
{
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


- (void)searhBartextChanged:(NSString*)searchString{
    _searchString = searchString;
    [self.tableView.mj_footer resetNoMoreData];
    [self reachHeadData];;
}

- (void)searhBarBtnClicked:(NSString*)searchString{
    _searchString = searchString;
    [self.tableView.mj_footer resetNoMoreData];
    [self reachHeadData];;
    [self.view endEditing:YES];
}
- (void)allowOtherBtnClicked:(NSInteger)otherType{
    _allowOtherType = otherType;
}

@end
