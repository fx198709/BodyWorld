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
        make.height.mas_equalTo(self.mas_height).multipliedBy(0.7);
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(self.titleLabel.mas_height).multipliedBy(1.0);
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

- (void)setIsMark:(BOOL)isMark {
    self.titleLabel.backgroundColor = isMark ? BgGreenColor : [UIColor clearColor];
    [self.titleLabel cornerHalf];
}


@end


