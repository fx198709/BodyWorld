//
//  RightTopSearchView.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/14.
//

#import "RightTopSearchView.h"

@implementation RightTopSearchView
- (void)awakeFromNib{
    [super awakeFromNib];
    _redView.clipsToBounds = YES;
    _redView.layer.cornerRadius = 3;
    _redView.backgroundColor = UIColor.redColor;
    _searchLabel.text = ChineseStringOrENFun(@"搜索", @"Search");
    [_bottomBtn setTitle:@"" forState:UIControlStateHighlighted];
    [_bottomBtn setTitle:@"" forState:UIControlStateNormal];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
