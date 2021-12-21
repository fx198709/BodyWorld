//
//  TrainCommitTableViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/16.
//

#import "BaseTableViewCell.h"
#import "PBTextWithPlaceHoldViewDelegate.h"
#import "PBTextWithPlaceHoldView.h"
NS_ASSUME_NONNULL_BEGIN

@interface TrainCommitTableViewCell : BaseTableViewCell
{
    PBTextWithPlaceHoldViewDelegate *viewTextDelegate;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textviewBackHeight;

@property (weak, nonatomic) IBOutlet PBTextWithPlaceHoldView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineview;
@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UIButton *starBtn3;
- (IBAction)starBtnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *commitBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitedBtn;
- (IBAction)commitBtnClicked:(UIButton *)sender;

@property (nonatomic, assign)NSInteger grade;
@property (nonatomic, strong)NSString *coach_id;

@property (nonatomic, copy) AnyBtnBlock heightChange;


@end

NS_ASSUME_NONNULL_END
