//
//  MessageListViewController.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/4.
//

#import "MessageListViewController.h"
#import "MessageListTableViewCell.h"
#import "MessageListModel.h"
#import "MessageDetailViewController.h"

@interface MessageListViewController (){
    BOOL isLoading;
    int _pageCount;
    BOOL _isLoadAllData; //是否加载所有的数据，每次刷新的时候，都设置成no， 接口返回的数据小于需要的数量时，设置成yes
    NSURLSessionDataTask *requestTask;//请求用的task
    NSMutableArray *dataArr;
    MessageListTableViewCell * heightCell;
}

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ChineseStringOrENFun(@"消息", @"MESSAGE");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor redColor];
    self.messageTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _messageTableview.backgroundColor = UIColor.blackColor;
    [self.view addSubview:self.messageTableview];
    [self.messageTableview registerNib:[UINib nibWithNibName:NSStringFromClass([MessageListTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"MessageListTableViewCellString"];

    self.messageTableview.delegate = self;
    self.messageTableview.dataSource = self;
    _messageTableview.separatorStyle= UITableViewCellSeparatorStyleNone;
    [self.messageTableview mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.with.top.equalTo(self.view);
      make.size.equalTo(self.view);
    }];
    [self setupRefresh];
    [_messageTableview.mj_header beginRefreshing];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListModel *model = dataArr[indexPath.row];
//    if (model.rowHeight > 2) {
//        return model.rowHeight;
//    }
    if (heightCell == nil) {
     heightCell = [[[NSBundle mainBundle] loadNibNamed:@"MessageListTableViewCell" owner:self options:nil] lastObject];
    }
    
    [heightCell changeDataWithModel:model];
    CGSize heightSize = [heightCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    model.rowHeight =heightSize.height+1;
    return heightSize.height+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageListTableViewCell* cell = (MessageListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"MessageListTableViewCellString"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    MessageListModel *user = dataArr[indexPath.row];
    [cell changeDataWithModel:user];
    cell.contentView.backgroundColor = BgGrayColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (dataArr.count > indexPath.row) {
        MessageListModel *message = dataArr[indexPath.row];
        MessageDetailViewController * vc = [[MessageDetailViewController alloc] initWithNibName:@"MessageDetailViewController" bundle:nil];
        vc.messageID = message.id;
        message.is_read = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [tableView reloadData];
    }
}


#pragma mark - 刷新房间数据
- (void) reachHeadData
{
    dataArr = [NSMutableArray array];
    _isLoadAllData =NO;
    [self loadDateIsLoadHead:YES];
}


 

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.messageTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.messageTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    int bottom =[CommonTools safeAreaInsets].bottom;
    self.messageTableview.mj_footer.ignoredScrollViewContentInsetBottom = bottom;
//    self.messageTableview.autoHideMjFooter = YES;
}
//开始进入刷新状态
- (void)headerRereshing
{
    //下拉刷新，先还原上拉“已加载全部数据”的状态
    [self.messageTableview.mj_footer resetNoMoreData];
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
        int size = 20;
        int page = 1;
        if (!isLoadHead) {
//            加载更多
            page = _pageCount+1;
        }
        NSDictionary *baddyParams = @{
                               @"page": [NSString stringWithFormat:@"%d",page],
                               @"row": [NSString stringWithFormat:@"%d",size]
                           };
        
        requestTask = [manager GET:@"user_msg" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
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
                    MessageListModel *user = [[MessageListModel alloc] initWithJSON: dataArray[i]];
                    [self->dataArr addObject: user];
                }
                
                if (isLoadHead) {
                    [self.messageTableview.mj_header endRefreshing];
                }
                [self loadNextPageData];
                [self.messageTableview reloadData];
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

    [self.messageTableview.mj_footer endRefreshing];
    if (_isLoadAllData) {
        [self.messageTableview.mj_footer endRefreshingWithNoMoreData];
    }
    
}


@end
