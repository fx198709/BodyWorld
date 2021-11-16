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


    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..." attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
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
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.tableView.refreshControl = refreshControl;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = UIColor.blackColor;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self refreshData];
    
}

 
#pragma mark TableViewDelegate&DataSource

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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = BuddyTableBackColor;
    RemoveSubviews(cell.contentView, @[]);
    int leftdif = 15;

    Room *room = dataArr[indexPath.row];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,22, 56, 56)];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, room.course.pic]]];
    [cell.contentView addSubview:leftImageView];
    leftImageView.clipsToBounds = YES;
    leftImageView.layer.cornerRadius = 28;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = room.course.name;
    label1.font = [UIFont systemFontOfSize:17];
    label1.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView).offset(20);
        make.left.equalTo(leftImageView.mas_right).offset(leftdif);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = room.room_creator.nickname;
    [cell.contentView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.left.equalTo(leftImageView.mas_right).offset(leftdif);
    }];
    label2.font = [UIFont systemFontOfSize:15];
    label2.textColor = LittleTextColor;

    UIImageView *countryImageView = [[UIImageView alloc] init];
    [countryImageView sd_setImageWithURL:[NSURL URLWithString:room.room_creator.country_icon]];
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

    UIButton *joinBtn = [[UIButton alloc] init];
    [joinBtn setTitle:@"Join" forState:UIControlStateNormal];
    [joinBtn addTarget:self action:@selector(joinBtn) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:joinBtn];
    [joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-10);
        make.centerY.equalTo(cell.contentView);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(80);
    }];
    UIImage *image = [UIImage imageNamed:@"action_button_bg_red1"];
    [joinBtn setBackgroundImage:image forState:UIControlStateNormal];
    [joinBtn setBackgroundImage:image forState:UIControlStateHighlighted];
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
            self->dataArr = [[NSMutableArray alloc] init];
            [self->dataArr addObject: room];
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
