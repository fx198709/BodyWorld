//
//  AddFriendViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import "AddFriendViewController.h"
#import "FriendCell.h"
#import "AddFriendPageInfo.h"

@interface AddFriendViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<Friend *> *dataList;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isRequesting;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ChineseStringOrENFun(@"新的好友", @"New friend");
    [self initView];
    self.dataList = [NSMutableArray array];
    [self resetData];
    [self MJRefreshData];
}


- (void)initView {
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    Class cellClass = [FriendCell class];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
    [self addMJRefreshToTable:self.tableView];
}

#pragma mark - refresh

- (void)MJRefreshData {
    [self resetData];
    [self getFriendListFromServer:YES];
}

- (void)MJRequestMoreData {
    [self getFriendListFromServer:NO];
}

- (void)resetData {
    self.currentPage = 0;
    self.isFinished = NO;
    [self.dataList removeAllObjects];
}


#pragma mark - server

- (void)getFriendListFromServer:(BOOL)isRefresh {
    if (self.isRequesting || self.isFinished) {
        return;
    }
    
    self.isRequesting = YES;
    NSInteger nextPage = self.currentPage + 1;
    
    NSString *url = @"friend/apply_list";
    int perCount = 10;
    NSDictionary *param = @{@"row":IntToString(perCount), @"page":IntToString(nextPage)};
    [[AFAppNetAPIClient manager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        self.isRequesting = NO;
        
        NSLog(@"====respong:%@", responseObject);
        NSDictionary *result = [responseObject objectForKey:@"recordset"];
        NSError *error;
        AddFriendPageInfo *pageInfo = [[AddFriendPageInfo alloc] initWithDictionary:result error:&error];
        if (error == nil) {
            if (isRefresh) {
                self.dataList = [NSMutableArray arrayWithArray:pageInfo.rows];
            } else {
                [self.dataList addObjectsFromArray:pageInfo.rows];
            }
            if (pageInfo.rows.count < perCount) {
                self.isFinished = YES;
            }
            self.currentPage += 1;
            [self.tableView reloadData];
        } else {
            [MTHUD showDurationNoticeHUD:error.localizedDescription];
        }
        [self finishMJRefresh:self.tableView isFinished:self.isFinished];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.isRequesting = NO;
        [self finishMJRefresh:self.tableView isFinished:self.isFinished];
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

//添加好友
- (void)addUserToServer:(Friend *)friend {
    NSDictionary *param = @{@"friend_id": StringWithDefaultValue(friend.friend_id, @"")};
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"friend/agree" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        if ([responseObject objectForKey:@"recordset"]) {
            friend.status = FriendStatus_added;
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showChangeFailedError:error];
    }];
}


#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendCell class])];
    Friend *friend = [self.dataList objectAtIndex:indexPath.row];
    NSString *url = [FITAPI_HTTPS_ROOT stringByAppendingString:friend.avatar];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url]
                    placeholderImage:[UIImage imageNamed:@"choose_course_foot_logo3_unselected"]];
    cell.titleLabel.text = friend.friend_name;
    cell.addStatus = friend.status;
    cell.isAdd = YES;
    cell.callBack = ^{
        [self addUserToServer:friend];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
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
