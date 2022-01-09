//
//  GroupRoomDetailViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/8/4.
//

#import "GroupRoomDetailViewController.h"
#import "UIDeps.h"
#import "FITAPI.h"
#import "ConfigManager.h"
#import "RoomVC.h"
#import "APPObjOnce.h"
#import "UserHeadPicView.h"
#import "CoachCommentCell.h"
#import "GroupDetailTableViewCell.h"
#import "CoachComment.h"
#import "HasJoinGroupRoomView.h"
#import "UIImage+Extension.h"
#import "ShareAboveView.h"
#import <messageUI/messageUI.h>

@interface GroupRoomDetailViewController ()<MFMessageComposeViewControllerDelegate>{
    BOOL isLoading;
    int _pageCount;
    BOOL _isLoadAllData; //是否加载所有的数据，每次刷新的时候，都设置成no， 接口返回的数据小于需要的数量时，设置成yes
    NSURLSessionDataTask *requestTask;//请求用的task
    NSMutableArray *dataArr;
    GroupDetailTableViewCell *heightCell;
    CoachCommentCell *heightCommentCell;
    NSArray * currentUserList;
    HasJoinGroupRoomView *hasJionView;
    
    ShareAboveView *aboveView;//分享的弹层
    UIButton *shareBackbutton;//分享的背景按钮
}
@property(nonatomic, strong)UIButton *joinBtn;
@property(nonatomic, strong)UITableView *cocahTableview;


@end

@implementation GroupRoomDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
        
    self.view.backgroundColor = UIColor.blackColor;
    [self reachData];
}

//改变有几人参与了
- (void)changehasJionView{
    if (hasJionView) {
        [hasJionView changeviewWithUselist:currentUserList];
    }
}

- (void)changejoinBtn{
    [CommonTools changeBtnState:_joinBtn btnData:self.selectRoom];
}

- (void)addsubviews{
    UIImageView *topImgView = [[UIImageView alloc] init];
    topImgView.image = [UIImage imageNamed:@"coursedetail_top"];
    NSString *picUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, self.selectRoom.pic];
    [topImgView sd_setImageWithURL: [NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    [self.view addSubview:topImgView];
    int topimageHeight = self.view.bounds.size.height / 3;
    [topImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(topimageHeight);
    }];
    topImgView.contentMode = UIViewContentModeScaleAspectFill;

    _joinBtn = [[UIButton alloc] init];
    [_joinBtn addTarget:self action:@selector(joinClass) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_joinBtn];
    _joinBtn.titleLabel.font =SystemFontOfSize(13);
    [_joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topImgView.mas_bottom).offset(-70);
        make.right.equalTo(topImgView.mas_right).offset(-10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    [self changejoinBtn];
    
    hasJionView = [[[NSBundle mainBundle] loadNibNamed:@"HasJoinGroupRoomView" owner:self options:nil] lastObject];
    [self.view addSubview:hasJionView];
    [hasJionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topImgView.mas_right).offset(-10);
        make.height.mas_equalTo(34);
        make.top.equalTo(_joinBtn.mas_bottom).offset(10);

    }];
    [self changehasJionView];

    UIView *topImgBotView = [[UIView alloc]init];
    topImgBotView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:topImgBotView];
    [topImgBotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.top.equalTo(topImgView.mas_bottom).offset(-20);
    }];
//    不透明背景
    UIView *topimagBotBackView = [[UIView alloc] init];
    [topImgBotView addSubview:topimagBotBackView];
    topimagBotBackView.backgroundColor = UIRGBColor(37, 37, 37, 0.3);
    topimagBotBackView.alpha = 0.7;
//    topimagBotBackView.backgroundColor = UIColor.redColor;
    [topimagBotBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(topImgBotView);
        make.top.equalTo(topImgBotView);
        make.left.equalTo(topImgBotView);
    }];
    
    UILabel *courseNameLl = [[UILabel alloc] init];
    courseNameLl.text = self.selectRoom.name;
    courseNameLl.textColor = UIColor.whiteColor;
    courseNameLl.font =[UIFont boldSystemFontOfSize:22];
    [topImgBotView addSubview:courseNameLl];
    [courseNameLl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgBotView);
        make.left.equalTo(topImgBotView).offset(10);
    }];
    
    UILabel *startTimelabel = [[UILabel alloc] init];
    NSString *startString = @"";
    if (ISChinese()) {
        startString = [CommonTools ReachCutomerChineseWeekTime:self.selectRoom.start_time];
    }else{
        startString = ReachWeekTime(self.selectRoom.start_time);
    }
    startString = [NSString stringWithFormat:@"%@ %@",startString,ChineseStringOrENFun(@"交流语言：", @"Speek lan：")];
    startString = [NSString stringWithFormat:@"%@%@",startString,[self.selectRoom getCourse_language_string]];
    startTimelabel.text = startString;
    
    startTimelabel.textColor = UIColorFromRGB(225, 225, 225);
    startTimelabel.font = SystemFontOfSize(13);
    [topImgBotView addSubview:startTimelabel];
    [startTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(courseNameLl.mas_bottom).offset(5);
        make.left.equalTo(courseNameLl);
    }];
    self.cocahTableview = [[UITableView alloc] init];
    [self.view addSubview:self.cocahTableview];
    self.cocahTableview.backgroundColor = UIColor.blackColor;
    [self.cocahTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImgBotView.mas_bottom).offset(15);
        make.left.bottom.right.equalTo(self.view);
    }];
    self.cocahTableview.dataSource = self;
    self.cocahTableview.delegate = self;
    [self.cocahTableview registerNib:[UINib nibWithNibName:NSStringFromClass([CoachCommentCell class]) bundle:nil] forCellReuseIdentifier:@"CoachCommentCellString"];
    self.cocahTableview.separatorColor = UIColor.clearColor;
    [self setupRefresh];
}


- (void)followBtnClick{
    
}



- (void)reachRoomDetailInfo
{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSString *eventid = self.selectRoom.event_id;
        NSDictionary *baddyParams = @{
                               @"event_id": self.selectRoom.event_id,
                           };
        [manager GET:@"room/detail" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            if (CheckResponseObject(responseObject)) {
                NSDictionary *roomJson = responseObject[@"recordset"];
                NSError *error;
                self->_selectRoom = [[Room alloc] initWithDictionary:roomJson error:&error];
                self.selectRoom.event_id = eventid;
                [self addsubviews];
                [self reachHeadData];
            }else{
                [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"]  control:self];
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    
 
}

- (void)reachData{
    [self reachRoomDetailInfo];
    NSDictionary *baddyParams = @{
                           @"event_id": self.selectRoom.event_id,
                       };
    [[AFAppNetAPIClient manager] GET:@"room/user" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        if (CheckResponseObject(responseObject)) {
            NSArray *userlist = responseObject[@"recordset"];
            if ([userlist isKindOfClass:[NSArray class]]) {
                NSMutableArray *list = [NSMutableArray array];
                for (NSDictionary *dic in userlist) {
                    UserInfo * user = [[UserInfo alloc] initWithJSON:dic];
                    [list addObject:user];
                }
                self->currentUserList = list;
                [self changehasJionView];
            }
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share" renderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked:)];
    self.navigationItem.rightBarButtonItem =rightItem;
}

//分享
- (void)shareBtnClicked:(id)sender{
//
    shareBackbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    aboveView = [[[NSBundle mainBundle] loadNibNamed:@"ShareAboveView" owner:self options:nil] lastObject];
    aboveView.frame = CGRectMake(10, ScreenHeight-160, ScreenWidth-20, 160);
    [shareBackbutton addSubview:aboveView];
//    aboveView.backgroundColor = UIColor.whiteColor;
    aboveView.layer.cornerRadius = 10;
    aboveView.clipsToBounds = YES;
    [aboveView.cancelBtn addTarget:self action:@selector(shareBackbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    WeakSelf
    aboveView.shareBtnClick = ^(NSNumber *clickModel) {
        StrongSelf(wSelf);
        [strongSelf shareBtnWithTag:clickModel.intValue];
    };
    [aboveView createSubview];
    UIWindow *keywindow = [CommonTools mainWindow];
    [keywindow addSubview:shareBackbutton];
    [shareBackbutton addTarget:self action:@selector(shareBackbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)shareBtnWithTag:(int)btnTag{
    if (btnTag == 2) {
        [self sharedByMessage];
    }
}

- (void)shareBackbuttonClicked:(UIButton*)sender{
//    恢复默认值
    [shareBackbutton removeFromSuperview];
    shareBackbutton= nil;
}



- (void) joinClass{
//    需要判断状态
    int realState = [self.selectRoom reachRoomDealState];
    
    if (realState == 1 || realState == 2) {
//        预约
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
        BOOL postBool =!self.selectRoom.is_join;
        NSMutableDictionary *baddyParams = [NSMutableDictionary dictionary];
        [baddyParams setObject:self.selectRoom.event_id forKey:@"event_id"];
        [baddyParams setObject:[NSNumber numberWithBool:postBool] forKey:@"is_join"];
        [manager POST:@"room/join" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (CheckResponseObject(responseObject)) {
                self.selectRoom.is_join = postBool;
                [self changejoinBtn];
            }else{
                [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"]  control:self];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [CommonTools showNETErrorcontrol:self];
        }];
    }else if(realState == 5){
//        直接开始
        [[APPObjOnce sharedAppOnce] joinRoom:self.selectRoom withInvc:self];
    }
    
}


#pragma mark - 刷新房间数据
- (void) reachHeadData
{
    dataArr = [NSMutableArray array];
    _isLoadAllData =NO;
    [self loadDateIsLoadHead:YES];
}


 

- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.cocahTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.cocahTableview addFooterWithTarget:self action:@selector(footerRereshing)];
    self.cocahTableview.mj_footer.ignoredScrollViewContentInsetBottom =[CommonTools safeAreaInsets].bottom;
}
//开始进入刷新状态
- (void)headerRereshing
{
    //下拉刷新，先还原上拉“已加载全部数据”的状态
    [self.cocahTableview.mj_footer resetNoMoreData];
    [self reachHeadData];
}


//下拉刷新


- (void)loadDateIsLoadHead:(BOOL)isLoadHead
{
    if (!isLoading) {
        isLoading = YES;
        [requestTask cancel];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
        int size = 20;
        int page = 1;
        if (!isLoadHead) {
//            加载更多
            page = _pageCount+1;
        }
        NSDictionary *baddyParams = @{
                               @"page": [NSString stringWithFormat:@"%d",page],
                               @"row": [NSString stringWithFormat:@"%d",size],
                               @"coach_id":self.selectRoom.coach.id
                           };
        
        requestTask = [manager GET:@"comment/coach/list" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (responseObject && responseObject[@"recordset"] ) {
                NSArray *dataArray = responseObject[@"recordset"][@"rows"];
                if (dataArray.count < size) {
                    self->_isLoadAllData = YES;
                }
                if (isLoadHead) {
                    self->_pageCount = 1;
                }
                else
                {
                    self->_pageCount =self->_pageCount+1;
                }
                if (isLoadHead) {
                    self->dataArr = [[NSMutableArray alloc] init];
                }
                for (int i = 0; i < [dataArray count]; i++) {
                    CoachComment *coach = [[CoachComment alloc] initWithDictionary: dataArray[i] error:nil];
                    [self->dataArr addObject: coach];
                }
                
                if (isLoadHead) {
                    [self.cocahTableview.mj_header endRefreshing];
                }
                [self loadNextPageData];
                [self.cocahTableview reloadData];
            }
            self->isLoading = NO;
          
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else
    {
    }
 
}

//上拉加载更多
- (void)loadMore
{
    if (!_isLoadAllData) {
        [self loadDateIsLoadHead:NO];
    }
    else
    {
        [self loadNextPageData];
    }
}

- (void)footerRereshing
{
    [self loadMore];
}

-(void)loadNextPageData{

    [self.cocahTableview.mj_footer endRefreshing];
    if (_isLoadAllData) {
        [self.cocahTableview.mj_footer endRefreshingWithNoMoreData];
    }
    
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (!heightCell) {
            heightCell = [[GroupDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GroupDetailTableViewCellHeight"];
        }
        [heightCell changeDatewithRoom:self.selectRoom];
        CGSize heightSize = [heightCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return heightSize.height+1;
    }else{
        if (!heightCommentCell) {
            heightCommentCell = [[[NSBundle mainBundle] loadNibNamed:@"CoachCommentCell" owner:self options:nil] lastObject];
        }
        CoachComment *comment = [dataArr objectAtIndex:indexPath.row-1];
        [heightCommentCell loadData:comment];
        CGSize heightSize = [heightCommentCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return heightSize.height+1;
    }
     
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        GroupDetailTableViewCell *detailcell = [[GroupDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BaseTableViewCell"];
        [detailcell changeDatewithRoom:self.selectRoom];
        return  detailcell;
    }else{
        CoachCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoachCommentCellString"];
        CoachComment *comment = [dataArr objectAtIndex:indexPath.row-1];
        cell.contentView.backgroundColor = UIColor.blackColor;
        [cell loadData:comment];
        cell.btnCallBack = ^{
            [self favoriteCommentFromServer:comment];
        };
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//点赞
- (void)favoriteCommentFromServer:(CoachComment *)comment {
    NSDictionary *param = @{@"obj_id":comment.id,
                            @"is_favorite":IntToString(!comment.is_favorite),
                            @"type":@"comment"};
    NSString *url = comment.is_favorite ? @"favorite/cancel" : @"favorite/add";
    [[AFAppNetAPIClient manager] POST:url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSLog(@"====respong:%@", responseObject);
        NSString *result = [responseObject objectForKey:@"recordset"];
        if ([result isEqualToString:@"success"]) {
            comment.is_favorite = !comment.is_favorite;
            comment.favorite_cnt += comment.is_favorite ? 1 : -1;
            [self.cocahTableview reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

#pragma mark --MFMessageComposeViewControllerDelegate

- (void)sharedByMessage
{
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass != nil) {
       /**MFMessageComposeViewController提供了操作界面
        使用前必须检查canSendText方法,若返回NO则不应将这个controller展现出来,而应该提示用户不支持发送短信功能.
         */
        if ([messageClass canSendText]) {
            [self displaySMSComposerSheet];
        }else{
            [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"您设备没有短信功能", @"您设备没有短信功能") control:self];
        }
    }

}
 

-(void)displaySMSComposerSheet
{
   MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc]init];
    picker.messageComposeDelegate =self;
    picker.body =@"Hihi! 跟我一起来上健身课，品牌健身房的大牌教练，哪国人都有。";
    [self presentViewController:picker animated:YES completion:^{
//        [self shareBackbuttonClicked:nil];
    }];
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result

{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled){
    }else if (result == MessageComposeResultSent){
        [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"短信发送成功", @"短信发送成功") control:self];
    }else if(result == MessageComposeResultFailed){
        [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"短信发送失败，是否重新发送？", @"短信发送失败，是否重新发送？") control:self];

    }

}

@end

