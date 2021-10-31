//
//  HeadTimeCollectionViewCell.m
//  FFitWorld
//
//  Created by feixiang on 2021/10/31.
//

#import "HeadTimeCollectionViewCell.h"

@implementation HeadTimeCollectionViewCell

- (void)addSubviews{
    RemoveSubviews(self.contentView, @[]);
    _selectedView = [[UIView alloc] init];
    [self.contentView addSubview:_selectedView];
    [_selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(3);
         
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(40);
        make.bottom.equalTo(self.contentView).offset(-3);
    }];
    _selectedView.backgroundColor = UIRGBColor(79, 79, 79, 1);
    _selectedView.layer.cornerRadius = 20;
    _selectedView.clipsToBounds = YES;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.font = [UIFont systemFontOfSize:14];
    label1.textColor = UIColor.whiteColor;
    label1.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(14);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(15);
    }];
    self.dayLabel = label1;
    UILabel *label2 = [[UILabel alloc] init];
    label2.textColor = UIColor.whiteColor;
//    赋值的位置换一下

    label2.font = [UIFont systemFontOfSize:12];
    label2.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(3);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(15);
    }];
    self.weekLabel = label2;

    
    
}

- (void)changeSelected{
    _selectedView.hidden = NO;
    self.dayLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    self.weekLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];

}
- (void)changeunSelected{
    _selectedView.hidden = YES;
    self.dayLabel.font = [UIFont systemFontOfSize:14];
    self.weekLabel.font = [UIFont systemFontOfSize:12];
}

@end
