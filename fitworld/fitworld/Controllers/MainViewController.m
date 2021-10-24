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
#import "Course.h"
#import "Room.h"
#import "UserInfo.h"
#import "CourseMoreController.h"
#import "TrainingViewController.h"
#import "UserCenterViewController.h"
#import "JYCarousel.h"

@interface MainViewController ()
@property (nonatomic, strong)UIView *sliderView; //轮播图的父视图
@property (nonatomic, strong)NSMutableArray *livingClasses;//正在进行中
@property (nonatomic, strong)NSMutableArray *groupClasses;//团课
@property (nonatomic, strong)NSMutableArray *buddyClasses;//对练课


@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:self.mainTableview];
    [self.mainTableview registerNib:[UINib nibWithNibName:NSStringFromClass([TableCollectionViewCell class]) bundle:nil] forCellReuseIdentifier:@"liveCell"];
    self.mainTableview.delegate = self;
    self.mainTableview.dataSource = self;
    [self.mainTableview mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.with.top.equalTo(self.view);
      make.size.equalTo(self.view);
    }];
    [self setupRefresh];
    
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(17, 8, ScreenWidth-17*2, 116)];
    _sliderView.clipsToBounds = YES;
    _sliderView.layer.cornerRadius = 5;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
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
       carouselConfig.contentMode = UIViewContentModeScaleAspectFit;
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
    RemoveSubviews(_sliderView,@[@"JYCarousel"]);
    [_sliderView addSubview:carouselView];
}

- (void)clickIndex:(NSInteger)index{
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
            UILabel *titleLable =  [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 300, 50)];
            titleLable.font = [UIFont systemFontOfSize: 16];
            titleLable.text = self.userInfo.username;
            titleLable.textColor = [UIColor whiteColor];
            [titleLable sizeToFit];
            titleLable;
        })];
        
        [cell.contentView addSubview: ({
            UILabel *sourceLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 300, 20)];
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
    }
    if (indexPath.row == 1){
        UITableViewCell *slidercell = [tableView dequeueReusableCellWithIdentifier:@"slidercellString"];
        if (slidercell == nil) {
            slidercell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"slidercellString"];
            [slidercell.contentView addSubview:_sliderView];
        }
        return slidercell;
    }

    if (indexPath.row == 2){
        _liveIndexPath = indexPath;
        // 复用队列中没有时再创建
        if (cell == nil) {
            // 创建新的 cell，默认为主标题模式
            TableCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveCell" forIndexPath:indexPath];
            [cell.logoImage setImage:[UIImage imageNamed:@"index_live"]];
            NSString *main_liveTitleStr = NSLocalizedString(@"main_liveTitleStr", nil);
            cell.subTitleLabel.text = main_liveTitleStr;
            
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            [cell.attentionBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:(UIControlEventTouchDown)];
//            [self refreshData:cell :@""];
            cell.backgroundColor = UIColor.blackColor;
            return cell;
        }
    }
    if (indexPath.row == 3 ){
        // 创建新的 cell，默认为主标题模式
        TableCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveCell" forIndexPath:indexPath];
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [cell.logoImage setImage:[UIImage imageNamed:@"index_group"]];
        cell.subTitleLabel.text = @"GROUP CLASS";
        cell.dataArr = _groupClasses;
        [cell.myCollectionView reloadData];
        [cell.attentionBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchDown];
//            [self refreshData:cell :@"团课"];
//            [self refreshData:cell :@"对练课"];
        cell.backgroundColor = UIColor.blackColor;
        return cell;
    }
    if (indexPath.row == 4 ){
        TableCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveCell"];
        // 创建新的 cell，默认为主标题模式
        [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
        [cell.attentionBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.logoImage setImage:[UIImage imageNamed:@"index_buddy"]];
        cell.subTitleLabel.text = @"BUDDY TRAINING";
        cell.dataArr = _buddyClasses;
        [cell.myCollectionView reloadData];
        UIView * view = [cell viewWithTag:10001];
        if (view == nil) {
            UIButton *createSessionBtn = [[UIButton alloc] init];
            createSessionBtn.tag = 100001;
            [createSessionBtn setTitle:@"Create a session" forState:UIControlStateNormal];
            createSessionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [createSessionBtn.layer setBorderWidth:5];
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0,0,0,0.1});
            [createSessionBtn.layer setBorderColor:color];
            [cell addSubview:createSessionBtn];
            [createSessionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(30);
                make.centerY.equalTo(cell.subTitleLabel);
                make.left.equalTo(cell.subTitleLabel.mas_right).offset(20);
            }];
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


// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return 80;
    } else if(indexPath.row == 1){
        return 132;
    }
    return 200;
}

- (void)moreBtnClick
{
    NSLog(@"more btn click");
    CourseMoreController *courseMoreVC = [[CourseMoreController alloc]init];
    courseMoreVC.VCtype = [NSString stringWithFormat:@"%zd",0];
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
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSDictionary *baddyParams = @{
                           @"type": @"",
                           @"page": @"1",
                           @"row": @"5"
                       };
    [manager GET:@"room" parameters:baddyParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.buddyClasses = [NSMutableArray array];
        self.groupClasses = [NSMutableArray array];
        NSDictionary * recordsetDic = [responseObject objectForKey:@"recordset"];
        if ([recordsetDic isKindOfClass:[NSDictionary class]]) {
            NSArray *rows = [recordsetDic objectForKey:@"rows"];
            if ([rows isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in rows) {
                    Room *room = [[Room alloc] initWithJSON: dic];
                    if (room.course.type_int == 0) {
                        [self.buddyClasses addObject:room];
                    }
                    if (room.course.type_int == 1) {
                        [self.groupClasses addObject:room];
                    }
//                    [dataArr addObject: room];
                }
            }
        }
        [self.mainTableview reloadData];
    
        [self.mainTableview.mj_header endRefreshing];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [self.mainTableview.mj_header endRefreshing];
    }];
    [self reachSlideData];
}

- (void)onClickUserCenter {
    NSLog(@"onClickUserCenter ----  ");

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //这里的id填刚刚设置的值,vc设置属性就可以给下个页面传参数了
    UserCenterViewController *vc = (UserCenterViewController *)[storyboard instantiateViewControllerWithIdentifier:@"userCenterVC"];
    vc.userInfo = self.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)clickCreateSessionTraining{
    NSLog(@"createSessionTraining ----  ");
    
    TrainingViewController *vc = [[TrainingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear %@",self.class);
}
@end
