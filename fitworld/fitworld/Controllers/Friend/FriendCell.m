//
//  FriendCell.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import "FriendCell.h"
#import "Friend.h"

@interface FriendCell ()


@end

@implementation FriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgView cornerHalfWithBorderColor:[UIColor clearColor]];
    [self.addBtn cornerHalfWithBorderColor:self.addBtn.backgroundColor];
    self.addBtn.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setIsAdd:(BOOL)isAdd {
    _isAdd = isAdd;
    self.addBtn.hidden = !isAdd;
}

- (void)setAddStatus:(int)addStatus {
    _addStatus = addStatus;
    UIColor *titleColor = [UIColor lightGrayColor];
    NSString *title = ChineseStringOrENFun(@"已添加", @"Added");
    if (addStatus == FriendStatus_wait) {
        title = ChineseStringOrENFun(@"同意", @"Agree");
        titleColor = [UIColor greenColor];
    }
    [self.addBtn setTitle:title forState:UIControlStateNormal];
    [self.addBtn setTitleColor:titleColor forState:UIControlStateNormal];
}


-(IBAction)agreeAdd:(id)sender {
    if (self.callBack) {
        self.callBack();
    }
}

@end
