//
//  ChoosePeopleTypeView.m
//  FFitWorld
//
//  Created by feixiang on 2021/12/8.
//

#import "ChoosePeopleTypeView.h"
#import "GroupRoomPrepareViewController.h"
@implementation ChoosePeopleTypeView
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = BgGrayColor;
    for (int index = 300; index < 303; index++) {
        UIButton *vbutton = [self viewWithTag:index];
        vbutton.layer.cornerRadius = 15;
        vbutton.clipsToBounds = YES;
        vbutton.backgroundColor = LittleBgGrayColor;
        if (index == 300) {
            vbutton.backgroundColor = BgGreenColor;
        }
    }
    _randomLabel.text = ChineseStringOrENFun(@"随机匹配", @"Random");
    _invientPeopleLabel.text = ChineseStringOrENFun(@"邀请好友", @"Friend");
    _myselfLabel.text = ChineseStringOrENFun(@"自己", @"Myself");
    
    NSString *addAPPFriendString = ChineseStringOrENFun(@"App内好友", @"App Friend");
    [_addAPPFriendBtn setTitle:addAPPFriendString forState:UIControlStateNormal];
    [_addAPPFriendBtn setTitle:addAPPFriendString forState:UIControlStateHighlighted];
    
    NSString *addwxFriendString = ChineseStringOrENFun(@"微信邀请", @"From wx");
    [_addwxfriendBtn setTitle:addwxFriendString forState:UIControlStateNormal];
    [_addwxfriendBtn setTitle:addwxFriendString forState:UIControlStateHighlighted];
    
    NSString *addSMSFriendString = ChineseStringOrENFun(@"短信邀请", @"From SMS");
    [_addsmsFriendBtn setTitle:addSMSFriendString forState:UIControlStateNormal];
    [_addsmsFriendBtn setTitle:addSMSFriendString forState:UIControlStateHighlighted];

    [_randomBtn addTarget:self action:@selector(typeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_addPeopleBtn addTarget:self action:@selector(typeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_myselfBtn addTarget:self action:@selector(typeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)changeviewState{
    _addTypeViewHeightConstraint.constant = 0;
    _selectTypeView.hidden = YES;
    UIImage *normalImage = [UIImage imageNamed:@"unselected-circle"];
    UIImage *heighImage = [UIImage imageNamed:@"invite_friends_user_list_item_selected"];
    [_randomBtn setImage:normalImage forState:UIControlStateNormal];
    [_addPeopleBtn setImage:normalImage forState:UIControlStateNormal];
    [_myselfBtn setImage:normalImage forState:UIControlStateNormal];

    if (chooseRoomState == 1) {
        _addTypeViewHeightConstraint.constant = 40;
        [_addPeopleBtn setImage:heighImage forState:UIControlStateNormal];
        [_randomBtn setImage:normalImage forState:UIControlStateNormal];
        _selectTypeView.hidden = NO;
    }
    if (chooseRoomState == 0) {
        [_randomBtn setImage:heighImage forState:UIControlStateNormal];
    }
    if (chooseRoomState == 2) {
        [_myselfBtn setImage:heighImage forState:UIControlStateNormal];
    }
    [_randomBtn setImage:heighImage forState:UIControlStateHighlighted];
    [_addPeopleBtn setImage:heighImage forState:UIControlStateHighlighted];
    [_myselfBtn setImage:heighImage forState:UIControlStateHighlighted];
    [_parentVC.view setNeedsLayout];
}

- (void)typeBtnClicked:(UIButton*)vbutton{
    int laststate = chooseRoomState;
    if (vbutton == _randomBtn) {
        chooseRoomState = 0;
    }else if (vbutton == _myselfBtn) {
        chooseRoomState = 2;
    }else{
        chooseRoomState = 1;
    }
    if (laststate != chooseRoomState) {
        [self changeviewState];
        if ([_parentVC respondsToSelector:@selector(createSubRoomOrDelete:)]) {
            GroupRoomPrepareViewController * vc = _parentVC;
            [vc createSubRoomOrDelete:chooseRoomState];
        }
        NSLog(@"不一样");
    }
    
}

- (IBAction)addPeopleTypeBtn:(UIButton *)sender {
    if (_shareTypeBtnClick) {
        _shareTypeBtnClick([NSNumber numberWithInteger:sender.tag-300]);
    }
    
}
- (void)changeDataWithModel:(GroupMyRoom*)groupRoom enterType:(int)enterType;
{
    self.groupRoom = groupRoom;
    chooseRoomState = enterType;
    [self changeviewState];
}


@end
