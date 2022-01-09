//
//  ShareAboveView.m
//  FFitWorld
//
//  Created by feixiang on 2021/12/19.
//

#import "ShareAboveView.h"

@implementation ShareAboveView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)createSubview{
    RemoveSubviews(_shareview, @[]);
    for (int i = 0; i < 3 ; i++) {
        int parentSize = ScreenWidth/3;
        CGRect btnframe = CGRectMake((parentSize-52)/2+i*parentSize, 17, 52, 67);
        UIButton *vbutton = [[UIButton alloc] initWithFrame:btnframe];
        NSString *imagename = @"icon_share_wx";
        if (i == 1) {
            imagename = @"icon_share_wxq";
        }else if (i == 2) {
            imagename = @"icon_share_sms";
        }
        [_shareview addSubview:vbutton];
        [vbutton setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
        [vbutton setImage:[UIImage imageNamed:imagename] forState:UIControlStateHighlighted];
        vbutton.tag = 200+i;
        [vbutton addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    _cancelBtn.titleLabel.textColor = [UIColor darkGrayColor];
    [_cancelBtn setTitle:CancelString forState:UIControlStateNormal];
    [_cancelBtn setTitle:CancelString forState:UIControlStateHighlighted];
    [_cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];

}

- (void)shareBtnClicked:(UIButton*)btn{
    if (_shareBtnClick) {
        _shareBtnClick([NSNumber numberWithInteger:btn.tag -200]);
    }
}

@end
