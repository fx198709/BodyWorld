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

@interface TrainingInviteViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@end

@implementation TrainingInviteViewController{
    NSMutableArray *dataArr;
    NSMutableArray *selectedItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView *topFlowImg = [[UIImageView alloc] init];
    topFlowImg.image = [UIImage imageNamed:@"buddy_flow3"];
    [self.view addSubview:topFlowImg];
    [topFlowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(53);
    }];
    
    UIButton *randomBtn = [[UIButton alloc] init];
    [randomBtn setTitle:@"Random matching" forState:UIControlStateNormal];
    randomBtn.backgroundColor = UIColor.darkGrayColor;
    [randomBtn.layer setMasksToBounds:YES];
    [randomBtn.layer setCornerRadius:10];
    [self.view addSubview:randomBtn];
    
    UIButton *inviteBtn = [[UIButton alloc] init];
    [inviteBtn setTitle:@"invite friends" forState:UIControlStateNormal];
    inviteBtn.backgroundColor = [UIColor colorWithRed:73.0/255.0 green:146.0/255.0 blue:96.0/255.0 alpha:1];
    [inviteBtn.layer setMasksToBounds:YES];
    [inviteBtn.layer setCornerRadius:10];
    [self.view addSubview:inviteBtn];
    
    [randomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topFlowImg.mas_bottom).offset(50);
        make.left.equalTo(topFlowImg);
        make.right.equalTo(inviteBtn.mas_left).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(randomBtn);
        make.right.equalTo(topFlowImg);
        make.height.mas_equalTo(40);
        make.width.equalTo(randomBtn);
    }];
    [inviteBtn addTarget:self action:@selector(inviteStart) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..." attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = UIColor.blackColor;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self refreshData];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(UITableView*)tableView{
    
    if (_tableView==nil) {
        CGRect frame =CGRectMake(0, 200, kScreenWidth, self.view.bounds.size.height - 200);
        _tableView=[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setEditing:YES animated:YES];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
    
}
#pragma mark TableViewDelegate&DataSource

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UserInfo *user = dataArr[indexPath.row];
    cell.textLabel.text = user.nickname;
    cell.textLabel.textColor = UIColor.blueColor;
    cell.backgroundColor = UIColor.blackColor;
    
    UIView *view_bg = [[UIView alloc] init];
    view_bg.backgroundColor = UIColor.blackColor;
    cell.selectedBackgroundView = view_bg;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self updateDataWithTableview:tableView];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self updateDataWithTableview:tableView];
}

- (void)updateDataWithTableview:(UITableView *)tableView {
    NSArray *indexpaths = [tableView indexPathsForSelectedRows];
    selectedItems = [NSMutableArray new];
    for (NSIndexPath *indexpath in indexpaths) {
        UserInfo *userInfo = dataArr[indexpath.row];
        [selectedItems addObject:userInfo.id];
    }
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
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%llu", recordTime];
    return timeLocal;
}

#pragma mark - 刷新房间数据
- (void) refreshData
{
    [dataArr removeAllObjects];
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSLog(@"initroom userToken ---- %@", userToken);

    NSString *strUrl = [NSString stringWithFormat:@"%@user/other", FITAPI_HTTPS_PREFIX];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSDictionary *baddyParams = @{
                           @"page": @"1",
                           @"row": @"20",
                       };
    [manager GET:strUrl parameters:baddyParams headers:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject ---- %@", responseObject);
        long total =  [responseObject[@"recordset"][@"total"] longValue];
        if(total > 0){
            NSArray *array = responseObject[@"recordset"][@"rows"];
            self->dataArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < [array count]; i++) {
                UserInfo *user = [[UserInfo alloc] initWithJSON: array[i]];
                [self->dataArr addObject: user];
            }
        }
        [self.tableView reloadData];
        if ([self.tableView.refreshControl isRefreshing]) {
            [self.tableView.refreshControl endRefreshing];
        }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"failure ---- %@", error);
    }];
}


- (void) createBattleRoom
{
    NSString *startTime = [self getTimeStamp];
    NSString *friendIds = [[NSString alloc] init];
    
    for(int i = 0; i < selectedItems.count; i++){
        friendIds = [friendIds stringByAppendingString: selectedItems[i]];
        friendIds = [friendIds stringByAppendingString:@","];
    }
    friendIds = [friendIds substringToIndex:friendIds.length - 1];
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSLog(@"userToken > %@", userToken);
    NSLog(@"friendIds > %@", friendIds);
    NSLog(@"startTime > %@", startTime);


    NSString *strUrl = [NSString stringWithFormat:@"%@room/battle", FITAPI_HTTPS_PREFIX];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSDictionary *baddyParams = @{
                           @"start_time": startTime,
                           @"friend_ids": friendIds,
                           @"course_id": _selectCourse.course_id,
                           @"name": @"arms training",
                           @"allow_watch": [NSNumber numberWithBool:1]
                       };
    [manager POST:strUrl parameters:baddyParams headers:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject ---- %@", responseObject);
        NSDictionary *dict = responseObject[@"recordset"];
        NSString *eventId = dict[@"event_id"];
        NSLog(@"eventId ----  %@", eventId);

        NSString * nickName = @"123";
        [ConfigManager sharedInstance].eventId = eventId;
        [ConfigManager sharedInstance].nickName = nickName;
        [[ConfigManager sharedInstance] saveConfig];

        NSDictionary *codeDict = @{@"eid":eventId, @"name":nickName};
        RoomVC *roomVC = [[RoomVC alloc] initWith:codeDict];
        [self.navigationController pushViewController:roomVC animated:YES];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"failure ---- %@", error);
    }];
}

- (void) inviteStart{
    NSLog(@"inviteStart ----  ");
    [self createBattleRoom];
    
    
//    NSString * eventId = @"123";
//    NSString * nickName = @"123";
//    [ConfigManager sharedInstance].eventId = eventId;
//    [ConfigManager sharedInstance].nickName = nickName;
//    [[ConfigManager sharedInstance] saveConfig];
//
//    NSDictionary *codeDict = @{@"eid":eventId, @"name":nickName};
//    RoomVC *roomVC = [[RoomVC alloc] initWith:codeDict];
//    [self.navigationController pushViewController:roomVC animated:YES];
}

@end
