//
//  CourseRoomTableViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2022/1/6.
//

#import "BaseTableViewCell.h"
#import "Room.h"
NS_ASSUME_NONNULL_BEGIN

@interface CourseRoomTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeimageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeleftLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLanguageLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIImageView *countryImageView;
@property (strong, nonatomic)  UIView *lineview;
@property (weak, nonatomic) IBOutlet UILabel *storeLabel;



- (void)changeDataWithRoom:(Room*)room;

@end

NS_ASSUME_NONNULL_END
