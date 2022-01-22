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
    _noDataLabel.text = ChineseStringOrENFun(@"暂无课程", @"NO Workouts");
    
    // Initialization code
}

@end
