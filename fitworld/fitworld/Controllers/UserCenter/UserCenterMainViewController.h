//
//  UserCenterMainViewController.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/6.
//

#import "BaseNavViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCenterMainViewController : BaseNavViewController
@property (weak, nonatomic) IBOutlet UIView *headimageview;
@property (weak, nonatomic) IBOutlet UIView *headimagebackview;
@property (weak, nonatomic) IBOutlet UIImageView *userimageview;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *locationlabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcalLabel;//卡路里
@property (weak, nonatomic) IBOutlet UILabel *kcalDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankDescLabel;

@end

NS_ASSUME_NONNULL_END
