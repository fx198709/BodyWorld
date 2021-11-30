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
//    72  225
    _canenterLabel.text = ChineseStringOrENFun(@"只显示能加入的房间", @"Only show can inten room");
    _contentLabel.text = ChineseStringOrENFun(@"内容", @"By Content");
    _contentLabel.textColor = UIColor.blackColor;
    _durationLabel.text = ChineseStringOrENFun(@"时长", @"By Duration");
    _durationLabel.textColor = UIColor.blackColor;

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
    
    int outwidth = ScreenWidth - 40*2;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(40, 72, outwidth, 80)];
    [self addSubview:_contentView];
    
    _durationView = [[UIView alloc] initWithFrame:CGRectMake(40, 225, outwidth, 80)];
    [self addSubview:_durationView];
    
}
- (void)resetBtnClicked{
//    重设
    for (ScreenAboveNameBtn * btn in _durationView.subviews) {
        btn.nameModel.hasSelected = NO;
        [btn changeDateWithScreenModel:btn.nameModel];
    }
    for (ScreenAboveNameBtn * btn in _contentView.subviews) {
        btn.nameModel.hasSelected = NO;
        [btn changeDateWithScreenModel:btn.nameModel];
    }
}

- (void)okBtnClicked{
    if (self.screenOKClick) {
        self.screenOKClick(_timeArray, _typeArray);
    }
}

- (void)changeData:(NSArray*)timeArray andType:(NSArray*)typeArray{
    NSMutableArray *tempIds = [NSMutableArray array];
    _timeArray = [NSArray arrayWithArray:timeArray];
    _typeArray = [NSArray arrayWithArray:typeArray];
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
//    保存弹出时的选中数据
    _lastSelectedIds = tempIds;
    RemoveSubviews(_contentView, @[]);
    RemoveSubviews(_durationView, @[]);
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
