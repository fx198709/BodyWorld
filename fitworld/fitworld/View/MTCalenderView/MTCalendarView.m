//
//  MTCalendarView.m
//  MTCalender
//
//  Created by Tina on 2019/3/24.
//  Copyright © 2019年 Tina. All rights reserved.
//

#import "MTCalendarView.h"
#import "MTCalendarCell.h"
#import "MTCalenderModel.h"


#define MTCalendarCellIdentifier @"MTCalendarCell"

#define CellH 48

@interface MTCalendarView ()
<UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *calenderCollectionView;

@property (nonatomic, strong) NSArray *weekTitles;
@property (nonatomic, strong) NSMutableArray<MTCalenderModel *> *dateList;

@end

@implementation MTCalendarView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        NSArray *enTitles = @[ @"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"];
        NSArray *zhTitles = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
        self.weekTitles = ISChinese() ? zhTitles : enTitles;
        [self initView];
    }
    return self;
}

- (void)initView {
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.flowLayout.minimumLineSpacing = 0;
    self.flowLayout.minimumInteritemSpacing = 0;

    self.calenderCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 414, 200) collectionViewLayout:self.flowLayout];
    self.calenderCollectionView.delegate = self;
    self.calenderCollectionView.dataSource = self;
    self.calenderCollectionView.backgroundColor = [UIColor clearColor];
    self.calenderCollectionView.alwaysBounceVertical = NO;
    self.calenderCollectionView.showsVerticalScrollIndicator = NO;
    self.calenderCollectionView.showsHorizontalScrollIndicator = NO;
    self.calenderCollectionView.scrollEnabled = NO;
    
    Class cellClass = [MTCalendarCell class];
    [self.calenderCollectionView registerClass:cellClass forCellWithReuseIdentifier:MTCalendarCellIdentifier];
    [self addSubview:self.calenderCollectionView];
    [self.calenderCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self loadDataList];
}

- (void)loadDataList {
    self.dateList = [NSMutableArray array];
    if (self.endDate == nil) {
        self.endDate = [NSDate date];
    }
    if (self.startDate == nil) {
        self.startDate = [self.endDate mt_previousMonthDate];
    }
    
    NSDate *currentDate = self.startDate;
    NSInteger endMonth = self.endDate.mt_month;
    NSInteger endDay = self.endDate.mt_day;
    while (currentDate.mt_month < endMonth ||
           (currentDate.mt_month == endMonth &&currentDate.mt_day <= endDay)) {
        MTCalenderModel *model = [[MTCalenderModel alloc] initWithData:currentDate];
        [self.dateList addObject:model];
        currentDate = [currentDate mt_nextDate];
    }
    
    //开头添加空白日期
    NSInteger startDateNum = self.startDate.weekdayIndex - 1;
    MTCalenderModel *model = [[MTCalenderModel alloc] initWithData:nil];
    for (NSInteger i=0; i<startDateNum; i++) {
        [self.dateList insertObject:model atIndex:0];
    }
}


- (void)reloadData {
    [self loadDataList];
    [self.calenderCollectionView reloadData];
}


#pragma mark - delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.weekTitles.count + self.dateList.count;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MTCalendarCellIdentifier forIndexPath:indexPath];
    //标题栏
    if (indexPath.row < self.weekTitles.count) {
        cell.titleLabel.text = self.weekTitles[indexPath.row];
        cell.backgroundColor = [UIColor darkGrayColor];
    } else {
        //日期时间
        NSInteger index = indexPath.row - self.weekTitles.count;
        if (index < self.dateList.count) {
            cell.date = self.dateList[index];
        }
        cell.backgroundColor = self.backgroundColor;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize;
    CGFloat itemW = CGRectGetWidth(self.calenderCollectionView.frame) / self.weekTitles.count;
    NSInteger rowNums = self.weekTitles.count;
    if (self.dateList.count > 0) {
        rowNums = (self.dateList.count / self.weekTitles.count) + 1;
    }
    
    itemSize = CGSizeMake(itemW, CellH);
    return itemSize;
}

@end

