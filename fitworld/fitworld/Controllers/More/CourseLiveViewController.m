//
//  YJListViewController.m
//  YJPageController
//
//  Created by 于英杰 on 2019/4/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "CourseLiveViewController.h"
#import "YJPageControlView.h"
#import "UIDeps.h"
#import "AFNetworking.h"
#import "FITAPI.h"
#import "Room.h"
#import <math.h>
#import "HeadTimeCollectionViewCell.h"
#import "CourseMoreController.h"
#import "CourseDetailViewController.h"
#import "CreateCourseSuccessViewController.h"

@interface CourseLiveViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic,strong)UITableView*tableView;
@end

@implementation CourseLiveViewController{
    NSArray *weekDays;
    NSMutableArray *dataArr;
    UICollectionView *collectionView;
    NSMutableArray *dayArrs;
    NSString *selectDay;
    BOOL isLoading;
    int _pageCount;
    BOOL _isLoadAllData; //是否加载所有的数据，每次刷新的时候，都设置成no， 接口返回的数据小于需要的数量时，设置成yes
    NSURLSessionDataTask *requestTask;//请求用的task
}

- (void)viewDidLoad {
    weekDays = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun"];
    dayArrs = [[NSMutableArray alloc] init];

    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    if (self.pageVCindex != 0) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2;
        layout.minimumInteritemSpacing = 2;
        layout.itemSize = CGSizeMake((ScreenWidth - 20) / 8, 60);
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = BuddyTableBackColor;
        collectionView.showsVerticalScrollIndicator = NO;   //是否显示滚动条
        collectionView.scrollEnabled = YES;  //滚动使能
        collectionView.allowsSelection = YES;
        collectionView.allowsMultipleSelection = NO;
        collectionView.collectionViewLayout = layout;
        //3、添加到控制器的view
        [self.view addSubview:collectionView];
        [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(10);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.right.equalTo(self.view.mas_right).offset(-10);
            make.height.mas_equalTo(62);
        }];
        [collectionView registerClass:[HeadTimeCollectionViewCell class] forCellWithReuseIdentifier:@"collectCell"];
        collectionView.dataSource = self;
        collectionView.delegate = self;
    }


    
    _tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BuddyTableBackColor;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.pageVCindex != 0){
            make.top.equalTo(collectionView.mas_bottom).offset(20);
        }else{
            make.top.equalTo(self.view);
        }
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view);
    }];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = UIColor.blackColor;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupRefresh];
    self.tableView.mj_header.backgroundColor = UIColor.blackColor;
    self.tableView.mj_footer.backgroundColor = UIColor.blackColor;

    [self headerRereshing];
    
}

- (void)reReahSearchData{
    [self headerRereshing];
//    [self refreshData];
//    course_type=31035841618905604,31035841619102212&course_time=1200,3000&
}
- (void)reloadTabelviewCell{
    if (dataArr.count>0) {
        [self.tableView reloadData];
    }
}

 
#pragma mark TableViewDelegate&DataSource

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 10)];
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 20)];
    grayView.layer.cornerRadius =10;
    grayView.clipsToBounds = YES;
    grayView.backgroundColor = BuddyTableBackColor;
    [view addSubview:grayView];
    view.clipsToBounds = YES;
    return view;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 10)];
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, -10, ScreenWidth-20, 20)];
    grayView.layer.cornerRadius =10;
    grayView.clipsToBounds = YES;
    grayView.backgroundColor = BuddyTableBackColor;
    [view addSubview:grayView];
    view.clipsToBounds = YES;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (dataArr.count >0) {
        return 10;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (dataArr.count >0) {
        return 10;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    RemoveSubviews(cell.contentView, @[]);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BuddyTableBackColor;
    int leftdif = 15;

    Room *room = dataArr[indexPath.row];
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
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = room.course.name;
    label1.font = [UIFont systemFontOfSize:17];
    label1.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(20);
        make.left.equalTo(leftImageView.mas_right).offset(leftdif+25);
    }];
    UIImage *classimage = [UIImage imageNamed:[NSString stringWithFormat:@"more_type_icon%ld",room.type_int]];
    UIImageView *classimageview = [[UIImageView alloc] initWithImage:classimage];
    [cell.contentView addSubview:classimageview];
    [classimageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label1);
        make.left.equalTo(leftImageView.mas_right).offset(leftdif);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    UILabel *label2left = [[UILabel alloc] init];
    if (room.type_int == 0) {
        label2left.text = ChineseStringOrENFun(@"创建人:", @"creater:");
    }else if (room.type_int == 1){
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
    label2left.textColor = LittleTextColor;
    UILabel *label2 = [[UILabel alloc] init];
    if (room.type_int == 0) {
        label2.text = room.room_creator.nickname;
    }else if (room.type_int == 1){
        label2.text = room.coach.nickname;
    }else{
        label2.text = @"";
    }
    [cell.contentView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.left.equalTo(label2left.mas_right).offset(1);
    }];
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = LittleTextColor;
    NSString *countryUrl = @"";
    if (room.type_int == 0) {
        countryUrl = [room.room_creator.country_icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];;
    }else if (room.type_int == 1){
//        教练图标
        countryUrl = room.coach.country;
    }
    
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
    label3.textColor = LittleTextColor;
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
            limitLabel.textColor = LittleTextColor;
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
            limitLabel.textColor = LittleTextColor;
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
    if (indexPath.row != dataArr.count -1) {
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
//    YJTwoViewController *vc = [[YJTwoViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:true];
    if (dataArr.count > indexPath.row) {
        Room *selectRoom = [dataArr objectAtIndex: indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //这里的id填刚刚设置的值,vc设置属性就可以给下个页面传参数了
        if (selectRoom.is_join) {
            CreateCourseSuccessViewController *vc =[[CreateCourseSuccessViewController alloc] initWithNibName:@"CreateCourseSuccessViewController" bundle:nil];
            vc.event_id = selectRoom.event_id;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            CourseDetailViewController *vc = (CourseDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"courseDetailVC"];
            vc.selectRoom = selectRoom;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HeadTimeCollectionViewCell *cell = (HeadTimeCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"collectCell" forIndexPath:indexPath];
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:today];
//    NSInteger day = [weekdayComponents day];
    NSInteger weekday = [weekdayComponents weekday] - 1;
    NSInteger i = indexPath.item;
    [cell addSubviews];
    NSInteger index_weekday = (weekday + i) - 1;
    if(index_weekday > 6){
        index_weekday = labs(7 - (index_weekday));
    }
    if(index_weekday == -1){
        index_weekday = 6;
    }
       
    NSDate *nextDate = [NSDate date];
    NSInteger interval = i * 60 * 60 * 24;
    nextDate = [nextDate dateByAddingTimeInterval:interval];
    NSLog(@"nextDay is %@", nextDate);
    [dayArrs addObject:nextDate];
    NSDateComponents *nextDayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:nextDate];
    NSInteger nextDay = [nextDayComponents day];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = UIColor.whiteColor;
//    赋值的位置换一下
    cell.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)nextDay];
    cell.weekLabel.text = weekDays[index_weekday];
    if(indexPath.item == 0){
        [cell changeSelected];
    }else{
        [cell changeunSelected];

    }
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
    NSArray<HeadTimeCollectionViewCell *> *allCellArray = [collectionView visibleCells];
    for(HeadTimeCollectionViewCell *cell in allCellArray){
        [cell changeunSelected];
    }
    HeadTimeCollectionViewCell *selectedCell = (HeadTimeCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [selectedCell changeSelected];
    NSDate *selectDate = [dayArrs objectAtIndex:indexPath.item];
    NSLog(@"selectDate %@", selectDate);
    NSDateFormatter *f = [NSDateFormatter new];
    NSString *ft = @"Y-MM-dd";
    //[f setDateStyle:NSDateFormatterFullStyle];
    [f setDateFormat:ft];
    selectDay = [f stringFromDate: selectDate];
    [self headerRereshing];
}

- (void)joinBtnClicked:(UIButton*)btn{
    int tag = (int)btn.tag - 100;
    if (dataArr.count > tag) {
        Room *selectedRoom = [dataArr objectAtIndex:tag];
        [[APPObjOnce sharedAppOnce] joinRoom:selectedRoom withInvc:self];
    }
    NSLog(@"Join");
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
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}
//开始进入刷新状态
- (void)headerRereshing
{
    //下拉刷新，先还原上拉“已加载全部数据”的状态
    [self.tableView.mj_footer resetNoMoreData];
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
       
        if(selectDay == nil){
            NSDate *toDay = [[NSDate alloc] init];
            NSDateFormatter *f = [NSDateFormatter new];
            NSString *ft = @"yyyy-MM-dd";
            [f setDateFormat:ft];
            NSString *currentDay = [f stringFromDate: toDay];
            selectDay = currentDay;
        }
    //    [dataArr removeAllObjects];
        NSMutableDictionary *baddyParams = [NSMutableDictionary dictionary];
        if (_pageVCindex == 0) {
    //        直播课
            [baddyParams setValue:@"1" forKey:@"status"];
        }else if (_pageVCindex == 1) {
            [baddyParams setValue:@"团课" forKey:@"type"];
        }else if (_pageVCindex == 2) {
            [baddyParams setValue:@"对练课" forKey:@"type"];
        }
        [baddyParams setValue:selectDay forKey:@"day"];
        CourseMoreController *vc = (CourseMoreController*)self.parentVC;
        [vc reachSeletedValue:^(NSString *typeSelected, NSString *timeSelected) {
            [baddyParams setValue:typeSelected forKey:@"course_type"];
            [baddyParams setValue:timeSelected forKey:@"course_time"];
        }];
        
        [baddyParams setValue:@"20" forKey:@"row"];
        [baddyParams setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
        
        requestTask = [manager GET:@"room" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
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
                    NSError *error;
                    Room *room = [[Room alloc] initWithDictionary:dataArray[i] error:&error];
                    [self->dataArr addObject: room];
                }
                
                if (isLoadHead) {
                    [self.tableView.mj_header endRefreshing];
                }
                else
                {
                    [self loadNextPageData];
                }
            

                [self.tableView reloadData];
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

    [self.tableView.mj_footer endRefreshing];
    if (_isLoadAllData) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}




@end
