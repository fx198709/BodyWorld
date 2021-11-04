//
//  MessageListTableViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/5.
//

#import <UIKit/UIKit.h>
#import "MessageListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MessageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;

- (void)changeDataWithModel:(MessageListModel*)messageModel;

@end

NS_ASSUME_NONNULL_END
