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

//- (void)setIsAdd:(BOOL)isAdd {
//    _isAdd = isAdd;
//    self.addBtn.hidden = !isAdd;
//}

- (void)setCellType:(FriendCellType)cellType {
    _cellType = cellType;
    switch(cellType) {
        case FriendCell_add: {
            self.addBtn.hidden = NO;
            [self.addBtn setTitle:ChineseStringOrENFun(@"同意", @"Agree") forState:UIControlStateNormal];
            [self.addBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
            break;
        case FriendCell_added: {
            self.addBtn.hidden = NO;
            [self.addBtn setTitle:ChineseStringOrENFun(@"已添加", @"Added") forState:UIControlStateNormal];
            [self.addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            break;
        case FriendCell_delete:
        {
            self.addBtn.hidden = NO;
            [self.addBtn setTitle:ChineseStringOrENFun(@"删除", @"Delete") forState:UIControlStateNormal];
            [self.addBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
            break;
        default:
        {
            self.addBtn.hidden = YES;
        }
    }
}


-(IBAction)friendActionClick:(id)sender {
    switch(self.cellType) {
        case FriendCell_add:
        case FriendCell_delete:
        {
            if (self.btnCallBack) {
                self.btnCallBack();
            }
        }
            break;
        default:
        {
            self.addBtn.hidden = YES;
        }
    }
}




@end
