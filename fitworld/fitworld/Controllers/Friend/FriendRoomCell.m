//
//  FriendRoomCell.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/29.
//

#import "FriendRoomCell.h"

@interface FriendRoomCell ()

@property (weak, nonatomic) IBOutlet UIImageView *courseImg;
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *creatorImg;
@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@end

@implementation FriendRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)loadRoom:(Room *)room {
    NSString *courseImgUrl = [FITAPI_HTTPS_ROOT stringByAppendingString:room.course.pic];
    [self.courseImg sd_setImageWithURL:[NSURL URLWithString:courseImgUrl]
                    placeholderImage:[UIImage imageNamed:@"choose_course_foot_logo3_unselected"]];
    self.nameLabel.text = room.course.name;
    
    UIImage *typeImg = [UIImage imageNamed:[NSString stringWithFormat:@"type-calss%ld",(long)room.course.type_int]];
    self.typeImg.image = typeImg;
    NSString *creatorImgUrl = [FITAPI_HTTPS_ROOT stringByAppendingString:room.room_creator.country_icon];
    [self.creatorImg sd_setImageWithURL:[NSURL URLWithString:creatorImgUrl]
                    placeholderImage:nil];
    self.creatorNameLabel.text = room.room_creator.nickname;
    
    if (room.is_join) {
        [self.clickBtn setTitle:ChineseStringOrENFun(@"已预约", @"Has join") forState:UIControlStateNormal];
        self.clickBtn.backgroundColor = [UIColor blueColor];
        [self.clickBtn cornerHalf];
        self.clickBtn.userInteractionEnabled = NO;
    } else {
        [self.clickBtn setTitle:ChineseStringOrENFun(@"预约", @"Join") forState:UIControlStateNormal];
        [self.clickBtn cornerLeftHalf];
        self.clickBtn.backgroundColor = [UIColor lightGrayColor];
        self.clickBtn.userInteractionEnabled = YES;
    }
}


- (IBAction)clickAction:(id)sender {
    if (self.btnCallBack) {
        self.btnCallBack();
    }
}


@end
