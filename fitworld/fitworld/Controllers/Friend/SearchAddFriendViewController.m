//
//  SearchAddFriendViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/29.
//

#import "SearchAddFriendViewController.h"
#import "FriendCell.h"
#import "FriendPageInfo.h"
#import "UserInfo.h"
#import "UIImage+Extension.h"

@interface SearchAddFriendViewController ()
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UIView *searchView;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIButton *clearBtn;
@property (nonatomic, weak) IBOutlet UIButton *searchBtn;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<UserInfo *> *dataList;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isRequesting;

@end

@implementation SearchAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ChineseStringOrENFun(@"添加好友", @"Add Friends");
    [self initView];
    self.dataList = [NSMutableArray array];
    [self resetData];
    [self MJRefreshData];
}



- (void)initView {
    [self.searchView cornerWithRadius:6];
    /** 设置背景色 */
    [UIView setupSearchBar:self.searchBar];
    [self.searchBtn setTitle:ChineseStringOrENFun(@"搜索", @"Search") forState:UIControlStateNormal];
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

#pragma mark - action

- (IBAction)clearSearch:(id)sender {
    self.searchBar.text = nil;
    [self.view endEditing:YES];
}

- (IBAction)search:(id)sender {
    [self getFriendListFromServer:YES];
}

#pragma mark - server

- (void)getFriendListFromServer:(BOOL)isRefresh {
    if (self.isFinished || self.isRequesting) {
        return;
    }
    self.isRequesting = YES;
    NSInteger nextPage = self.currentPage + 1;
    int perCount = 10;
    
    NSString *searchString = self.searchBar.text;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"row":IntToString(perCount), @"page":IntToString(nextPage)}];
    if (![NSString isNullString:searchString]) {
        [param setObject:searchString forKey:@"kw"];
    }
    
    NSLog(@"====request:%@", param);
    [[AFAppNetAPIClient manager] GET:@"stranger" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        self.isRequesting = NO;
        
        NSLog(@"====respong:%@", responseObject);
        NSDictionary *result = [responseObject objectForKey:@"recordset"];
        NSError *error;
        FriendPageInfo *pageInfo = [[FriendPageInfo alloc] initWithDictionary:result error:&error];
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
- (void)addUserToServer:(UserInfo *)friend {
    NSDictionary *param = @{@"friend_id": StringWithDefaultValue(friend.id, @"")};
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"friend/delete" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSString *result = [responseObject objectForKey:@"recordset"];
        if ([result isEqualToString:@"success"]) {
            [self.dataList removeObject:friend];
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showChangeFailedError:error];
    }];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self resetData];
    [self getFriendListFromServer:YES];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UserInfo *friend = [self.dataList objectAtIndex:indexPath.row];
    NSString *url = [FITAPI_HTTPS_ROOT stringByAppendingString:friend.avatar];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url]
                    placeholderImage:[UIImage imageNamed:@"choose_course_foot_logo3_unselected"]];
    cell.titleLabel.text = friend.nickname;
    cell.line.hidden = indexPath.row == self.dataList.count - 1;
    cell.cellType = FriendCell_add;
    cell.btnCallBack = ^{
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
