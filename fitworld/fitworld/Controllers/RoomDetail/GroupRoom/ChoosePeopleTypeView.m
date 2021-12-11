//
//  ChoosePeopleTypeView.m
//  FFitWorld
//
//  Created by feixiang on 2021/12/8.
//

#import "ChoosePeopleTypeView.h"

@implementation ChoosePeopleTypeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addPeopleTypeBtn:(UIButton *)sender {
    
}
- (void)changeDataWithModel:(GroupMyRoom*)groupRoom{
    self.groupRoom = groupRoom;
    _addTypeViewHeightConstraint.constant = 0;

    if (groupRoom == nil) {
    }else{
        if (groupRoom.sub_room_id) {
            _addTypeViewHeightConstraint.constant = 40;
        }
    }
}


@end
