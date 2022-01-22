//
//  LivingGoodsCell.m
//  TableNested
//
//  Created by HanOBa on 2019/4/25.
//  Copyright © 2019 HanOBa. All rights reserved.
//

#import "LivingGoodsCell.h"

@implementation LivingGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.layer.masksToBounds = YES;
    self.imagebackview.layer.cornerRadius = 10;
    self.imagebackview.clipsToBounds = YES;

    self.clipsToBounds = YES;
    self.goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    _bottomview.clipsToBounds = YES;
    _joinBtn.titleLabel.font = SystemFontOfSize(14);
//
//    UIImage *img=[UIImage imageNamed:@"type-calssBack"];
//    img=[img stretchableImageWithLeftCapWidth:30 topCapHeight:0];
//    _typebackImageview.image = img;
}

- (void)changedatawithmodel:(Room*)room{
    self.startTime.text = ReachWeekTime(room.start_time);
    NSString *picUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, room.course.pic];
    [self.goodsImage sd_setImageWithURL: [NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    self.goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    self.roomname.text = room.name;
    NSString *perString = ChineseStringOrENFun(@"房主", @"Rooms");
    NSString *classType= ChineseStringOrENFun(@"对练课", @"Buddy");
    _classTypeLabel.textColor = BgGrayColor;

    if (room.course.type_int == 1 ) {
        perString = TrainerString;
        classType = ChineseStringOrENFun(@"团课", @"Group");
    }
    if (room.course.type_int == 2 ) {
        perString = TrainerString;
        classType = ChineseStringOrENFun(@"私教", @"PERSON");
    }
    NSString *language = [room getCourse_language_string];
    if (language.length > 0) {
        classType = [NSString stringWithFormat:@"%@|%@",classType,language
        ];
    }
    _classTypeLabel.text = classType;
    NSString *nickname = [NSString stringWithFormat:@"%@:%@",perString,room.room_creator.nickname];
    self.roomuser.text = nickname;
    NSString *countryUrl = room.room_creator.country_icon;
    [self.countryimage sd_setImageWithURL: [NSURL URLWithString:countryUrl] placeholderImage:nil];
    NSString *roomidhead = ChineseStringOrENFun(@"房间ID",@"Room ID");
    self.roomidLabel.text = [NSString stringWithFormat:@"%@:%@",roomidhead,room.course.course_id];
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"type-calss%ld",(long)room.course.type_int]];
    _rightTopImage.image = image;
    [CommonTools changeBtnState:_joinBtn btnData:room];

}




@end
