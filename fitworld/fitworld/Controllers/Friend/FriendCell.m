//
//  FriendCell.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import "FriendCell.h"

@interface FriendCell ()


@end

@implementation FriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView cornerHalfWithBorderColor:[UIColor whiteColor]];
    self.addBtn.hidden = !self.isAdd;
}


@end
