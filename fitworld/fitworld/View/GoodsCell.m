//
//  GoodsCell.m
//  TableNested
//
//  Created by HanOBa on 2019/4/25.
//  Copyright © 2019 HanOBa. All rights reserved.
//

#import "GoodsCell.h"

@implementation GoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.layer.masksToBounds = YES;
    self.goodsImage.layer.cornerRadius = 6;
    self.clipsToBounds = YES;
    self.goodsImage.contentMode = UIViewContentModeScaleToFill;

}

- (void)changedatawithmodel:(Room*)room{
    self.startTime.text = ReachWeekTime(room.start_time);
    NSString *picUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, room.course.pic];
    [self.goodsImage sd_setImageWithURL: [NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    self.roomname.text = room.name;
    self.roomuser.text = room.room_creator.nickname;
   
    [self.countryimage sd_setImageWithURL: [NSURL URLWithString:room.room_creator.country_icon] placeholderImage:nil];

    NSString *roomidhead = ChineseStringOrENFun(@"房间ID",@"Room ID");
    self.roomidLabel.text = [NSString stringWithFormat:@"%@:%@",roomidhead,room.event_id];
    _peopleLabel.text = [NSString stringWithFormat:@"已有%ld人",(long)room.invite_count];
     
    NSString *joinTitle = ChineseStringOrENFun(@"已预约", @"已预约");
    UIImage *joinImage = [UIImage imageNamed:@"action_button_bg_green"];
    if (!room.is_join) {
        joinTitle = ChineseStringOrENFun(@"预约", @"预约");
        joinImage = [UIImage imageNamed:@"action_button_bg_gray"];
    }
//    已经开始 或者自己是创建者
    if (room.status != 0 || room.is_room_user) {
        joinTitle = ChineseStringOrENFun(@"立即进入", @"JOIN CLASS");
        joinImage = [UIImage imageNamed:@"action_button_bg_red"];
    }
    [_joinBtn setTitle:joinTitle forState:UIControlStateNormal];
    [_joinBtn setTitle:joinTitle forState:UIControlStateHighlighted];
    [_joinBtn setBackgroundImage:joinImage forState:UIControlStateNormal];
    [_joinBtn setBackgroundImage:joinImage forState:UIControlStateHighlighted];

}




@end
