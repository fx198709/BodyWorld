//
//  TrainCommitTableViewCell.m
//  FFitWorld
//
//  Created by feixiang on 2021/12/16.
//

#import "TrainCommitTableViewCell.h"

@implementation TrainCommitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabel.font = SystemFontOfSize(17);
    _titleLabel.text = ChineseStringOrENFun(@"评分", @"Score");
    _titleLabel.textColor = UIColor.whiteColor;
    // Initialization code
    _lineview.backgroundColor = UIRGBColor(225, 225, 225, 0.5);
    
    _backview.layer.cornerRadius = 8;
    _backview.clipsToBounds = YES;
    _commitBackBtn.layer.cornerRadius = 18;
    _commitBackBtn.clipsToBounds = YES;
    NSString *title = ChineseStringOrENFun(@"提交", @"Commit");
    [_commitedBtn setTitle:title forState:UIControlStateNormal];
    [_commitedBtn setTitle:title forState:UIControlStateHighlighted];
//    _commitTextField.placeholder = ChineseStringOrENFun(@"说点什么", @"Say some");
//    _commitTextField.textColor = UIColor.whiteColor;
    _grade = 0;
    
    WeakSelf
    viewTextDelegate = [[PBTextWithPlaceHoldViewDelegate alloc] init];
    viewTextDelegate.textViewDidChange = ^(PBTextWithPlaceHoldView *textView) {
        [wSelf textDidChange:textView];
    };
    viewTextDelegate.textViewDidEndEditing = ^(PBTextWithPlaceHoldView *textView) {
        [wSelf textDidChange:textView];
    };
    viewTextDelegate.maxnumber = 300;
    
    _contentTextView.delegate = viewTextDelegate;
    _contentTextView.font = SystemFontOfSize(14);
    _contentTextView.backgroundColor = UIRGBColor(53, 53, 53, 1);
    _contentTextView.placeHoldLabel.font = SystemFontOfSize(14);
    [_contentTextView setPlaceHoldString:ChineseStringOrENFun(@"说点什么", @"Say some")] ;

}

//修改输入框的高度
- (void)textDidChange:(PBTextWithPlaceHoldView*)textView{
    int width = ScreenWidth-60-45-60-20;// textview 的宽度
    NSDictionary *dict = @{NSFontAttributeName : textView.font};
    CGSize size =  [textView.text boundingRectWithSize:CGSizeMake(width, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    int currentHeight = size.height+1;
    if (currentHeight < 20) {
        currentHeight = 20;
    }
    int outHeight = currentHeight+16;//外面背景的高度
    if (_textviewBackHeight.constant != outHeight) {
        _textviewBackHeight.constant = outHeight;
        if (_heightChange) {
//            传出去是textview 的变化量
            _heightChange([NSNumber numberWithInteger:_textviewBackHeight.constant-36]);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)starBtnClicked:(UIButton *)sender {
    _grade = sender.tag-100;
    for (NSInteger index = 101; index<= 105;index++) {
        UIButton *vbutton = [self viewWithTag:index];
        UIImage *grayStar = [UIImage imageNamed:@"grayStar"];

        if (index <= sender.tag) {
            grayStar = [UIImage imageNamed:@"yellowstar"];
        }
        [vbutton setImage:grayStar forState:UIControlStateNormal];
        [vbutton setImage:grayStar forState:UIControlStateHighlighted];
    }
}
- (IBAction)commitBtnClicked:(UIButton *)sender {
    UIViewController *parentVC = [CommonTools findControlWithView:self];
    if (_grade < 1) {
        [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"请选择星级", @"请选择星级") control:parentVC];
        return;
    }
    if (_contentTextView.text.length < 1) {
        [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"说点什么", @"Say some") control:parentVC];
        return;
    }
//    发请求
    [MBProgressHUD showHUDAddedTo:parentVC.view animated:YES];
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    NSMutableDictionary *baddyParams = [NSMutableDictionary dictionary];
    [baddyParams setObject:[NSNumber numberWithInteger:_grade] forKey:@"grade"];
    [baddyParams setObject:_coach_id forKey:@"coach_id"];
    [baddyParams setObject:_contentTextView.text forKey:@"content"];
    [manager POST:@"comment/coach/add" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:parentVC.view animated:YES];
        if (CheckResponseObject(responseObject)) {
            [CommonTools showAlertDismissWithContent:@"提交成功" control:parentVC];
            self->_contentTextView.text = @"";
            if ([parentVC respondsToSelector:@selector(reloadtable)]) {
                [parentVC performSelector:@selector(reloadtable)];
            }
//            self.selectRoom.is_join = postBool;
//            [self changejoinBtn];
        }else{
            [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"]  control:parentVC];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:parentVC.view animated:YES];
        [CommonTools showNETErrorcontrol:parentVC];
    }];
}
@end
