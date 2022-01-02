//
//  ScreenAboveView.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/14.
//

#import "ScreenAboveView.h"
#import "ScreenModel.h"
@interface ScreenAboveNameBtn : UIButton{
     
}
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)ScreenModel *nameModel;

- (void)changeDateWithScreenModel:(ScreenModel*)model;
@end
@implementation ScreenAboveNameBtn

- (void)createSubview{
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.frame.size.width-20, 20)];
    _nameLabel.textColor = UIColor.blackColor;
    _nameLabel.font = SystemFontOfSize(15);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLabel];
    self.layer.cornerRadius = 15;
    self.clipsToBounds = YES;
}
- (void)changeDateWithScreenModel:(ScreenModel*)model{
    self.nameModel = model;
    _nameLabel.text = model.name;
    _nameLabel.textColor = UIColor.blackColor;
    self.backgroundColor = UIRGBColor(247, 247, 247, 1);
    if (model.hasSelected) {
        _nameLabel.textColor = UIColor.whiteColor;
        self.backgroundColor = UIRGBColor(97, 186, 129, 1);
    }
}
@end


@implementation ScreenAboveView

- (void)awakeFromNib{
    [super awakeFromNib];
//    把screenScrollview里面的默认view 都加上
    _screenScrollview = [[UIScrollView alloc] init];
    [self addSubview:_screenScrollview];
    [_screenScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(70);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self).offset(30);
        make.height.mas_equalTo(293);
    }];
    int outwidth = ScreenWidth - 40*2;
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.textColor = UIColor.blackColor;
    [_screenScrollview addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_screenScrollview).offset(0);
        make.left.equalTo(_screenScrollview).offset(0);
        make.right.equalTo(_screenScrollview).offset(0);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(outwidth);
    }];
    UIView * lineview2 = [[UIView alloc] init];
    [_screenScrollview addSubview:lineview2];
    lineview2.backgroundColor = LineColor;
    [lineview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentLabel.mas_bottom).offset(9);
        make.left.equalTo(_contentLabel).offset(0);
        make.right.equalTo(_contentLabel).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    _contentView = [[UIView alloc] init];
    [_screenScrollview addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview2.mas_bottom).offset(9);
        make.left.equalTo(lineview2).offset(0);
        make.right.equalTo(lineview2).offset(0);
        make.height.mas_equalTo(30);
    }];
    
    _languageLabel = [[UILabel alloc] init];
    _languageLabel.textColor = UIColor.blackColor;
    [_screenScrollview addSubview:_languageLabel];
    [_languageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView.mas_bottom).offset(15);
        make.left.equalTo(_contentView).offset(0);
        make.right.equalTo(_contentView).offset(0);
        make.height.mas_equalTo(21);
    }];
    UIView *lineview1 = [[UIView alloc] init];
    [_screenScrollview addSubview:lineview1];
    lineview1.backgroundColor = LineColor;
    [lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_languageLabel.mas_bottom).offset(9);
        make.left.equalTo(_languageLabel).offset(0);
        make.right.equalTo(_languageLabel).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    _languageView = [[UIView alloc] init];
    [_screenScrollview addSubview:_languageView];
    [_languageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview1.mas_bottom).offset(9);
        make.left.equalTo(lineview1).offset(0);
        make.right.equalTo(lineview1).offset(0);
        make.height.mas_equalTo(10);
    }];
    
    
    
    _durationLabel  = [[UILabel alloc] init];
    _durationLabel.textColor = UIColor.blackColor;
    [_screenScrollview addSubview:_durationLabel];
    [_durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_languageView.mas_bottom).offset(15);
        make.left.equalTo(_languageView).offset(0);
        make.right.equalTo(_languageView).offset(0);
        make.height.mas_equalTo(21);
    }];
    UIView *lineview = [[UIView alloc] init];
    [_screenScrollview addSubview:lineview];
    lineview.backgroundColor = LineColor;
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_durationLabel.mas_bottom).offset(9);
        make.left.equalTo(_durationLabel).offset(0);
        make.right.equalTo(_durationLabel).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    _durationView = [[UIView alloc] init];
    [_screenScrollview addSubview:_durationView];
    [_durationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview.mas_bottom).offset(9);
        make.left.equalTo(lineview).offset(0);
        make.right.equalTo(lineview).offset(0);
        make.height.mas_equalTo(10);
        make.bottom.equalTo(_screenScrollview).offset(2);
    }];
//    72  225
    _canenterLabel.text = ChineseStringOrENFun(@"只显示能加入的房间", @"Only show can inten room");
    _canenterLabel.textColor = UIColor.blackColor;
    _contentLabel.text = ChineseStringOrENFun(@"内容", @"By Content");
    _contentLabel.textColor = UIColor.blackColor;
    _durationLabel.text = ChineseStringOrENFun(@"时长", @"By Duration");
    _durationLabel.textColor = UIColor.blackColor;
    _languageLabel.text = ChineseStringOrENFun(@"语言", @"By Language");

    
    self.showJoin = NO;
    [self changeShowJoinBtnWithState];
    [_canEnterBtn addTarget:self action:@selector(changeEnterBtn) forControlEvents:UIControlEventTouchUpInside];
    NSString *resetString = ChineseStringOrENFun(@"重置", @"Reset");
    [_cancelBtn setTitle:resetString forState:UIControlStateNormal];
    [_cancelBtn setTitle:resetString forState:UIControlStateHighlighted];
    [_cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    _cancelBtn.backgroundColor = UIColor.grayColor;
    _cancelBtn.layer.cornerRadius = 7;
    _cancelBtn.clipsToBounds = YES;
    [_cancelBtn addTarget:self action:@selector(resetBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    NSString *okString = ChineseStringOrENFun(@"确认", @"OK");
    [_okBtn setTitle:okString forState:UIControlStateNormal];
    [_okBtn setTitle:okString forState:UIControlStateHighlighted];
    [_okBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [_okBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    _okBtn.backgroundColor = UIRGBColor(71 , 137, 95, 1);
    _okBtn.layer.cornerRadius = 7;
    _okBtn.clipsToBounds = YES;
    [_okBtn addTarget:self action:@selector(okBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _contentView.backgroundColor = UIColor.clearColor;
    _durationView.backgroundColor = UIColor.clearColor;
    _languageView.backgroundColor = UIColor.clearColor;
    
}
- (void)resetBtnClicked{
//    重设
    _showJoin = NO;
    [self changeShowJoinBtnWithState];
    for (ScreenAboveNameBtn * btn in _durationView.subviews) {
        btn.nameModel.hasSelected = NO;
        [btn changeDateWithScreenModel:btn.nameModel];
    }
    for (ScreenAboveNameBtn * btn in _contentView.subviews) {
        btn.nameModel.hasSelected = NO;
        [btn changeDateWithScreenModel:btn.nameModel];
    }
    
    for (ScreenAboveNameBtn * btn in _languageView.subviews) {
        btn.nameModel.hasSelected = NO;
        [btn changeDateWithScreenModel:btn.nameModel];
    }
}

//改变按钮状态
- (void)changeShowJoinBtnWithState{
    UIImage *image = [UIImage imageNamed:@"unselected-circle"];
    UIImage *himage = [UIImage imageNamed:@"invite_friends_user_list_item_selected"];
    if (_showJoin) {
        image = himage;
    }
    [_canEnterBtn setImage:image forState:UIControlStateNormal];
    [_canEnterBtn setImage:himage forState:UIControlStateHighlighted];
}

- (void)changeEnterBtn{
    _showJoin = !_showJoin;
    [self changeShowJoinBtnWithState];
}

- (void)okBtnClicked{
    if (self.screenOKClick) {
        self.screenOKClick(_timeArray, _typeArray,_languageArray,_showJoin);
    }
}

- (void)changeData:(NSArray*)timeArray andType:(NSArray*)typeArray andLanguage:(NSArray*)languageArray isjoin:(BOOL)isjoin{
    NSMutableArray *tempIds = [NSMutableArray array];
    _timeArray = [NSArray arrayWithArray:timeArray];
    _typeArray = [NSArray arrayWithArray:typeArray];
    _languageArray = [NSArray arrayWithArray:languageArray];

    for (ScreenModel *model in _timeArray ) {
        if (model.hasSelected) {
            [tempIds addObject:model.id];
        }
    }
    for (ScreenModel *model in _typeArray ) {
        if (model.hasSelected) {
            [tempIds addObject:model.id];
        }
    }
    for (ScreenModel *model in _languageArray ) {
        if (model.hasSelected) {
            [tempIds addObject:model.id];
        }
    }
//    保存弹出时的选中数据
    _lastSelectedIds = tempIds;
    RemoveSubviews(_contentView, @[]);
    RemoveSubviews(_durationView, @[]);
    RemoveSubviews(_languageView, @[]);

    int outwidth = ScreenWidth - 40*2;
    int itemwidth = (outwidth-20)/3;
    int startHeight = 10;
    int btnHeight = 30;
    

    
    
    for (int index = 0; index < _typeArray.count; index++) {
        ScreenModel *model = [_typeArray objectAtIndex:index];
        int y = index/3 *(btnHeight+startHeight) +startHeight;
        int x = (itemwidth+10)*(index%3);
        CGRect btnRect = CGRectMake(x, y, itemwidth, btnHeight);
        ScreenAboveNameBtn *btnview = [ScreenAboveNameBtn buttonWithType:UIButtonTypeCustom];
        btnview.frame = btnRect;
        [_contentView addSubview:btnview];
        [btnview createSubview];
        [btnview changeDateWithScreenModel:model];
        [btnview addTarget:self action:@selector(btnviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }

    NSUInteger lineCount1 = _typeArray.count%3 == 0?_typeArray.count/3:_typeArray.count/3+1;
    _top1constraint.constant = lineCount1* (startHeight+btnHeight);
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineCount1* (startHeight+btnHeight));
    }];
    
    for (int index = 0; index < _languageArray.count; index++) {
        ScreenModel *model = [_languageArray objectAtIndex:index];
        int y = index/3 *(btnHeight+startHeight) +startHeight;
        int x = (itemwidth+10)*(index%3);
        CGRect btnRect = CGRectMake(x, y, itemwidth, btnHeight);
        ScreenAboveNameBtn *btnview = [ScreenAboveNameBtn buttonWithType:UIButtonTypeCustom];
        btnview.frame = btnRect;
        [_languageView addSubview:btnview];
        [btnview createSubview];
        [btnview changeDateWithScreenModel:model];
        [btnview addTarget:self action:@selector(btnviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSUInteger lineCount0 = _languageArray.count%3 == 0?_languageArray.count/3:_languageArray.count/3+1;
    [_languageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineCount0* (startHeight+btnHeight));
    }];

    for (int index = 0; index < _timeArray.count; index++) {
        ScreenModel *model = [_timeArray objectAtIndex:index];
        int y = index/3 * (btnHeight+startHeight)+startHeight;
        int x = (itemwidth+10)*(index%3);
        CGRect btnRect = CGRectMake(x, y, itemwidth, btnHeight);
        ScreenAboveNameBtn *btnview = [ScreenAboveNameBtn buttonWithType:UIButtonTypeCustom];
        btnview.frame = btnRect;
        [_durationView addSubview:btnview];
        [btnview createSubview];
        [btnview changeDateWithScreenModel:model];
        [btnview addTarget:self action:@selector(btnviewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSUInteger lineCount2 = _timeArray.count%3 == 0?_timeArray.count/3:_timeArray.count/3+1;
    [_durationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(lineCount2* (startHeight+btnHeight));
    }];
    _showJoin = isjoin;
    [self changeShowJoinBtnWithState];
//    ScreenAboveNameBtn
}

- (void)btnviewClicked:(ScreenAboveNameBtn*)btn{
    btn.nameModel.hasSelected = !btn.nameModel.hasSelected;
    [btn changeDateWithScreenModel:btn.nameModel];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
