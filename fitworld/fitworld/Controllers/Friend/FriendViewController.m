//
//  FriendViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import "FriendViewController.h"
#import "FriendCell.h"
#import "FriendPageInfo.h"
#import "Friend.h"

@interface FriendViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UILabel *addTitleLabel;
@property (nonatomic, weak) IBOutlet UIView *addPeopleView;


@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ChineseStringOrENFun(@"好友", @"Friends");
}

- (void)initView {
    [super initView];
    self.addTitleLabel.text = ChineseStringOrENFun(@"新的朋友", @"New friend");
}

- (Class)cellClass {
    return [FriendCell class];
}

#pragma mark - server

- (void)getDataListFromServer:(BOOL)isRefresh {
    if (self.isFinished || self.isRequesting) {
        return;
    }
    self.isRequesting = YES;
    NSInteger nextPage = self.currentPage + 1;
    int perCount = 10;

    NSDictionary *param = @{@"row":IntToString(perCount), @"page":IntToString(nextPage)};
    [[AFAppNetAPIClient manager] GET:@"friends" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
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

//删除好友
- (void)deleteUserToServer:(UserInfo *)friend {
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
    cell.backgroundColor = BgGrayColor;
    cell.cellType = FriendCell_delete;
    cell.btnCallBack = ^{
        [self deleteUserToServer:friend];
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
