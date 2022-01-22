//
//  FriendInfoViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/29.
//

#import "FriendInfoViewController.h"
#import "FriendRoomCell.h"
#import "FriendRoomPageInfo.h"
#import "CourseRoomTableViewCell.h"

@interface FriendInfoViewController ()
<UITableViewDelegate, UITableViewDataSource>{
    NSTimer *cellTimer;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cityImg;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UIButton *addbtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addbtnW;

@property (nonatomic, strong) UserInfo *user;
@property (weak, nonatomic) IBOutlet UILabel *title2Label;

@property (weak, nonatomic) IBOutlet UILabel *title1Label;

@end

@implementation FriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ChineseStringOrENFun(@"个人中心", @"Person Dashboard");
    _descView.layer.cornerRadius = 5;
    _descView.clipsToBounds = YES;
    _title1Label.text = ChineseStringOrENFun(@"个人简介", @"Person introduce");
    _title2Label.text = ChineseStringOrENFun(@"已预约课程", @"Person course");
    _title1Label.textColor = UIColor.whiteColor;
    _title2Label.textColor = UIColor.whiteColor;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserInfoFromSever];
    [cellTimer invalidate];
    cellTimer = nil;
    cellTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadControlsCellAction) userInfo:nil repeats:YES];
}

 

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [cellTimer invalidate];
    cellTimer = nil;
    
}

- (void)reloadControlsCellAction{
    [self.tableView reloadData];
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
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseRoomTableViewCell *cell =  [[[NSBundle mainBundle] loadNibNamed:@"CourseRoomTableViewCell" owner:self options:nil] lastObject];
    Room *room = self.dataList[indexPath.row];

    [cell changeDataWithRoom:room];
    cell.joinBtn.tag = indexPath.row+100;
    [cell.joinBtn addTarget:self action:@selector(joinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row != self.dataList.count -1) {
        cell.lineview.hidden = NO;
    }else{
        cell.lineview.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

#pragma mark cell事件的处理
- (void)joinBtnClicked:(UIButton*)btn{
    int tag = (int)btn.tag - 100;
    if (self.dataList.count > tag) {
        Room *selectedRoom = [self.dataList objectAtIndex:tag];
        int state = [selectedRoom reachRoomDealState];
        if (state == 1 || state == 2) {
            [self realjoinBtnClicked:btn];
        }else{
            [[APPObjOnce sharedAppOnce] joinRoom:selectedRoom withInvc:self];
        }
    }
    NSLog(@"Join");
}

- (void)realjoinBtnClicked:(UIButton *) recognizer{
    //    这边需要正在进行中的，才能开始，需要判断状态
    //    做测试用
    
    Room *room = [self.dataList objectAtIndex: recognizer.tag-100];
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
     UIViewController *parentControl = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (room.is_join) {
        //        取消选中
        
        NSDictionary *baddyParams = @{
            @"event_id": room.event_id,
            @"friend_id":[APPObjOnce sharedAppOnce].currentUser.id
        };
        [manager POST:@"room/kickout" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (CheckResponseObject(responseObject)) {
                [CommonTools showAlertDismissWithContent:ActionSuccssString control:self];
                if ([parentControl respondsToSelector:@selector(MJRefreshData)]) {
                    [parentControl performSelector:@selector(MJRefreshData)];
                }
                
            }else{
                [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"] control:self];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [CommonTools showNETErrorcontrol:self];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
    }else{
        NSDictionary *baddyParams = @{
            @"event_id": room.event_id,
            @"is_join":[NSNumber numberWithBool:!room.is_join]
        };
        [manager POST:@"practise/join" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (CheckResponseObject(responseObject)) {
                [CommonTools showAlertDismissWithContent:ActionSuccssString control:self];
                if ([parentControl respondsToSelector:@selector(MJRefreshData)]) {
                    [parentControl performSelector:@selector(MJRefreshData)];
                }
            }else{
                [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"] control:self];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [CommonTools showNETErrorcontrol:self];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
    }
    
}


 


@end
