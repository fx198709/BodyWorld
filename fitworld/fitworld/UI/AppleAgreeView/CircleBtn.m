//
//  CircleBtn.m
//  FFitWorld
//
//  Created by feixiang on 2022/2/22.
//

#import "CircleBtn.h"

@implementation CircleBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)changemodel:(ScreenModel*)model{
    _screenModel = model;
    [self changeviewState];

}

- (void)changeviewState{
    UIImage *image = [UIImage imageNamed:@"white-unselect"];
    if (_screenModel.hasSelected) {
        image = [UIImage imageNamed:@"invite_friends_user_list_item_selected"];
    }
    if (!_showImageView) {
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:_showImageView];
    }
    _showImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _showImageView.image =image;
    _showImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [self addSubview:_backBtn];
    }
    [_backBtn addTarget:self action:@selector(backBtnClickednow) forControlEvents:UIControlEventTouchUpInside];
}

- (void )backBtnClickednow{
    if (self.backBtnClicked) {
//        _screenModel.hasSelected = YES;
//        [self changeviewState];
        self.backBtnClicked(_screenModel);
    }else{
        [self changebtnType];
    }
}

- (void)changebtnType{
    _screenModel.hasSelected = !_screenModel.hasSelected;
    [self changeviewState];
    
//    [self setImage:image forState:UIControlStateNormal];
//    [self setImage:image forState:UIControlStateHighlighted];

}



@end
