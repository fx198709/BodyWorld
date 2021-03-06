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
    self.contentView.backgroundColor = BgGrayColor;
}

- (void)setCellType:(FriendCellType)cellType {
    _cellType = cellType;
    switch(cellType) {
        case FriendCell_agree: {
            self.addBtn.hidden = NO;
            [self.addBtn setTitle:ChineseStringOrENFun(@"同意", @"Agree") forState:UIControlStateNormal];
            [self.addBtn setTitleColor:SelectGreenColor forState:UIControlStateNormal];
        }
            break;
        case FriendCell_agreeed: {
            self.addBtn.hidden = NO;
            [self.addBtn setTitle:ChineseStringOrENFun(@"已添加", @"Added") forState:UIControlStateNormal];
            [self.addBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
            break;
        case FriendCell_delete:
        {
            self.addBtn.hidden = NO;
            [self.addBtn setTitle:ChineseStringOrENFun(@"删除", @"Delete") forState:UIControlStateNormal];
            [self.addBtn setTitleColor:SelectGreenColor forState:UIControlStateNormal];
        }
            break;
        case FriendCell_add:
        {
            self.addBtn.hidden = NO;
            [self.addBtn setTitle:ChineseStringOrENFun(@"添加", @"Add") forState:UIControlStateNormal];
            [self.addBtn setTitleColor:SelectGreenColor forState:UIControlStateNormal];
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
        case FriendCell_agree:
        case FriendCell_delete:
        case FriendCell_add:
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
