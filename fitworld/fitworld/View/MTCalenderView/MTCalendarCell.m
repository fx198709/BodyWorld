//
//  MTCalendarCell.m
//  MTCalender
//
//  Created by Tina on 2019/3/23.
//  Copyright © 2019年 Tina. All rights reserved.
//

#import "MTCalendarCell.h"
#import "UILabel+MTCalender.h"

@interface MTCalendarCell ()

@end

@implementation MTCalendarCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setDate:(MTCalenderModel *)date {
    _date = date;
    if (date.date == nil) {
        self.titleLabel.text = @"";
    } else {
        self.titleLabel.text = IntToString(date.date.mt_day);
    }
}



@end


