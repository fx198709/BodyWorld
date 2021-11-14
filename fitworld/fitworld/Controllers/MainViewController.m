//
//  MainViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/7/4.
//

#import "MainViewController.h"
#import "UIDeps.h"
#import "AFNetworking.h"
#import "TableCollectionViewCell.h"
#import "TableCollectionLivingViewCell.h"
#import "Course.h"
#import "Room.h"
#import "UserInfo.h"
#import "CourseMoreController.h"
#import "TrainingViewController.h"
#import "UserCenterViewController.h"
#import "JYCarousel.h"
#import "MessageListViewController.h"

BOOL  hasrequest = NO;
@interface MainViewController (){
    BOOL hasNoReadMessage;
    BOOL hasNewFrend;
}
@property (nonatomic, strong)UIView *sliderView; //轮播图的父视图
@property (nonatomic, strong)NSMutableArray *livingClasses;//正在进行中
@property (nonatomic, strong)NSMutableArray *groupClasses;//团课
@property (nonatomic, strong)NSMutableArray *buddyClasses;//对练课


@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.mainTableview];
    [self.mainTableview registerNib:[UINib nibWithNibName:NSStringFromClass([TableCollectionViewCell class]) bundle:nil] forCellReuseIdentifier:@"liveCell"];
    [self.mainTableview registerNib:[UINib nibWithNibName:NSStringFromClass([TableCollectionLivingViewCell class]) bundle:nil] forCellReuseIdentifier:@"liveTableviewCell"];

    self.mainTableview.delegate = self;
    self.mainTableview.dataSource = self;
    _mainTableview.separatorStyle= UITableViewCellSeparatorStyleNone;
    _mainTableview.backgroundColor = UIColor.blackColor;
    [self.mainTableview mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.with.top.equalTo(self.view);
      make.size.equalTo(self.view);
    }];
    [[APPObjOnce sharedAppOnce] getUserinfo:^(bool isSuccess) {
        self.userInfo = [[APPObjOnce sharedAppOnce] currentUser];
    }];
    [self setupRefresh];
    _mainTableview.mj_header.backgroundColor = UIColor.blackColor;
    _mainTableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 173)];
    _sliderView.clipsToBounds = YES;
    _sliderView.layer.cornerRadius = 5;
//    [self headerRereshing];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_mainTableview.mj_header beginRefreshing];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear %@",self.class);
}

//- (UserInfo *)userInfo {
//    return [APPObjOnce sharedAppOnce].currentUser;
//}

- (void)reachNoReadMessageList{
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSDictionary *baddyParams = @{
                           @"is_read": @"0",
                           @"page": @"1",
                           @"row": @"10"
                       };
    [manager GET:@"user_msg" parameters:baddyParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        有数据就显示红点，没数据就不显示
        if ([responseObject objectForKey:@"recordset"]) {
            UIView *redview = [self.view viewWithTag:2000];
            NSArray *array = [[responseObject objectForKey:@"recordset"] objectForKey:@"rows"];
            if ([array isKindOfClass:[NSArray class]] && array.count >0) {
                self->hasNoReadMessage = YES;
                redview.hidden = NO;
            }else{
                self->hasNoReadMessage = NO;
                redview.hidden = YES;
            }
        }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


- (void)reachNoReadFrendList{
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSDictionary *baddyParams = @{
                           @"status": @"1",
                           @"page": @"1",
                           @"row": @"10"
                       };
    [manager GET:@"friend/apply_list" parameters:baddyParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        有数据就显示红点，没数据就不显示
        if ([responseObject objectForKey:@"recordset"]) {
            UIView *redview = [self.view viewWithTag:2001];
            NSArray *array = [[responseObject objectForKey:@"recordset"] objectForKey:@"rows"];
            if ([array isKindOfClass:[NSArray class]] && array.count >0) {
                self->hasNewFrend = YES;
                redview.hidden = NO;
            }else{
                self->hasNewFrend = NO;
                redview.hidden = YES;
            }
        }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.mainTableview addHeaderWithTarget:self action:@selector(headerRereshing)];
}
//开始进入刷新状态
- (void)headerRereshing
{
    //下拉刷新，先还原上拉“已加载全部数据”的状态
    [self.mainTableview.mj_footer resetNoMoreData];
    [self reachHeadData];
    [self reachSlideData];
    [self reachNoReadMessageList];
    [self reachNoReadFrendList];
}

- (void)addCarouselView:(NSArray*)dataArray{
    //图片数组（或者图片URL，图片URL字符串，图片UIImage对象）
    if (![dataArray isKindOfClass:[NSArray class]]) {
        return;
    }
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (NSObject *obj in dataArray) {
        [imageArray addObject:[obj valueForKey:@"pic"]];
    }
    WeakSelf
   JYCarousel *carouselView = [[JYCarousel alloc] initWithFrame:CGRectMake(0, 0, _sliderView.frame.size.width, _sliderView.frame.size.height) configBlock:^JYConfiguration *(JYConfiguration *carouselConfig) {
         //配置指示器类型
        carouselConfig.pageContollType = MiddlePageControl;
        //配置轮播时间间隔
        carouselConfig.interValTime = 3;
       carouselConfig.contentMode = UIViewContentModeScaleAspectFill;
//        //配置轮播翻页动画
//        carouselConfig.pushAnimationType = PushCube;
//        //配置动画方向
//        carouselConfig.animationSubtype = kCATransitionFromRight;
        return carouselConfig;
    } clickBlock:^(NSInteger index) {
          //点击imageView回调方法
        [wSelf clickIndex:index];
    }];
    //开始轮播
    [carouselView startCarouselWithArray:imageArray];
    carouselView.backgroundColor = [UIColor clearColor];
    RemoveSubviews(_sliderView,@[]);
    [_sliderView addSubview:carouselView];
}

- (void)clickIndex:(NSInteger)index{
    
}

- (void)actionBtnClick:(UIButton*)sender{
    if (sender.tag == 101) {
       //朋友列表
        [self performSegueWithIdentifier:@"friendListSegue" sender:nil];
    }else{
        MessageListViewController *vc = [[MessageListViewController alloc] initWithNibName:@"MessageListViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIButton*)reachBtn:(int)type {
    CGRect btnframe = CGRectMake(ScreenWidth-50, 30, 40, 40);
    UIImage *image = [UIImage imageNamed:@"notification"];
    if (type == 1) {
        btnframe = CGRectMake(ScreenWidth-100, 30, 40, 40);
        image = [UIImage imageNamed:@"friend_list"];
    }
    UIButton *vbtn = [[UIButton alloc] initWithFrame:btnframe];
    UIImageView * vimage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    [vbtn addSubview:vimage];
    vimage.image = image;
    vbtn.tag = 100+type;
    [vbtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(28, 8, 10, 10)];
    redview.backgroundColor = [UIColor redColor];
    [vbtn addSubview:redview];
    redview.layer.cornerRadius = 5;
    redview.clipsToBounds = YES;
    
    redview.tag = 2000+type;
    redview.hidden = YES;
    if (hasNoReadMessage && type ==0) {
        redview.hidden = NO;
    }
    if (hasNewFrend && type ==1) {
        redview.hidden = NO;
    }
    return  vbtn;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!hasrequest) {
        return 1;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建标识词，随意设置，但不能和其它 tableView 的相同
    static NSString *indentifier = @"mainIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (indexPath.row == 0){
        // 复用队列中没有时再创建
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: indentifier];
        [cell.contentView addSubview: ({
            UILabel *titleLable =  [[UILabel alloc] initWithFrame:CGRectMake(80, 20, ScreenWidth-180, 50)];
            titleLable.font = [UIFont systemFontOfSize: 16];
            titleLable.text = self.userInfo.nickname;
            titleLable.textColor = [UIColor whiteColor];
            [titleLable sizeToFit];
            titleLable;
        })];
        
        [cell.contentView addSubview: ({
            UILabel *sourceLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, ScreenWidth-180, 20)];
            sourceLable.font = [UIFont systemFontOfSize: 12];
            sourceLable.text = ChineseOrENFun(self.userInfo, @"msg");
            sourceLable.textColor = [UIColor whiteColor];
            [sourceLable sizeToFit];
            sourceLable;
        })];
        
        [cell.contentView addSubview: ({
            UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
            [leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, self.userInfo.avatar]]];
            leftImageView.contentMode = UIViewContentModeScaleAspectFill;
            leftImageView.layer.masksToBounds = YES;
            leftImageView.layer.cornerRadius = 20;
            [leftImageView.layer setBorderWidth:2];
            [leftImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            leftImageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUserCenter)];
            [leftImageView addGestureRecognizer:singleTap];
            leftImageView;
        })];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor blackColor];
        
        UIButton * vbtn = [self reachBtn:0];
        [cell.contentView addSubview:vbtn];
        
        UIButton * userbtn = [self reachBtn:1];
        [cell.contentView addSubview:userbtn];
        
        return cell;
    }
    if (indexPath.row == 1){
        UITableViewCell *slidercell = [tableView dequeueReusableCellWithIdentifier:@"slidercellString"];
        if (slidercell == nil) {
            slidercell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"slidercellString"];
            [slidercell.contentView addSubview:_sliderView];
            slidercell.contentView.backgroundColor = BuddyTableBackColor;
        }
        return slidercell;
    }

    if (indexPath.row == 2){
        // 复用队列中没有时再创建
        TableCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveTableviewCell" forIndexPath:indexPath];
        [cell.logoImage setImage:[UIImage imageNamed:@"index_live"]];
        cell.subTitleLabel.text = ChineseStringOrENFun(@"正在进行", @"LIVE & UPCOMING");

        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [cell.attentionBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:(UIControlEventTouchDown)];
//            [self refreshData:cell :@""];
        cell.attentionBtn.tag = 200;
        cell.backgroundColor = UIColor.blackColor;
        cell.dataArr = _livingClasses;
        [cell.myCollectionView reloadData];
        return cell;
    }
    if (indexPath.row == 3 ){
        // 创建新的 cell，默认为主标题模式
        TableCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveCell" forIndexPath:indexPath];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [cell.logoImage setImage:[UIImage imageNamed:@"index_group"]];
        cell.subTitleLabel.text = ChineseStringOrENFun(@"团课", @"GROUP CLASS");
        cell.dataArr = _groupClasses;
        [cell.myCollectionView reloadData];
        [cell.attentionBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchDown];
        cell.attentionBtn.tag = 201;
        cell.backgroundColor = UIColor.blackColor;
        return cell;
    }
    if (indexPath.row == 4 ){
        TableCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveCell"];
        // 创建新的 cell，默认为主标题模式
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [cell.attentionBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        cell.attentionBtn.tag = 202;
        [cell.logoImage setImage:[UIImage imageNamed:@"index_buddy"]];
        cell.subTitleLabel.text = ChineseStringOrENFun(@"对练课", @"BUDDY TRAINING");;
        cell.dataArr = _buddyClasses;
        [cell.myCollectionView reloadData];
        UIView * view = [cell viewWithTag:10001];
        if (view == nil) {
            UIButton *createSessionBtn = [[UIButton alloc] init];
            createSessionBtn.tag = 100001;
            NSString *creatString = ChineseStringOrENFun(@"  创建房间  ", @"  Create a session  ");
            [createSessionBtn setTitle:creatString forState:UIControlStateNormal];
            [createSessionBtn setTitle:creatString forState:UIControlStateHighlighted];
            createSessionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [cell addSubview:createSessionBtn];
            [createSessionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(24);
                make.centerY.equalTo(cell.subTitleLabel);
                make.left.equalTo(cell.subTitleLabel.mas_right).offset(20);
            }];
            createSessionBtn.backgroundColor = UIColorFromRGBHex(0x7D7D7D);
            
            createSessionBtn.layer.cornerRadius = 12;
            createSessionBtn.clipsToBounds = YES;
            [createSessionBtn addTarget:self action:@selector(clickCreateSessionTraining) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.backgroundColor = UIColor.blackColor;
        return cell;
        
    }else{
        if (cell == nil) {
            // 创建新的 cell，默认为主标题模式
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.textLabel.text = @"aaaa";
        }
    }
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, statusBarHeight())];
    view.backgroundColor = UIColor.blackColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  statusBarHeight();
}

// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return 80;
    } else if(indexPath.row == 1){
        return 173;
    }else if(indexPath.row == 2){
        return 200;
    }
    return 250;
}

- (void)moreBtnClick:(UIButton*)sender
{
    NSLog(@"more btn click");
    CourseMoreController *courseMoreVC = [[CourseMoreController alloc]init];
    courseMoreVC.VCtype = [NSString stringWithFormat:@"%zd",sender.tag-200];
    courseMoreVC.navigationItem.title = @"Course";
    [self.navigationController pushViewController:courseMoreVC animated:YES];
}



#pragma mark - 刷新房间数据

- (void)reachSlideData{
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    [manager GET:@"slide" parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [[responseObject objectForKey:@"recordset"] objectForKey:@"rows"];
        [self addCarouselView:dataArray];
        
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)reachHeadData {
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSDictionary *baddyParams = @{
                           @"type": @"",
                           @"page": @"1",
                           @"row": @"5"
                       };
    [manager GET:@"room" parameters:baddyParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.buddyClasses = [NSMutableArray array];
        self.groupClasses = [NSMutableArray array];
        self.livingClasses = [NSMutableArray array];
        BOOL canAddFirstBuddy = NO;//第一次能添加buddy
        BOOL canAddFirstGroup = NO;//第一次能添加buddy

        NSDictionary * recordsetDic = [responseObject objectForKey:@"recordset"];
        if ([recordsetDic isKindOfClass:[NSDictionary class]]) {
            NSArray *rows = [recordsetDic objectForKey:@"rows"];
            if ([rows isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in rows) {
                    Room *room = [[Room alloc] initWithJSON: dic];
                    if (room.course.type_int == 0) {
                        if (room.status != 0) {
//                            直播状态，第一个不能添加到这边
                            if(canAddFirstBuddy){
                                [self.buddyClasses addObject:room];
                            }
                        }else{
                            [self.buddyClasses addObject:room];
                        }
                        canAddFirstBuddy = YES;
                    }
                    if (room.course.type_int == 1) {
                        if (room.status != 0) {
//                            直播状态，第一个不能添加到这边
                            if(canAddFirstGroup){
                                [self.groupClasses addObject:room];
                            }
                        }else{
                            [self.groupClasses addObject:room];
                        }
                        canAddFirstGroup = YES;
                    }
                    if (room.status != 0 && self.livingClasses.count < 10) {
//                        正在进行中
                        [self.livingClasses addObject:room];
                    }
                }
            }
        }

        hasrequest = YES;
        [self.mainTableview reloadData];
    
        [self.mainTableview.mj_header endRefreshing];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [MBProgressHUD hideHUDForView:self.view animated:YES];
           [self.mainTableview.mj_header endRefreshing];
    }];
}

- (void)onClickUserCenter {
    NSLog(@"onClickUserCenter ----  ");
    [self performSegueWithIdentifier:@"goToUserCenterSegue" sender:nil];
    
}

- (void)clickCreateSessionTraining{
    NSLog(@"createSessionTraining ----  ");
    
    TrainingViewController *vc = [[TrainingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
