//
//  NoDataCollectionViewCell.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/6.
//

#import "NoDataCollectionViewCell.h"

@implementation NoDataCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _noDataLabel.text = ChineseStringOrENFun(@"暂无数据", @"NO WorkOut");
    // Initialization code
}

@end
