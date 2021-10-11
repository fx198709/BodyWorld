//
//  CalendarView.m
//  日历
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 HEJJY. All rights reserved.
//

#import "CalendarView.h"
#import "PrefixHeader.h"

@interface CalendarView()

@property (nonatomic, weak) UIButton *preBtn;
@property (nonatomic, weak) UIButton *nextBtn;

@property (nonatomic, weak) UILabel *titleLable;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIView *dateView;

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *labelArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, assign) NSInteger days;
@property (nonatomic, assign) NSInteger firstDays;

@property (nonatomic, strong) NSDate *currentDate;


@end

@implementation CalendarView

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        
        _dateArray = [NSMutableArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    }
    return _dateArray;
}

// 获取日
- (NSInteger)getCurrentDay:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSInteger day = [components day];
    return day;
}

// 获取月
- (NSInteger)getCurrentMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSInteger month = [components month];
    return month;
}

// 获取年
- (NSInteger)getCurrentYear:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSInteger year = [components year];
    return year;
}

// 一个月有多少天
- (NSInteger)getTotalDaysInMonth:(NSDate *)date {
    
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

// 每月第一天
- (NSInteger)getFirstDayOfMonth:(NSDate *)date {

    NSInteger firstDayOfMonth = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
    return firstDayOfMonth;
}

// 上个月
- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

// 下个月
- (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = Color(244, 244, 244);
        
        _currentDate = [NSDate date];

        UIButton *preBtn = [[UIButton alloc] init];
        [preBtn setTitle:@"<<" forState:UIControlStateNormal];
        [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [preBtn addTarget:self action:@selector(preBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:preBtn];
        self.preBtn = preBtn;
        
        UIButton *nextBtn = [[UIButton alloc] init];
        [nextBtn setTitle:@">>" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextBtn];
        self.nextBtn = nextBtn;
        
        UILabel *titleLable = [[UILabel alloc] init];
        titleLable.text = @"2010年10月20日";
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.textColor = [UIColor whiteColor];
        [self addSubview:titleLable];
        self.titleLable = titleLable;
        
        
        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = [UIColor clearColor];
        [self addSubview:titleView];
        self.titleView = titleView;
        
        for (int i = 0; i < self.dateArray.count; i++) {
            
            UILabel *label = [[UILabel alloc] init];
            label.text = self.dateArray[i];
            label.textColor = Color(0, 176, 160);
            label.textAlignment = NSTextAlignmentCenter;
            [self.titleView addSubview:label];
            [self.labelArray addObject:label];
        }
        
        UIView *dateView = [[UIView alloc] init];
        dateView.backgroundColor = [UIColor clearColor];
        [self addSubview:dateView];
        self.dateView = dateView;
        
        [self loadWithDate:_currentDate];
    
    }
    return self;
}

- (void)loadWithDate:(NSDate *)date {
    
    // 移除所有
    if (self.buttonArray) {
        [self.buttonArray removeAllObjects];
    }
    
    if (self.dateView.subviews.count > 0) {
          [self.dateView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    // 获取当月有多少天
    _days = [self getTotalDaysInMonth:date];
    _firstDays = [self getFirstDayOfMonth:date];
    
    self.titleLable.text = [NSString stringWithFormat:@"%zd年%zd月%zd日",[self getCurrentYear:date],[self getCurrentMonth:date],[self getCurrentDay:date]];
    
    
    for (int i = 1; i <= _days; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:[NSString stringWithFormat:@"%zd",i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (i == [self getCurrentDay:[NSDate date]]) {
            
            button.backgroundColor = Color(0, 176, 160);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self.dateView addSubview:button];
        [self.buttonArray addObject:button];
    }
}

- (void)preBtnClick {
    
    NSDate *preDate = [self lastMonth:_currentDate];
    [self loadWithDate:preDate];
    
    [self setNeedsLayout];
    
    _currentDate = preDate;
    
}

- (void)nextBtnClick {
    
    NSDate *nextDate = [self nextMonth:_currentDate];
    [self loadWithDate:nextDate];
    
    [self setNeedsLayout];
    
    _currentDate = nextDate;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLable.frame = CGRectMake(0, 0, self.width, 40);
    
    self.preBtn.size = CGSizeMake(40, 40);
    self.preBtn.x = 0;
    self.preBtn.y = 0;
    
    self.nextBtn.size = CGSizeMake(40, 40);
    self.nextBtn.y = 0;
    self.nextBtn.x = self.width - self.nextBtn.width;
    
    
    self.titleView.frame = CGRectMake(0, self.titleLable.bottom, self.width, 40);
    
    for (int i = 0; i < self.labelArray.count; i++) {
        UILabel *label = self.labelArray[i];
        label.width = self.width / 7;
        label.height = self.titleView.height;
        label.y = 0;
        label.x = i * label.width;
        
    }
    
    self.dateView.frame = CGRectMake(0, self.titleView.bottom, self.width,  self.height - self.titleView.bottom);
    
    // 计算有多少行
    NSInteger row = (_firstDays % 7 + _days + 6) / 7;
    
    NSInteger colum = 7;
    CGFloat buttonH = self.dateView.height / row;
    CGFloat buttonW = self.dateView.width / 7;
    
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *button = self.buttonArray[i];
        button.width = buttonW;
        button.height = buttonH;
        button.x = (_firstDays % 7 + i) % colum * buttonW;
        button.y = (_firstDays % 7 + i) / colum * buttonH;

    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
