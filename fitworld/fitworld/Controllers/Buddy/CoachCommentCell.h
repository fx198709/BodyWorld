//
//  CoachCommentCell.h
//  FFitWorld
//
//  Created by xiejc on 2021/12/2.
//

#import <UIKit/UIKit.h>
#import "CoachComment.h"
#import "UserHeadPicView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoachCommentCell : UITableViewCell


@property (nonatomic, copy) BaseCallBack btnCallBack;
@property (nonatomic, retain) UserHeadPicView *userImageview;
@property (nonatomic, retain) CoachComment *currentComment;


@property (weak, nonatomic) IBOutlet UIView *userView;
- (void)loadData:(CoachComment *)comment;

@end

NS_ASSUME_NONNULL_END
