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
    NSString *perString = ChineseStringOrENFun(@"创建人", @"Creator");
    if (room.course.type_int == 1) {
        perString = ChineseStringOrENFun(@"直播教练", @"Coach");
    }
    NSString *nickname = [NSString stringWithFormat:@"%@:%@",perString,room.room_creator.nickname];
    self.roomuser.text = nickname;
   
    [self.countryimage sd_setImageWithURL: [NSURL URLWithString:room.room_creator.country_icon] placeholderImage:nil];

    NSString *roomidhead = ChineseStringOrENFun(@"房间ID", @"Room ID");
    self.roomidLabel.text = [NSString stringWithFormat:@"%@:%@",roomidhead,room.event_id];
    _peopleLabel.text = [NSString stringWithFormat:ChineseStringOrENFun(@"已有%ld人", @"%ld p in"),
                         (long)room.invite_count];
//    3小时以上的 这个label不显示
    
    long currentTime = [[NSDate date] timeIntervalSince1970];
    long diff = room.start_time - currentTime;
    if (diff > 3600*3) {
        _timeDuringLabel.hidden = YES;
    }else{
        if (diff > 0) {
            _timeDuringLabel.hidden = NO;
            int hour = (int)diff/3600;
            int hourleft = diff%3600;
            int min = hourleft/60;
            int sec = hourleft%60;
            NSString *titleString = [NSString stringWithFormat:@"Till start %02d:%02d:%02d",hour,min,sec];
            NSString *chineseString = [NSString stringWithFormat:@"开始 %02d:%02d:%02d",hour,min,sec];
            _timeDuringLabel.text = ChineseStringOrENFun(chineseString, titleString);
        }else{
            _timeDuringLabel.hidden = NO;
        }
    }
    
     
    NSString *joinTitle = ChineseStringOrENFun(@"已预约", @"You‘RE IN");
    UIImage *joinImage = [UIImage imageNamed:@"action_button_bg_green"];
    if (!room.is_join) {
        joinTitle = ChineseStringOrENFun(@"预约", @"预约");
        joinImage = [UIImage imageNamed:@"action_button_bg_gray"];
    }
//    已经开始 或者自己是创建者
    BOOL isCreate = [room.creator_userid isEqualToString:[APPObjOnce sharedAppOnce].currentUser.id];
    if (room.status != 0 || isCreate) {
        joinTitle = ChineseStringOrENFun(@"立即进入", @"JOIN CLASS");
        joinImage = [UIImage imageNamed:@"action_button_bg_red"];
    }
    [_joinBtn setTitle:joinTitle forState:UIControlStateNormal];
    [_joinBtn setTitle:joinTitle forState:UIControlStateHighlighted];
    [_joinBtn setBackgroundImage:joinImage forState:UIControlStateNormal];
    [_joinBtn setBackgroundImage:joinImage forState:UIControlStateHighlighted];

}




@end
