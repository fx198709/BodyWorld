//
//  CourseDetailSmallview.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/13.
//

#import <UIKit/UIKit.h>
#import "Room.h"
NS_ASSUME_NONNULL_BEGIN

@interface CourseDetailSmallview : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countryImageview;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *kcalLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

- (void)changeDatawithRoom:(Room*)roomModel;

@end

NS_ASSUME_NONNULL_END
