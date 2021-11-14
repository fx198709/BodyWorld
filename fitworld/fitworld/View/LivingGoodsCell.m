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
    self.goodsImage.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    self.goodsImage.contentMode = UIViewContentModeScaleToFill;
    self.goodsImage.clipsToBounds = YES;
    _bottomview.clipsToBounds = YES;

}

- (void)changedatawithmodel:(Room*)room{
    self.startTime.text = ReachWeekTime(room.start_time);
    NSString *picUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, room.course.pic];
    [self.goodsImage sd_setImageWithURL: [NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    self.roomname.text = room.name;
    self.roomuser.text = room.room_creator.nickname;
    [self.countryimage sd_setImageWithURL: [NSURL URLWithString:room.room_creator.country_icon] placeholderImage:nil];
    NSString *roomidhead = ChineseStringOrENFun(@"房间ID",@"Room ID");
    self.roomidLabel.text = [NSString stringWithFormat:@"%@:%@",roomidhead,room.course.course_id];
    _joinBtn.titleLabel.text = ChineseStringOrENFun(@"立即进入", @"JOIN CLASS");
    [_joinBtn setBackgroundImage:[UIImage imageNamed:@"action_button_bg_red"] forState:UIControlStateNormal];
    [_joinBtn setBackgroundImage:[UIImage imageNamed:@"action_button_bg_red"] forState:UIControlStateHighlighted];

}




@end
