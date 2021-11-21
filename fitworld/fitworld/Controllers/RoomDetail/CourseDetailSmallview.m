//
//  CourseDetailSmallview.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/13.
//

#import "CourseDetailSmallview.h"

@implementation CourseDetailSmallview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)changeDatawithRoom:(Room*)roomModel{
    _timelabel.text = [NSString stringWithFormat:@"%ld", (long)roomModel.duration];;
    _nameLabel.text = roomModel.creator_nickname;
    NSString *url = roomModel.creator_country_icon;
    [_countryImageview sd_setImageWithURL:[NSURL URLWithString:url]];
    _kcalLabel.text = [NSString stringWithFormat:@"%@", roomModel.cal];
    _kcalLabel.font = [UIFont boldSystemFontOfSize:20];
    _timelabel.font = [UIFont boldSystemFontOfSize:20];
    _titleLabel.text = roomModel.name;
    _descLabel.text = [NSString stringWithFormat:@"duration %ld Minutes", (long)roomModel.duration];
    NSString *title = ChineseStringOrENFun(@"详情", @"Detail");
    UIImage *image = [UIImage imageNamed:@"action_button_bg_gray1"];
    [_detailBtn setBackgroundImage:image forState:UIControlStateNormal];
    [_detailBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    [_detailBtn setTitle:title forState:UIControlStateNormal];
    [_detailBtn setTitle:title forState:UIControlStateHighlighted];
    
    [_detailBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_detailBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    
}

@end
