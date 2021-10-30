//
//  TableHeadview.m
//  FFitWorld
//
//  Created by feixiang on 2021/10/30.
//

#import "TableHeadview.h"

@implementation TableHeadview

- (void)awakeFromNib{
    [super awakeFromNib];
    _layerview1.layer.cornerRadius = 30;
    _layerview1.clipsToBounds = YES;
    _layerview2.layer.cornerRadius = 30;
    _layerview2.clipsToBounds = YES;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
