//
//  MessageDetailViewController.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/6.
//

#import "BaseNavViewController.h"
//消息详情页面
NS_ASSUME_NONNULL_BEGIN

@interface MessageDetailViewController : BaseNavViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) NSString * messageID;

@end

NS_ASSUME_NONNULL_END
