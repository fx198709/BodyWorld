//
//  FriendInfoViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/29.
//

#import "FriendInfoViewController.h"
#import "FriendRoomCell.h"
#import "FriendRoomPageInfo.h"


@interface FriendInfoViewController ()
<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cityImg;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *addbtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addbtnW;

@property (nonatomic, strong) UserInfo *user;


@end

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ChineseStringOrENFun(@"个人中心", @"Person Center");
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserInfoFromSever];
}

- (void)initView {
    [super initView];
    [self.headImg cornerHalf];
    [self.addbtn cornerHalf];
    [self.addbtn setTitle:ChineseStringOrENFun(@"加好友", @"Add friends") forState:UIControlStateNormal];
}


- (Class)cellClass {
    return [FriendRoomCell class];
}

- (void)loadUserData {
    if (self.user.is_friend) {
        [self hideAddBtn];
    }
    self.nameLabel.text = self.user.nickname;
    NSString *avatarUrl = [FITAPI_HTTPS_ROOT stringByAppendingString:self.user.avatar];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:avatarUrl]
                    placeholderImage:[UIImage imageNamed:@"choose_course_foot_logo3_unselected"]];
    [self.cityImg sd_setImageWithURL:[NSURL URLWithString:self.user.country_icon]];
    self.cityLabel.text = [NSString stringWithFormat:@"%@,%@", self.user.city, self.user.country];
    self.descLabel.text = self.user.introduction;
}

- (void)hideAddBtn {
    self.addbtn.hidden = YES;
    self.addbtnW.constant = 0;
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - server

- (void)getUserInfoFromSever {
    NSDictionary *param = @{@"id":self.userId};
    [[AFAppNetAPIClient manager] GET:@"user" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSLog(@"====respong:%@", responseObject);
        NSDictionary *result = [responseObject objectForKey:@"recordset"];
        NSError *error;
        self.user = [[UserInfo alloc] initWithDictionary:result error:&error];
        [self loadUserData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

- (void)getDataListFromServer:(BOOL)isRefresh {
    if (self.isFinished || self.isRequesting) {
        return;
    }
    self.isRequesting = YES;
    NSInteger nextPage = self.currentPage + 1;
    int perCount = 10;
    
    NSDictionary *param = @{@"row":IntToString(perCount), @"page":IntToString(nextPage), @"user_id":self.userId};
    [[AFAppNetAPIClient manager] GET:@"user_room" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        self.isRequesting = NO;
        
        NSLog(@"====respong:%@", responseObject);
        NSDictionary *result = [responseObject objectForKey:@"recordset"];
        NSError *error;
        FriendRoomPageInfo *pageInfo = [[FriendRoomPageInfo alloc] initWithDictionary:result error:&error];
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
            self.tableView.hidden = self.dataList.count == 0;
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


//预约课程
- (void)joinRoomToServer:(Room *)room {
    NSDictionary *param = @{@"event_id": StringWithDefaultValue(room.id, @""), @"is_join" : @"true"};
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"room/join" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSString *result = [responseObject objectForKey:@"recordset"];
        if ([result isEqualToString:@"success"]) {
            room.is_join = YES;
            [self.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showChangeFailedError:error];
    }];
}


//添加好友
- (IBAction)addFriend {
    NSDictionary *param = @{@"friend_id": StringWithDefaultValue(self.user.id, @"")};
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"friend/require" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSString *result = [responseObject objectForKey:@"recordset"];
        if ([result isEqualToString:@"success"]) {
            [self hideAddBtn];
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
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendRoomCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Room *room = [self.dataList objectAtIndex:indexPath.row];
    [cell loadRoom:room];
    cell.btnCallBack = ^{
        [self joinRoomToServer:room];
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
