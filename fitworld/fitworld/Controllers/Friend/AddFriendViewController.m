//
//  AddFriendViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import "AddFriendViewController.h"
#import "FriendCell.h"

@interface AddFriendViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<UserInfo *> *dataList;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isRequesting;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ChineseStringOrENFun(@"好友", @"Friends");
    [self initView];
    [self getDataListFromServer:YES];
}


- (void)initView {
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    Class cellClass = [FriendCell class];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
    [self addMJRefreshToTable:self.tableView];
}

#pragma mark - server

- (void)getDataListFromServer:(BOOL)isRefresh {
    if (self.isFinished || self.isRequesting) {
        return;
    }
    
    self.isRequesting = YES;
    NSInteger nextPage = self.currentPage + 1;
    
    NSString *url = @"friend/apply_list";
    NSDictionary *param = @{@"row":@"10", @"page":IntToString(nextPage)};
    [[AFAppNetAPIClient manager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        self.isRequesting = NO;
        [self finishMJRefresh:self.tableView isFinished:self.isFinished];

        NSLog(@"====respong:%@", responseObject);
        NSArray *result = [responseObject objectForKey:@"recordset"];
        NSError *error;
        NSArray<UserInfo *> *resultList = [UserInfo arrayOfModelsFromDictionaries:result error:&error];
        if (error == nil) {
            if (isRefresh) {
                self.dataList = [NSMutableArray arrayWithArray:resultList];
            } else {
                [self.dataList addObjectsFromArray:resultList];
            }
            self.currentPage += 1;
            [self.tableView reloadData];
        } else {
            [MTHUD showDurationNoticeHUD:error.localizedDescription];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.isRequesting = NO;
        [self finishMJRefresh:self.tableView isFinished:self.isFinished];
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
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
    UserInfo *friend = [self.dataList objectAtIndex:indexPath.row];
    NSString *url = [FITAPI_HTTPS_ROOT stringByAppendingString:friend.avatar];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url]
                    placeholderImage:[UIImage imageNamed:@"choose_course_foot_logo3_unselected"]];
    cell.titleLabel.text = friend.nickname;
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
