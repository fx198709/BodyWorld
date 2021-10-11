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

@interface CourseLiveViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic,strong)UITableView*tableView;
@end

@implementation CourseLiveViewController{
    NSArray *weekDays;
    NSMutableArray *dataArr;
    UICollectionView *collectionView;
    NSMutableArray *dayArrs;
    NSString *selectDay;
}

- (void)viewDidLoad {
    weekDays = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun"];
    dayArrs = [[NSMutableArray alloc] init];

    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    
    CGFloat itemW = (self.view.bounds.size.width - 20) / 8;
    layout.itemSize = CGSizeMake(itemW, itemW);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor darkGrayColor];
    collectionView.showsVerticalScrollIndicator = NO;   //是否显示滚动条
    collectionView.scrollEnabled = YES;  //滚动使能
    collectionView.allowsSelection = YES;
    collectionView.allowsMultipleSelection = NO;
    //3、添加到控制器的view
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(5);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(45);
    }];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectCell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..." attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = UIColor.blackColor;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self refreshData];
    
}

-(UITableView*)tableView{
    
    if (_tableView==nil) {
        CGRect frame =CGRectMake(0, 80, kScreenWidth, _viewheight - 90);
        _tableView=[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
    
}
#pragma mark TableViewDelegate&DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
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
    cell.backgroundColor = UIColor.greenColor;
    
    UIView *cellBgView = [[UIView alloc] init];
    [cellBgView.layer setMasksToBounds:YES];
    [cellBgView.layer setCornerRadius:12];
    cellBgView.backgroundColor = UIColor.darkGrayColor;
    [cell addSubview:cellBgView];
    [cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(10);
        make.right.equalTo(cell.mas_right).offset(-10);
        make.top.equalTo(cell).offset(30);
        make.bottom.equalTo(cell);
    }];

    Room *room = dataArr[indexPath.row];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 100, 100)];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, room.course.pic]]];
    [cell addSubview:leftImageView];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = room.course.name;
    [cellBgView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellBgView).offset(10);
        make.left.equalTo(leftImageView.mas_right).offset(10);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = room.course.coach_name;
    [cellBgView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1).offset(20);
        make.left.equalTo(leftImageView.mas_right).offset(10);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = room.updated_at;
    [cellBgView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2).offset(20);
        make.left.equalTo(leftImageView.mas_right).offset(10);
    }];
    
    UIButton *joinBtn = [[UIButton alloc] init];
    [joinBtn setTitle:@"Join" forState:UIControlStateNormal];
    joinBtn.backgroundColor = UIColor.redColor;
    [joinBtn addTarget:self action:@selector(joinBtn) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cellBgView).offset(-10);
        make.centerY.equalTo(cellBgView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
    }];
    cell.backgroundColor = UIColor.blackColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    YJTwoViewController *vc = [[YJTwoViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:true];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectCell" forIndexPath:indexPath];
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:today];
    NSInteger day = [weekdayComponents day];
    NSInteger weekday = [weekdayComponents weekday] - 1;
    NSInteger i = indexPath.item;
    
    UILabel *label1 = [[UILabel alloc] init];
    NSInteger index_weekday = (weekday + i) - 1;
    NSLog(@"index_weekday - %d", index_weekday);
    if(index_weekday > 6){
        index_weekday = abs(7 - (index_weekday));
    }
    if(index_weekday == -1){
        index_weekday = 6;
    }
    label1.text = weekDays[index_weekday];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = UIColor.whiteColor;
    label1.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(cell).offset(5);
        make.right.equalTo(cell).offset(-5);
        make.height.mas_equalTo(15);
    }];
    
    NSDate *nextDate = [NSDate date];
    NSInteger interval = i * 60 * 60 * 24;
    nextDate = [nextDate dateByAddingTimeInterval:interval];
    NSLog(@"nextDay is %@", nextDate);
    [dayArrs addObject:nextDate];
    NSDateComponents *nextDayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:nextDate];
    NSInteger nextDay = [nextDayComponents day];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = UIColor.whiteColor;
    label2.text = [NSString stringWithFormat:@"%d", nextDay];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(3);
        make.left.equalTo(cell).offset(5);
        make.right.equalTo(cell).offset(-5);
        make.height.mas_equalTo(15);
    }];
    
    if(indexPath.item == 0){
        cell.backgroundColor = UIColor.redColor;
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"didSelectItemAtIndexPath");
    NSArray<UICollectionViewCell *> *allCellArray = [collectionView visibleCells];
    for(UICollectionViewCell *cell in allCellArray){
        cell.backgroundColor = UIColor.darkGrayColor;
    }
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
    selectedCell.backgroundColor = UIColor.redColor;
    NSDate *selectDate = [dayArrs objectAtIndex:indexPath.item];
    NSLog(@"selectDate %@", selectDate);
    NSDateFormatter *f = [NSDateFormatter new];
    NSString *ft = @"Y-MM-dd";
    //[f setDateStyle:NSDateFormatterFullStyle];
    [f setDateFormat:ft];
    selectDay = [f stringFromDate: selectDate];
    [self refreshData];
}

- (void)joinBtn{
    NSLog(@"Join");
}

#pragma mark - 刷新房间数据
- (void) refreshData
{
    NSDate *toDay = [[NSDate alloc] init];
    NSDateFormatter *f = [NSDateFormatter new];
    NSString *ft = @"Y-MM-dd";
    [f setDateFormat:ft];
    NSString *currentDay = [f stringFromDate: toDay];
    if(selectDay == nil){
        selectDay = currentDay;
    }
    
    [dataArr removeAllObjects];
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSLog(@"initroom userToken ---- %@", userToken);

    NSString *strUrl = [NSString stringWithFormat:@"%@room", FITAPI_HTTPS_PREFIX];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSDictionary *baddyParams = @{
                           @"type": @"对练课",
                           @"page": @"1",
                           @"row": @"5",
                           @"day": selectDay
                       };
    [manager GET:strUrl parameters:baddyParams headers:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject ---- %@", responseObject);
        long total =  [responseObject[@"recordset"][@"total"] longValue];
        if(total > 0){
            Room *room = [[Room alloc] initWithJSON: responseObject[@"recordset"][@"rows"][0]];
            dataArr = [[NSMutableArray alloc] init];
            [dataArr addObject: room];
        }
        [self.tableView reloadData];
        if ([self.tableView.refreshControl isRefreshing]) {
            [self.tableView.refreshControl endRefreshing];
        }
        
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"failure ---- %@", error);
    }];
}

@end
