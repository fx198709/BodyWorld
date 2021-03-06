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
    [_randomBtn addTarget:self action:@selector(typeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_addPeopleBtn addTarget:self action:@selector(typeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

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
    [_randomBtn setImage:heighImage forState:UIControlStateNormal];
    [_addPeopleBtn setImage:normalImage forState:UIControlStateNormal];
    if (chooseRoomState == 1) {
        _addTypeViewHeightConstraint.constant = 40;
        [_addPeopleBtn setImage:heighImage forState:UIControlStateNormal];
        [_randomBtn setImage:normalImage forState:UIControlStateNormal];
        _selectTypeView.hidden = NO;
    }
    [_randomBtn setImage:heighImage forState:UIControlStateHighlighted];
    [_addPeopleBtn setImage:heighImage forState:UIControlStateHighlighted];

    [_parentVC.view setNeedsLayout];
}

- (void)typeBtnClicked:(UIButton*)vbutton{
    int laststate = chooseRoomState;
    if (vbutton == _randomBtn) {
        chooseRoomState = 0;
    }else{
        chooseRoomState = 1;
    }
    if (laststate != chooseRoomState) {
        [self changeviewState];
        if ([_parentVC respondsToSelector:@selector(createSubRoomOrDelete:)]) {
            GroupRoomPrepareViewController * vc = _parentVC;
            [vc createSubRoomOrDelete:chooseRoomState];
        }
        NSLog(@"?????????");
    }
    
}

- (IBAction)addPeopleTypeBtn:(UIButton *)sender {
    
}
- (void)changeDataWithModel:(GroupMyRoom*)groupRoom{
    self.groupRoom = groupRoom;
    chooseRoomState = 0;

    if (groupRoom == nil) {
    }else{
        if (groupRoom.sub_room_id && groupRoom.sub_room_id.length > 1) {
            chooseRoomState = 1;
        }
    }
    [self changeviewState];
}


@end
