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
#import "TrainCommitTableViewCell.h"
#import "MainViewController.h"
 
@interface AfterTrainingViewController (){
    BOOL reachRoomInfo;
    BOOL reachUserListInfo;
    int textviewdifHeight;//textview 变化的高度
    TrainCommitTableViewCell *commentcell;
}

@end

@implementation AfterTrainingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleLabel.text = ChineseStringOrENFun(@"祝贺您完成本课程！", @"Congratulations on completing the course!");
    _titleLabel.font = SystemFontOfSize(17);
    _titleLabel.textColor = UIColor.whiteColor;
    
    _timeLabel.text = @"";
    _timeLabel.textColor = LightGaryTextColor;
    _timeLabel.font =SystemFontOfSize(14);
    self.timeLabel.text = ReachYearANDTime([[NSDate date] timeIntervalSince1970]);

    _successTabelview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _successTabelview.dataSource = self;
    _successTabelview.delegate = self;
    _successTabelview.backgroundColor = UIColor.blackColor;
    [self reachData];
    // Do any additional setup after loading the view from its nib.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentRoom.type_int == 1 || _currentRoom.type_int == 2) {
//         团课 多一个评论
        int dif = 15;
        if (indexPath.row == 0) {
            return 90+dif;
        }else if (indexPath.row == 1) {
            return 200+dif+textviewdifHeight;
        }else if (indexPath.row == 2) {
            return 60+ self.currentRoom.plan.count * 40+dif;
        }else {
            return 60+ self.userList.count * 50+dif;
        }
        return 100;

    }else{
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
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_currentRoom.type_int == 1 || _currentRoom.type_int == 2) {
//         团课 多一个评论
        return 4;

    }else{
        return 3;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        Train1TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Train1TableViewCell" owner:self options:nil] lastObject];
        [cell changeDateWithRoomInfo:self.currentRoom];
        return cell;
    }
    if (_currentRoom.type_int == 1 || _currentRoom.type_int == 2){
        if (indexPath.row == 1) {
            if (commentcell == nil) {
                commentcell = [[[NSBundle mainBundle] loadNibNamed:@"TrainCommitTableViewCell" owner:self options:nil] lastObject];
            }
            commentcell.coach_id = _currentRoom.coach_id;
            WeakSelf
            commentcell.heightChange = ^(NSNumber* height) {
                [wSelf updateTableHeight:height.integerValue];
            };
            return commentcell;
        }else if (indexPath.row == 2) {
            Train2TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Train2TableViewCell" owner:self options:nil] lastObject];
            [cell changeDateWithRoomInfo:self.currentRoom];
            return cell;
        }else if (indexPath.row == 3) {
            Train3TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Train3TableViewCell" owner:self options:nil] lastObject];
            [cell changeDataWithUserList:self.userList];
            WeakSelf
            cell.peopleBtnClick = ^(UserInfo* user) {
                StrongSelf(wSelf);
                [strongSelf addPeopleWithPeopleId:user];
            };
    //        [cell changeDateWithRoomInfo:self.currentRoom];
            return cell;
        }
        
    }else{
        if (indexPath.row == 1) {
            Train2TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Train2TableViewCell" owner:self options:nil] lastObject];
            [cell changeDateWithRoomInfo:self.currentRoom];
            return cell;
        }else if (indexPath.row == 2) {
            Train3TableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"Train3TableViewCell" owner:self options:nil] lastObject];
            [cell changeDataWithUserList:self.userList];
            WeakSelf
            cell.peopleBtnClick = ^(UserInfo* user) {
                StrongSelf(wSelf);
                [strongSelf addPeopleWithPeopleId:user];
            };
    //        [cell changeDateWithRoomInfo:self.currentRoom];
            return cell;
        }
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
                    NSString *userId = user.id;
                    NSString *currentId =[APPObjOnce sharedAppOnce].currentUser.id;
                    if (![userId isEqualToString:currentId]) {
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
            NSError *error;
            self.currentRoom = [[Room alloc] initWithDictionary:roomJson error:&error];
            self.currentRoom.event_id = eventid;
        }
        self->reachRoomInfo =YES;
        [self reloadtable];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self->reachRoomInfo =YES;
        [self reloadtable];

    }];
}

- (void)addPeopleWithPeopleId:(UserInfo*)people{
//    /api/friend/require
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSDictionary *baddyParams = @{
                           @"friend_id": people.id,
                       };
    [manager POST:@"friend/require" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (CheckResponseObject(responseObject)) {
            NSString *title = @"添加成功";
            [CommonTools showAlertDismissWithContent:title showWaitTime:0 afterDelay:2 control:self];
            people.is_friend = YES;
            [self->_successTabelview reloadData];
        }else{
            [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"] control:self];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    删除roomvc
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
       for (UIViewController *vc in marr) {
           if ([vc isKindOfClass:NSClassFromString(@"RoomVC")] || [vc isKindOfClass:NSClassFromString(@"GroupRoomViewControl")] || [vc isKindOfClass:NSClassFromString(@"PrivateRoomViewControl")] ) {
               [marr removeObject:vc];
               break;
           }
       }
    self.navigationController.viewControllers = marr;
       
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.isTapBack = NO;

}
 

- (void)backPopViewcontroller:(id) sender
{
    UIViewController * popVC = nil;
    NSArray *vcs = self.navigationController.viewControllers;
    for (UIViewController * vc in vcs) {
        if ([vc isKindOfClass:[MainViewController class]]) {
            popVC = vc;
        }
    }
    if (popVC) {
        [self.navigationController popToViewController:popVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//更新tableview的高度
- (void)updateTableHeight:(NSInteger)height{
    textviewdifHeight = height;
    [_successTabelview beginUpdates];
    [_successTabelview endUpdates];
}



@end
