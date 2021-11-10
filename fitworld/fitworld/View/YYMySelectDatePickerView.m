//
//  YYMySelectDatePickerView.m
//  BAIHC
//
//  Created by xiejc on 2019/4/29.
//  Copyright © 2019 YYCloud. All rights reserved.
//

#import "YYMySelectDatePickerView.h"
#import "UIView+MTWindow.h"

@interface YYMySelectDatePickerView ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;

@end

@implementation YYMySelectDatePickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cancelBtn.exclusiveTouch = self.selectBtn.exclusiveTouch = YES;
    
    self.titleLabel.text = self.title;
    if (@available(iOS 13.4, *)) {
        self.pickerView.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//新发现这里不会根据系统的语言变了
        self.pickerView.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    [self loadData];
}

- (void)setBeginDate:(NSDate *)beginDate {
    _beginDate = beginDate;
    self.pickerView.minimumDate = self.beginDate;
}

- (void)setEndData:(NSDate *)endData {
    _endData = endData;
    self.pickerView.maximumDate = self.endData;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = self.title;
}

- (void)loadData {
    self.pickerView.minimumDate = self.beginDate;
    self.pickerView.maximumDate = self.endData;
    self.titleLabel.text = self.title;
}


- (IBAction)select:(id)sender {
    NSLog(@"====date picker did select :%@", self.pickerView.date);

    [self hideAnimated:NO completedBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectDatePickerDidSelectDate:)]) {
            [self.delegate selectDatePickerDidSelectDate:self.pickerView.date];
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self hideAnimated:NO completedBlock:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectDatePickerDidClickCancel)]) {
            [self.delegate selectDatePickerDidClickCancel];
        }
    }];
}


- (void)showWithAnimated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock {
    [self showPopAnimated:animated containerView:self.containerView completedBlock:completedBlock];
}

- (void)hideAnimated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock {
    [self hidePopAnimated:animated containerView:self.containerView completedBlock:^{
        if (completedBlock) {
            completedBlock();
        }
    }];
}



- (void)clearData {
    self.beginDate = nil;
    self.endData = nil;
    self.title = nil;
}



@end
