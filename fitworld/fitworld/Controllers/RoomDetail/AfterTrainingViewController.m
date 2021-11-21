//
//  AfterTrainingViewController.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/20.
//

#import "AfterTrainingViewController.h"
#import "Train1TableViewCell.h"
#import "Train2TableViewCell.h"
#import "Train3TableViewCell.h"


@interface AfterTrainingViewController (){
    BOOL reachRoomInfo;
    BOOL reachUserListInfo;
}

@end

@implementation AfterTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = ChineseStringOrENFun(@"祝贺您完成本课程！", @"Congratulations on completing the course!");
    _titleLabel.font = SystemFontOfSize(17);
    _titleLabel.textColor = UIColor.whiteColor;
    
    _timeLabel.text = @"";
    _timeLabel.textColor = LittleTextColor;
    _timeLabel.font =SystemFontOfSize(14);
    
    _successTabelview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _successTabelview.dataSource = self;
    _successTabelview.delegate = self;
    _successTabelview.backgroundColor = UIColor.blackColor;
    [self reachData];
    self.isTapBack = NO;
    // Do any additional setup after loading the view from its nib.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    int dif = 15;
    if (indexPath.row == 0) {
        return 90+dif;
    }else if (indexPath.row == 1) {
        return 60+ self.currentRoom.plan.count * 40+dif;
    }else {
        return 60+ self.userList.count * 50+dif;
    }
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        Train1TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Train1TableViewCell" owner:self options:nil] lastObject];
        [cell changeDateWithRoomInfo:self.currentRoom];
        return cell;
    }else if (indexPath.row == 1) {
        Train2TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Train2TableViewCell" owner:self options:nil] lastObject];
        [cell changeDateWithRoomInfo:self.currentRoom];
        return cell;
    }else if (indexPath.row == 2) {
        Train3TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Train3TableViewCell" owner:self options:nil] lastObject];
        [cell changeDataWithUserList:self.userList];
        WeakSelf
        cell.peopleBtnClick = ^(UserInfo* user) {
            StrongSelf(wSelf);
            [strongSelf addPeopleWithPeopleId:user.id];
        };
//        [cell changeDateWithRoomInfo:self.currentRoom];
        return cell;
    }
    
    UITableViewCell* cell = nil;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)reachData{
    reachRoomInfo = NO;
    reachUserListInfo = NO;
    self.userList = [NSMutableArray array];
    [self reachRoomDetailInfo];
    NSDictionary *baddyParams = @{
                           @"event_id": self.event_id,
                       };
    [[AFAppNetAPIClient manager] GET:@"room/user" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        if (CheckResponseObject(responseObject)) {
            NSArray *userlist = responseObject[@"recordset"];
            if ([userlist isKindOfClass:[NSArray class]]) {
                NSMutableArray *list = [NSMutableArray array];
                for (NSDictionary *dic in userlist) {
//                    不需要把自己放入伙伴中
                    UserInfo * user = [[UserInfo alloc] initWithJSON:dic];
                    if (user.id != [APPObjOnce sharedAppOnce].currentUser.id) {
                        [list addObject:user];
                    }
                }
                self.userList = list;
            }
            
        }
        self->reachUserListInfo =YES;
        [self reloadtable];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self->reachUserListInfo =YES;
        [self reloadtable];
    }];
}

- (void)reloadtable{
    if (reachUserListInfo && reachRoomInfo) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [_successTabelview reloadData];
    }
}

- (void)reachRoomDetailInfo
{
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSString *eventid = self.event_id;
    NSDictionary *baddyParams = @{
                           @"event_id": eventid,
                       };
    [manager GET:@"room/detail" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        if (CheckResponseObject(responseObject)) {
            NSDictionary *roomJson = responseObject[@"recordset"];
            self.currentRoom = [[Room alloc] initWithJSON:roomJson];
            self.currentRoom.event_id = eventid;
        }
        self->reachRoomInfo =YES;
        self.timeLabel.text = ReachYearANDTime(self.currentRoom.end_time);
        [self reloadtable];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self->reachRoomInfo =YES;
        [self reloadtable];

    }];
}

- (void)addPeopleWithPeopleId:(NSString*)peopleId{
//    /api/friend/require
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSDictionary *baddyParams = @{
                           @"friend_id": peopleId,
                       };
    [manager POST:@"friend/require" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (CheckResponseObject(responseObject)) {
            NSString *title = @"添加成功";
            [CommonTools showAlertDismissWithContent:title showWaitTime:0 afterDelay:2 control:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isTapBack = NO;
}

- (void)backPopViewcontroller:(id) sender
{
    [self.navigationController popToViewController:self.invc animated:YES];
}





@end
