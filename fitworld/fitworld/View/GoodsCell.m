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
    self.goodsImage.contentMode = UIViewContentModeScaleAspectFill;
    [_joinBtn setImage:nil forState:UIControlStateNormal];
    [_joinBtn setImage:nil forState:UIControlStateHighlighted];
    _grayBottomView.backgroundColor = UIRGBColor(33, 33, 33, 0.3);
    _grayBottomView.layer.cornerRadius = 3;
    _grayBottomView.clipsToBounds = YES;

}

- (void)changedatawithmodel:(Room*)room{
    self.startTime.text = ReachWeekTime(room.start_time);
    NSString *picUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, room.course.pic];
    [self.goodsImage sd_setImageWithURL: [NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    self.roomname.text = room.name;
    NSString *perString = ChineseStringOrENFun(@"房主", @"Creator");
    if (room.course.type_int == 1 || room.course.type_int == 2) {
        perString = ChineseStringOrENFun(@"教练", @"Coach");
    }
    
    NSString *nickname = [NSString stringWithFormat:@"%@:%@",perString,room.room_creator.nickname];
    self.roomuser.text = nickname;
    NSString *countryUrl = room.room_creator.country_icon;
    [self.countryimage sd_setImageWithURL: [NSURL URLWithString:countryUrl] placeholderImage:nil];
    NSString *roomidhead = ChineseStringOrENFun(@"房间ID", @"Room ID");
    self.roomidLabel.text = [NSString stringWithFormat:@"%@:%@",roomidhead,room.event_id];
    _peopleLabel.text = [NSString stringWithFormat:ChineseStringOrENFun(@"已有%ld人", @"%ld p in"),
                         (long)room.invite_count];
//    3小时以上的 这个label不显示
    
    long currentTime = [[NSDate date] timeIntervalSince1970];
    long diff = room.start_time - currentTime;
    _timeDuringLabel.text = @"";
    _timeDuringLabel.hidden = YES;
    _bottomConstraint.constant = 0;
    if (diff > 0 && diff < 3600*3) {
        _timeDuringLabel.hidden = NO;
        int hour = (int)diff/3600;
        int hourleft = diff%3600;
        int min = hourleft/60;
        int sec = hourleft%60;
        NSString *titleString = [NSString stringWithFormat:@"Till start %02d:%02d:%02d",hour,min,sec];
        NSString *chineseString = [NSString stringWithFormat:@"还差 %02d:%02d:%02d",hour,min,sec];
        _timeDuringLabel.text = ChineseStringOrENFun(chineseString, titleString);
        _bottomConstraint.constant = 2;
    }
    
    _joinBtn.titleLabel.font =SystemFontOfSize(13);
    [CommonTools changeBtnState:_joinBtn btnData:room];
}


@end
