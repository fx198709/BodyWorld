//
//  OurYearMonthDayDatePickerView.m
//  Ework
//
//  Created by Yiche on 2019/10/22.
//  Copyright © 2019 crm. All rights reserved.
//

#import "OurYearMonthDayDatePickerView.h"

@implementation OurYearMonthDayDatePickerView

#pragma mark - 添加pickerView方法
- (void)pickerViewWithView:(UIView*)view{
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
    self.tag = 1000+[@"OurYearMonthDayDatePickerView" hash];
    self.frame = CGRectMake(0, 0, width, height);
    self.backgroundColor = [UIColor clearColor];
    UIButton *backButton = [[UIButton alloc] initWithFrame:self.bounds];
    backButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [backButton addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    self.userInteractionEnabled = YES;
    
    //添加pickerView
    CGFloat pickerH = 216.0f;
    int BottomButtonHeight = 49; //底部按钮的高度
    int startY = height - pickerH - BottomButtonHeight;
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,startY,ScreenWidth,pickerH)];
    if (self.dateMode == DateModeTypeYearMonthDay) {
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    }else{
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
     if (@available(iOS 13.4, *)) {
         self.datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
     }
    self.datePicker.frame = CGRectMake(0,startY,ScreenWidth,pickerH);
    if (self.maxDate) {
        self.datePicker.maximumDate = self.maxDate;
    }else{
        self.datePicker.minimumDate = [NSDate date];
    }
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.datePicker];
    
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
    
//    [window addSubview:self.coverView];
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

//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy年MM月dd日";
//    NSString *leftString = [formatter stringFromDate:self.datePicker.date];

    if ([_pickerDelegate respondsToSelector:@selector(seletedDate:andview:)]) {
        [_pickerDelegate seletedDate:self.datePicker.date andview:self];
    }
    
    [self removeFromSuperview];
    
}
- (void)dealloc{
    [self removeFromSuperview];
}

@end
