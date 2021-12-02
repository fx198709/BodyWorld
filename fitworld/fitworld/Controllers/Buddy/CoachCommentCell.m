//
//  CoachCommentCell.m
//  FFitWorld
//
//  Created by xiejc on 2021/12/2.
//

#import "CoachCommentCell.h"

@interface CoachCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@end


@implementation CoachCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)loadData:(CoachComment *)comment {
    NSString *avtarImg = [FITAPI_HTTPS_ROOT stringByAppendingString:comment.avatar];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:avtarImg]
                    placeholderImage:[UIImage imageNamed:@"choose_course_foot_logo3_unselected"]];
    if (!_userImageview) {
        _userImageview = [[UserHeadPicView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
        [_userView addSubview:_userImageview];
    }
    [_userImageview changeCommentModelData:comment];
    [_userImageview.userBtn addTarget:self action:@selector(userBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _userView.backgroundColor = UIColor.clearColor;
    
    self.nameLabel.text = comment.nickname;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:comment.created_at];
    self.timeLabel.text = [date mt_formatString:DateFormatter_Day];
    self.commentLabel.text = comment.content;
    [self.clickBtn setTitle:IntToString(comment.favorite_cnt) forState:UIControlStateNormal];

    UIImage *hImg = [UIImage imageNamed:@"icon-zan-h"];
    UIImage *nImg = [UIImage imageNamed:@"icon-zan"];
    UIImage *img = comment.is_favorite ? hImg : nImg;
    [self.clickBtn setImage:img forState:UIControlStateNormal];
}

- (IBAction)clickAction:(id)sender {
    if (self.btnCallBack) {
        self.btnCallBack();
    }
}

- (void)userBtnClicked{
    UIViewController *vc = [CommonTools findControlWithView:self];
//    [vc.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>]
}


@end
