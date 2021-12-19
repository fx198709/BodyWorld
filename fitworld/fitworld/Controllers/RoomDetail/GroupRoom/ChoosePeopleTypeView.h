//
//  ChoosePeopleTypeView.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/8.
//

#import <UIKit/UIKit.h>
#import "GroupMyRoom.h"
NS_ASSUME_NONNULL_BEGIN


@interface ChoosePeopleTypeView : UIView{
    int chooseRoomState;//随机 还是邀请好友
}
@property (weak, nonatomic) IBOutlet UIButton *randomBtn;
@property (weak, nonatomic) IBOutlet UIButton *addPeopleBtn;
@property (weak, nonatomic) IBOutlet UIView *selectTypeView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addTypeViewHeightConstraint;
@property (strong, nonatomic) GroupMyRoom *groupRoom;
@property (nonatomic, assign) UIViewController * parentVC;
@property (nonatomic, copy) AnyBtnBlock shareTypeBtnClick;

//邀请人按钮
- (IBAction)addPeopleTypeBtn:(UIButton *)sender;

- (void)changeDataWithModel:(GroupMyRoom*)groupRoom;

@end

NS_ASSUME_NONNULL_END
