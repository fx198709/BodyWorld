//
//  MessageListTableViewCell.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/5.
//

#import "MessageListTableViewCell.h"

@implementation MessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _messageLabel.preferredMaxLayoutWidth = ScreenWidth - 70 -10;
//    [_messageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeDataWithModel:(MessageListModel*)messageModel{
    self.nameLabel.text = ChineseStringOrENFun(@"课程提醒", @"Course Reminder");
    self.messageLabel.text = messageModel.content;
    self.timelabel.text = messageModel.updated_atString;
}


@end
