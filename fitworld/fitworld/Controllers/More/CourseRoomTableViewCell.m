//
//  CourseRoomTableViewCell.m
//  FFitWorld
//
//  Created by feixiang on 2022/1/6.
//

#import "CourseRoomTableViewCell.h"

@implementation CourseRoomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _nameLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textColor = [UIColor whiteColor];
    _typeleftLabel.font = [UIFont systemFontOfSize:13];
    _typeleftLabel.textColor = LightGaryTextColor;
    _peopleLabel.font = [UIFont systemFontOfSize:13];
    _peopleLabel.textColor = LightGaryTextColor;
    _storeLabel.font = [UIFont systemFontOfSize:13];
    _storeLabel.textColor = LightGaryTextColor;
    _leftLanguageLabel.font = [UIFont systemFontOfSize:13];
    _leftLanguageLabel.textColor = LightGaryTextColor;
    _languageLabel.font = [UIFont systemFontOfSize:13];
    _languageLabel.textColor = LightGaryTextColor;
    _leftTimeLabel.font = SystemFontOfSize(14);
    _leftTimeLabel.textAlignment = NSTextAlignmentRight;
    _leftTimeLabel.textColor = LightGaryTextColor;
    
    _timeLabel.textColor = UIColor.whiteColor;
    self.contentView.backgroundColor = BgGrayColor;
    
    _lineview = [[UIView alloc] init];
    _lineview.backgroundColor = LineColor;
    [self.contentView addSubview:_lineview];
    [_lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeDataWithRoom:(Room*)room{
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, room.course.pic]]];
    self.leftImageView.clipsToBounds = YES;
    self.leftImageView.layer.cornerRadius = 8;
    _nameLabel.text = room.course.name;
    int type_int = [room reachRoomRealTypeInt];
    _typeimageview.image=[UIImage imageNamed:[NSString stringWithFormat:@"more_type_icon%d",type_int]];
    NSString *perString = ChineseStringOrENFun(@"房主:", @"Rooms:");
    if (type_int == 1 || type_int == 2) {
        perString = ChineseStringOrENFun(@"教练:", @"Coach:");
    }
    _typeleftLabel.text = perString;
    _peopleLabel.text = room.room_creator.nickname;
    NSString *countryUrl = room.room_creator.country_icon;
    [_countryImageView sd_setImageWithURL:[NSURL URLWithString:countryUrl]];
    
    _timeLabel.text = [CommonTools ReachTimeWithFormate:room.start_time andFormate:@"HH:mm"];
//    gym_name
    _storeLabel.text = @"";
    if (room.course.gym_name && room.course.gym_name.length >0) {
        _storeLabel.text = [NSString stringWithFormat:@"，%@",room.course.gym_name];

    }
    _leftTimeLabel.text = @"";
    if ([room isBegin]) {
//        处在直播状态
        long currentTime = [[NSDate date] timeIntervalSince1970];
        long diff = currentTime- room.start_time;
        if (diff > 0) {
            NSString *leftString = [CommonTools reachLeftString:diff];
            leftString = [NSString stringWithFormat:@"%@%@",ChineseStringOrENFun(@"", @""),leftString];
            _leftTimeLabel.text = leftString;
            
        }
    }else{
        //        还没开始 判断开始时间和现在时间的差
        long currentTime = [[NSDate date] timeIntervalSince1970];
        long diff = room.start_time - currentTime;
        if (diff < 3600*3 && diff >0) {
            NSString *leftString = [CommonTools reachLeftString:diff];
            leftString = [NSString stringWithFormat:@"-%@",leftString];
            _leftTimeLabel.text = leftString;
        }
    }
    
    [CommonTools changeBtnState:_joinBtn btnData:room];
    _leftLanguageLabel.text = ChineseStringOrENFun(@"交流语言:", @"Speek lan:");
    _languageLabel.text = [room getCourse_language_string];
}


@end
