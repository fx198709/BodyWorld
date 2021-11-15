//
//  SelectCountryCell.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/11.
//

#import "SelectCountryCell.h"

@implementation SelectCountryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
