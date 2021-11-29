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

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ChineseStringOrENFun(@"新的好友", @"New friend");
}


- (Class)cellClass {
    return [FriendCell class];
}


#pragma mark - server

- (void)getDataListFromServer:(BOOL)isRefresh {
    if (self.isRequesting || self.isFinished) {
        return;
    }
    
    self.isRequesting = YES;
    NSInteger nextPage = self.currentPage + 1;
    
    NSString *url = @"friend/apply_list";
    int perCount = 10;
    NSDictionary *param = @{@"row":IntToString(perCount), @"page":IntToString(nextPage)};
    [[AFAppNetAPIClient manager] GET:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        self.isRequesting = NO;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Friend *friend = [self.dataList objectAtIndex:indexPath.row];
    NSString *url = [FITAPI_HTTPS_ROOT stringByAppendingString:friend.avatar];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:url]
                    placeholderImage:[UIImage imageNamed:@"choose_course_foot_logo3_unselected"]];
    cell.titleLabel.text = friend.friend_name;
    cell.addStatus = friend.status;
    cell.line.hidden = indexPath.row == self.dataList.count - 1;
    cell.cellType = friend.status == FriendStatus_wait ? FriendCell_agree : FriendCell_agreeed;
    cell.btnCallBack = ^{
        [self addUserToServer:friend];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
