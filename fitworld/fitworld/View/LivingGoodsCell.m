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
    
//    NSString *titleText = ChineseStringOrENFun(@"立即进入", @"JOIN CLASS");
//    [_joinBtn setTitle:titleText forState:UIControlStateNormal];
//    [_joinBtn setTitle:titleText forState:UIControlStateHighlighted];

    _joinBtn.titleLabel.font = SystemFontOfSize(14);
//    [_joinBtn setBackgroundImage:[UIImage imageNamed:@"action_button_bg_red"] forState:UIControlStateNormal];
//    [_joinBtn setBackgroundImage:[UIImage imageNamed:@"action_button_bg_red"] forState:UIControlStateHighlighted];

}

- (void)changedatawithmodel:(Room*)room{
    self.startTime.text = ReachWeekTime(room.start_time);
    NSString *picUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, room.course.pic];
    [self.goodsImage sd_setImageWithURL: [NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    self.roomname.text = room.name;
    NSString *perString = ChineseStringOrENFun(@"创建人", @"Created by");
    _classTypeLabel.text = ChineseStringOrENFun(@"对练课", @"Buddy");
    _classTypeLabel.textColor = BgGrayColor;
    if (room.course.type_int == 1 ) {
        perString = ChineseStringOrENFun(@"教练", @"Coach");
        _classTypeLabel.text = ChineseStringOrENFun(@"团课", @"Group");
    }
    if (room.course.type_int == 2 ) {
        perString = ChineseStringOrENFun(@"教练", @"Coach");
        _classTypeLabel.text = ChineseStringOrENFun(@"私教", @"Group");
    }
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
