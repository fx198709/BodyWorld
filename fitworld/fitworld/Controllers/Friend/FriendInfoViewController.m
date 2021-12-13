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
    _descView.layer.cornerRadius = 5;
    _descView.clipsToBounds = YES;
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
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    RemoveSubviews(cell.contentView, @[]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BgGrayColor;
    int leftdif = 15;

    Room *room = [self.dataList objectAtIndex:indexPath.row];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,22, 56, 56)];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, room.course.pic]]];
    [cell.contentView addSubview:leftImageView];
    leftImageView.clipsToBounds = YES;
    leftImageView.layer.cornerRadius = 28;
    [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(22);
        make.left.equalTo(cell.contentView).offset(20);
        make.size.mas_equalTo(CGSizeMake(56, 56));
    }];
    int type_int = room.course ? room.course.type_int:room.type_int;
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = room.course.name;
    label1.font = [UIFont systemFontOfSize:17];
    label1.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(20);
        make.left.equalTo(leftImageView.mas_right).offset(leftdif+25);
    }];
    UIImage *classimage = [UIImage imageNamed:[NSString stringWithFormat:@"more_type_icon%d",type_int]];
    UIImageView *classimageview = [[UIImageView alloc] initWithImage:classimage];
    [cell.contentView addSubview:classimageview];
    [classimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label1);
        make.left.equalTo(leftImageView.mas_right).offset(leftdif);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *label2left = [[UILabel alloc] init];
    if (type_int == 0) {
        label2left.text = ChineseStringOrENFun(@"创建人:", @"creater:");
    }else if (type_int == 1){
        label2left.text = ChineseStringOrENFun(@"直播教练人:", @"coach:");
    }else{
        label2left.text = @"";
    }
    
    [cell.contentView addSubview:label2left];
    [label2left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.left.equalTo(leftImageView.mas_right).offset(leftdif);
    }];
    label2left.font = [UIFont systemFontOfSize:13];
    label2left.textColor = LightGaryTextColor;
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = room.room_creator.nickname;
    [cell.contentView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.left.equalTo(label2left.mas_right).offset(1);
    }];
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = LightGaryTextColor;
    NSString *countryUrl = room.room_creator.country_icon;
    UIImageView *countryImageView = [[UIImageView alloc] init];
    [countryImageView sd_setImageWithURL:[NSURL URLWithString:countryUrl]];
    [cell.contentView addSubview:countryImageView];
    countryImageView.contentMode = UIViewContentModeScaleAspectFit;
    [countryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label2);
        make.left.equalTo(label2.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = ReachWeekTime(room.updated_at.longLongValue);
    [cell.contentView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2.mas_bottom).offset(5);
        make.left.equalTo(leftImageView.mas_right).offset(leftdif);
    }];
    label3.font = [UIFont systemFontOfSize:13];
    label3.textColor = LightGaryTextColor;
    UILabel *limitLabel = nil;
     
    if ([room isBegin]) {
//        处在直播状态
        long currentTime = [[NSDate date] timeIntervalSince1970];
        long diff = currentTime- room.start_time;
        if (diff > 0) {
            NSString *leftString = [CommonTools reachLeftString:diff];
            limitLabel = [[UILabel alloc] init];
            leftString = [NSString stringWithFormat:@"%@  %@",leftString,ChineseStringOrENFun(@"Elapsed", @"Elapsed")];
            limitLabel.text = leftString;
            limitLabel.font = SystemFontOfSize(14);
            [cell.contentView addSubview:limitLabel];
            limitLabel.textAlignment = NSTextAlignmentRight;
            limitLabel.textColor = LightGaryTextColor;
            [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-10);
                make.height.mas_equalTo(25);
                
             }];
        }
    }else{
        //        还没开始 判断开始时间和现在时间的差
        long currentTime = [[NSDate date] timeIntervalSince1970];
        long diff = room.start_time - currentTime;
        if (diff < 3600*3 && diff >0) {
            NSString *leftString = [CommonTools reachLeftString:diff];
            limitLabel = [[UILabel alloc] init];
            leftString = [NSString stringWithFormat:@"%@  %@",leftString,ChineseStringOrENFun(@"to start", @"to start")];
            limitLabel.text = leftString;
            limitLabel.font = SystemFontOfSize(14);
            [cell.contentView addSubview:limitLabel];
            limitLabel.textAlignment = NSTextAlignmentRight;
            limitLabel.textColor = LightGaryTextColor;
            [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-10);
                make.height.mas_equalTo(25);
                
             }];
        }
    }
    UIButton *joinBtn = [[UIButton alloc] init];
    
    [joinBtn addTarget:self action:@selector(joinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:joinBtn];
    joinBtn.tag = 100+indexPath.row;
    joinBtn.titleLabel.font =SystemFontOfSize(13);
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-10);
        if (limitLabel) {
            make.centerY.equalTo(cell.contentView).offset(8);
            make.top.equalTo(limitLabel.mas_bottom).offset(3);
        }else{
            make.centerY.equalTo(cell.contentView);
        }
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(80);
    }];
    
    [CommonTools changeBtnState:joinBtn btnData:room];
    if (indexPath.row != self.dataList.count -1) {
        UIView *lineview = [[UIView alloc] init];
        lineview.backgroundColor = LineColor;
        [cell.contentView addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(cell.contentView);
        }];
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
                [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"操作成功", @"操作成功") control:self];
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
                [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"操作成功", @"操作成功") control:self];
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
