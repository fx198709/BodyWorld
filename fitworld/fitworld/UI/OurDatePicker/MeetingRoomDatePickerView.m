//
//  MeetingRoomDatePickerView.m
//  Ework
//
//  Created by Yiche on 2019/9/18.
//  Copyright © 2019 crm. All rights reserved.
//

#import "MeetingRoomDatePickerView.h"

@implementation MeetingRoomDatePickerView
#pragma mark - 添加pickerView方法

- (void)setIndate:(id)indate
{
    _indate = [CommonTools dateFromInDate:indate];
}

- (void)setRightIndate:(id)rightIndate
{
    _rightIndate = [CommonTools dateFromInDate:rightIndate];
}
- (void)setMaxdate:(id)maxdate{
    _maxdate = [CommonTools dateFromInDate:maxdate];
}
- (void)setMindate:(id)mindate{
    _mindate = [CommonTools dateFromInDate:mindate];
}
- (void)pickerViewWithView:(UIView*)view
{
//    _yearArray = @[@"今天"];
    UIView *inview = [CommonTools mainWindow];
    if (view) {
        inview = view;
    }
    int width = inview.frame.size.width;
    int height = inview.frame.size.height;
    if (IsIphoneX) {
        height -= IphoneXBottomHeight;
    }
    
    //添加蒙板
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    self.tag = 1000+[@"MeetingRoomDatePickerView" hash];
    self.frame = CGRectMake(0, 0, width, height);
    self.backgroundColor = [UIColor clearColor];
    UIButton *backButton = [[UIButton alloc] initWithFrame:self.bounds];
    backButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [backButton addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    self.userInteractionEnabled = YES;
    //添加pickerView  现在底部有按钮了 需要修改一下
    CGFloat pickerH = 216.0f;
    int BottomButtonHeight = 49; //底部按钮的高度
    
    //Y开始的地方  对iPhone X适配
    int startY = height - pickerH- BottomButtonHeight;
    int pickerwidth = ScreenWidth / 3.0;
    //底部加一个白色的view
    UIView *bottomBackview = [[UIView alloc] initWithFrame:CGRectMake(0,startY,width,pickerH)];
    bottomBackview.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomBackview];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, pickerwidth, pickerH)];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"今天";
//    label.font = SystemFontOfSize(17);
//     [self addSubview:label];
    self.yearPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,startY,pickerwidth,pickerH)];
    [self addSubview:self.yearPicker];
    self.yearPicker.delegate = self;
    self.yearPicker.dataSource = self;
    [self addSubview:self.yearPicker];
   
    self.leftPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,startY,pickerwidth,pickerH)];
    self.leftPicker.datePickerMode = UIDatePickerModeDate;
    
     if (@available(iOS 13.4, *)) {
         self.leftPicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
     }
    self.leftPicker.frame = CGRectMake(0,startY,pickerwidth,pickerH);
    //监听DataPicker的滚动
    [self.leftPicker addTarget:self action:@selector(leftDateChange:) forControlEvents:UIControlEventValueChanged];
    
    if (_leftmaxDate) {
        self.leftPicker.maximumDate = self.leftmaxDate;
    }
    NSDate *defaultDate = nil;
    defaultDate = [NSDate date];
    if (_indate) {
        defaultDate = _indate;
    }
    else
    {
        if (_minuteInterval > 1) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
            [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*60*60]];
            formatter.dateFormat = @"mm";
            NSString *minuteString = [formatter stringFromDate:defaultDate];
            formatter.dateFormat = @"yyyy-MM-dd HH";
            NSString *hourString = [formatter stringFromDate:defaultDate];
            int minute =(minuteString.intValue)/_minuteInterval*_minuteInterval;
            NSString *defaultString = [NSString stringWithFormat:@"%@:%d",hourString,minute];
            defaultDate = [CommonTools dateFromInDate:defaultString];
        }
    }
    self.leftPicker.date = defaultDate;
    self.leftPicker.backgroundColor=[UIColor whiteColor];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.leftPicker.locale = locale;
    [self addSubview:self.leftPicker];
    
    self.leftPicker.datePickerMode = UIDatePickerModeTime;
    if (_minuteInterval > 1) {
        self.leftPicker.minuteInterval = _minuteInterval;
    }
    //传入的默认值 给左边的赋值
    if (self.indate) {
        self.leftPicker.date = self.indate;
    }
    
    self.leftPicker.frame = CGRectMake(pickerwidth,startY,pickerwidth,pickerH);
    self.rightPicker= [ [ UIDatePicker alloc] initWithFrame:CGRectMake(ScreenWidth-pickerwidth,startY,pickerwidth,pickerH)];
    self.rightPicker.datePickerMode = UIDatePickerModeTime;
    
     if (@available(iOS 13.4, *)) {
         self.rightPicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
     }
    self.rightPicker.backgroundColor=[UIColor whiteColor];
    //            self.rightPicker.minimumDate = self.leftPicker.date;
    self.rightPicker.frame = CGRectMake(ScreenWidth-pickerwidth,startY,pickerwidth,pickerH);
    if (self.maxdate) {
        self.rightPicker.maximumDate = self.maxdate;
    }
    if (self.mindate) {
        self.rightPicker.minimumDate = self.mindate;
    }
    
    if (_minuteInterval > 1) {
        self.rightPicker.minuteInterval = _minuteInterval;
    }
    NSLocale *mylocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    self.rightPicker.locale = mylocale;
//    [self.rightPicker addTarget:self action:@selector(rightDateChange:) forControlEvents:UIControlEventValueChanged];
    //这边处理外面传入的值
    if (self.rightIndate) {
        self.rightPicker.date = self.rightIndate;
    }
    
    [self addSubview:self.rightPicker];
    
    self.leftPicker.locale = mylocale;
    
    UILabel *vlabel = [[UILabel alloc] initWithFrame:CGRectMake(1*pickerwidth+30, startY+pickerH/2-50/2-2, 60, 50)];
    vlabel.text = @":";
    vlabel.font = SystemFontOfSize(25);
    vlabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:vlabel];
    UILabel *vlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(2*pickerwidth+30, startY+pickerH/2-50/2-2, 60, 50)];
    vlabel2.text = @":";
    vlabel2.font = SystemFontOfSize(25);
    vlabel2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:vlabel2];
    
    
    //底部按钮视图 对iPhone X 适配
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,height - BottomButtonHeight,width,BottomButtonHeight)];
    bottomView.userInteractionEnabled = YES;
    [self addSubview:bottomView];
    [self bringSubviewToFront:bottomView];
    UIButton * leftButton = [self createbuttonisLeft:YES];
    [bottomView addSubview:leftButton];
    
    UIButton * rightButton = [self createbuttonisLeft:NO];
    [bottomView addSubview:rightButton];
    
    
    [inview addSubview:self];
}
- (void)leftDateChange:(UIDatePicker *)datePicker{
    NSString *currentdateStr = [CommonTools reachFormateDateStringFromInDate:datePicker.date withFormat:@"HH:mm"];
    CGFloat currentDate = [currentdateStr stringByReplacingOccurrencesOfString:@":" withString:@"."].floatValue;
  
    if (currentDate >= 23.44) {
        NSString *todayDateStr = [CommonTools reachFormateDateStringFromInDate:[NSDate new] withFormat:@"yyyy-MM-dd"];
        NSString *terminalDateStr = [NSString stringWithFormat:@"%@ 23:44",todayDateStr];
        datePicker.date = [CommonTools dateFromInDate:terminalDateStr];
        NSDate *rightDate = [datePicker.date dateByAddingTimeInterval:15*60];
        self.rightPicker.minimumDate = rightDate;
        self.rightPicker.maximumDate = rightDate;
        return;
    }
    
    NSDate *minDate = [datePicker.date dateByAddingTimeInterval:15*60];
    NSDate *maxDate = [datePicker.date dateByAddingTimeInterval:2*60*60];
    self.rightPicker.minimumDate = minDate;
    self.rightPicker.maximumDate = maxDate;
 
}
//- (void)rightDateChange:(UIDatePicker *)datePicker{
//    NSDate *minDate = [datePicker.date dateByAddingTimeInterval:-15*60];
//    NSDate *maxDate = [datePicker.date dateByAddingTimeInterval:-2*60*60];
//    self.leftPicker.minimumDate = minDate;
//    self.leftPicker.maximumDate = maxDate;
//}
#pragma mark - 点击取消的方法
- (void)cancelPicker {
    //不麻烦了，把自己删除了
    [self removeFromSuperview];
    if ([_pickerDelegate respondsToSelector:@selector(dateViewCancelButtonClicked)]) {
        [_pickerDelegate dateViewCancelButtonClicked];
    }
}

#pragma mark - 点击确认的方法
- (void)oKPicker
{

    //这边左右2个 都是显示 时 分的
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *leftString = [formatter stringFromDate:_leftPicker.date];
    NSString *rightString = [formatter stringFromDate:_rightPicker.date];
//    NSString *dateString = [NSString stringWithFormat:@"%@-%@",leftString,[rightString componentsSeparatedByString:@" "].lastObject];
    if ([_pickerDelegate respondsToSelector:@selector(seletedTwoHourAndMinuteDate:emdTime:)]) {
        [_pickerDelegate seletedTwoHourAndMinuteDate:leftString emdTime:rightString];
    }

    [self removeFromSuperview];
    
}
#pragma  mark UIPickerViewDelegate
// returns the # of rows in each component..
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return _yearArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [_yearArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedYearID = (int)row;
}

- (void)dealloc{
    [self removeFromSuperview];
}

@end
