//
//  CoachCommentCell.h
//  FFitWorld
//
//  Created by xiejc on 2021/12/2.
//

#import <UIKit/UIKit.h>
#import "CoachComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoachCommentCell : UITableViewCell


@property (nonatomic, copy) BaseCallBack btnCallBack;

- (void)loadData:(CoachComment *)comment;

@end

NS_ASSUME_NONNULL_END
