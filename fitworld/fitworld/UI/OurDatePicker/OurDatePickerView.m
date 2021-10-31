//
//  OurDatePickerView.m
//  Ework
//
//  Created by feixiang on 2016/9/30.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "OurDatePickerView.h"
#import "CommonTools.h"
@implementation OurDatePickerView



#pragma mark - 添加pickerView方法

- (void)setIndate:(id)indate
{
    _indate = [CommonTools dateFromInDate:indate];
}

- (void)setRightIndate:(id)rightIndate
{
    _rightIndate = [CommonTools dateFromInDate:rightIndate];
}
- (void)pickerViewWithView:(UIView*)view
{
    _yearArray = @[@"2020年",@"2021年"];
    UIView *inview = [CommonTools mainWindow];
    if (view) {
        inview = view;
    }
    int width = inview.frame.size.width;
    int height = inview.frame.size.height;
//    if (IsIphoneX) {
//        height -= IphoneXBottomHeight;
//    }

    //添加蒙板
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    self.frame = CGRectMake(0, 0, width, height);
    self.tag = 1000+[@"OurDatePickerView" hash];
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
    
    //底部加一个白色的view
    UIView *bottomBackview = [[UIView alloc] initWithFrame:CGRectMake(0,startY,width,pickerH)];
    bottomBackview.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomBackview];

    self.leftPicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0,startY,width,pickerH)];
    self.leftPicker.datePickerMode = UIDatePickerModeDate;
    
     if (@available(iOS 13.4, *)) {
         self.leftPicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
     }
    self.leftPicker.frame = CGRectMake(0,startY,width,pickerH);
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
//            [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
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
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    self.leftPicker.locale = locale;
    self.leftPicker.frame = CGRectMake(0,startY,width,pickerH);
    [self addSubview:self.leftPicker];

    switch (self.pickerType) {
        case YearMonDayAndHourMinute:
        {
            //IOS9 以下的选择器不太一样
            
                int leftPickerWidth = 240;
                if (width > 330) {
                    leftPickerWidth = 240*width/320;
                }
                self.leftPicker.datePickerMode = UIDatePickerModeDate;
                self.leftPicker.frame = CGRectMake(0,startY,leftPickerWidth,pickerH);
                self.rightPicker= [ [ UIDatePicker alloc] initWithFrame:CGRectMake(leftPickerWidth-18,startY,width-leftPickerWidth+18,pickerH)];
                
                 if (@available(iOS 13.4, *)) {
                     self.rightPicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
                 }
                self.rightPicker.datePickerMode = UIDatePickerModeTime;
                self.rightPicker.frame = CGRectMake(leftPickerWidth-18,startY,width-leftPickerWidth+18,pickerH);
                self.rightPicker.backgroundColor=[UIColor whiteColor];
                if (_minuteInterval > 1) {
                    self.rightPicker.minuteInterval = _minuteInterval;
                }
                NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
                self.rightPicker.locale = locale;
                self.rightPicker.date = defaultDate;
                [self addSubview:self.rightPicker];
            

        }
            break;
        case YearMonAndDay:
        {
            self.leftPicker.datePickerMode = UIDatePickerModeDate;
        }
            break;
        case HourAndMinute:
        {
            self.leftPicker.datePickerMode = UIDatePickerModeTime;
        }
            break;
        case MonDayAndHourMinute:
        {
            self.leftPicker.datePickerMode = UIDatePickerModeDateAndTime;
        }
            break;
        case ModeCountDownTimer:
        {
            self.leftPicker.datePickerMode =UIDatePickerModeCountDownTimer;
        }
            break;
        case TwoHourAndMinute:
        {
            self.leftPicker.datePickerMode = UIDatePickerModeTime;
            if (_minuteInterval > 1) {
                self.leftPicker.minuteInterval = _minuteInterval;
            }
            //传入的默认值 给左边的赋值
            if (self.indate) {
                self.leftPicker.date = self.indate;
            }
            int pickerwidth = ScreenWidth /2;
            self.leftPicker.frame = CGRectMake(0,startY,pickerwidth,pickerH);
            self.rightPicker= [ [ UIDatePicker alloc] initWithFrame:CGRectMake(ScreenWidth-pickerwidth,startY,pickerwidth,pickerH)];
            
             if (@available(iOS 13.4, *)) {
                 self.rightPicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
             }
            self.rightPicker.datePickerMode = UIDatePickerModeTime;
            self.rightPicker.frame = CGRectMake(ScreenWidth-pickerwidth,startY,pickerwidth,pickerH);
            self.rightPicker.backgroundColor=[UIColor whiteColor];
//            self.rightPicker.minimumDate = self.leftPicker.date;
            if (_minuteInterval > 1) {
                self.rightPicker.minuteInterval = _minuteInterval;
            }
            NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
            self.rightPicker.locale = locale;
            //这边处理外面传入的值
            if (self.rightIndate) {
                self.rightPicker.date = self.rightIndate;
            }
            
            [self addSubview:self.rightPicker];
            
            self.leftPicker.locale = locale;
            
            UILabel *vlabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2- 60/2, startY+pickerH/2-50/2, 60, 50)];
            vlabel.text = @"-";
            vlabel.font = SystemFontOfSize(30);
            vlabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:vlabel];
            
        }
            break;
        default:
            break;
    }
    
    
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
//    self.coverView.alpha = 0.1;
//    self.coverView.hidden = NO;
//    [UIView animateWithDuration:0.35 animations:^(){
//        self.coverView.alpha = 1;
//    }completion:^(BOOL finish){
//    }];
}


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
     
     if (self.pickerType == YearMonDayAndHourMinute) {
        
             //把左右两边的时间合起来
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             formatter.dateFormat = @"yyyy-MM-dd";
             NSString *leftString = [formatter stringFromDate:_leftPicker.date];
             formatter.dateFormat = @"HH:mm";
             NSString *rightString = [formatter stringFromDate:_rightPicker.date];
             NSString *dateString = [NSString stringWithFormat:@"%@ %@",leftString,rightString];
             formatter.dateFormat = @"yyyy-MM-dd HH:mm";
             NSDate *date = [formatter dateFromString:dateString];
             if ([_pickerDelegate respondsToSelector:@selector(seletedDate:andview:)]) {
                 [_pickerDelegate seletedDate:date andview:self];
             }
             
     }
     else if(self.pickerType == TwoHourAndMinute) {
         //这边左右2个 都是显示 时 分的
         
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         formatter.dateFormat = @"HH:mm";
         NSString *leftString = [formatter stringFromDate:_leftPicker.date];
         NSString *rightString = [formatter stringFromDate:_rightPicker.date];
         NSString *dateString = [NSString stringWithFormat:@"%@-%@",leftString,rightString];
         if ([_pickerDelegate respondsToSelector:@selector(seletedTwoHourAndMinuteDate:)]) {
             [_pickerDelegate seletedTwoHourAndMinuteDate:dateString];
         }
     }
     else
     {
         if ([_pickerDelegate respondsToSelector:@selector(seletedDate:andview:)])
         {
             [_pickerDelegate seletedDate:_leftPicker.date andview:self];
         }
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
