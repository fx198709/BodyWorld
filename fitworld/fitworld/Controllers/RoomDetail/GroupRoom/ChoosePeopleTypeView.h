//
//  ChoosePeopleTypeView.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/8.
//

#import <UIKit/UIKit.h>
#import "GroupMyRoom.h"
NS_ASSUME_NONNULL_BEGIN


@interface ChoosePeopleTypeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *randomBtn;
@property (weak, nonatomic) IBOutlet UIButton *addPeopleBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addTypeViewHeightConstraint;
@property (strong, nonatomic) GroupMyRoom *groupRoom;

//邀请人按钮
- (IBAction)addPeopleTypeBtn:(UIButton *)sender;

- (void)changeDataWithModel:(GroupMyRoom*)groupRoom;

@end

NS_ASSUME_NONNULL_END
