//
//  AddPeopleTableViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2021/10/31.
//

#import <UIKit/UIKit.h>
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddPeopleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imagebackview;
@property (weak, nonatomic) IBOutlet UIImageView *userimageview;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *citylabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (nonatomic, copy) AnyBtnBlock cellBtnClick;
@property (strong, nonatomic) UserInfo *user;

- (void)changeViewWithModel:(UserInfo*)userinfo;

@end

NS_ASSUME_NONNULL_END
