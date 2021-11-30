//
//  Train2TableViewCell.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/20.
//

#import "Train2TableViewCell.h"

@implementation Train2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor blackColor];
    // Initialization code
}

- (void)changeDateWithRoomInfo:(Room*)roominfo{
    RemoveSubviews(self.contentView, @[]);
    int outwith = ScreenWidth-20;
    UIView *detailView = [[UIView alloc] init];
    detailView.backgroundColor = BgGrayColor;
    detailView.layer.cornerRadius = 8;
    detailView.clipsToBounds = YES;
    [self.contentView addSubview:detailView];
    int allheight = 60+ (int)roominfo.course.plan.count * 40;
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(allheight);
    }];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, outwith, 40)];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"p2c_end_title_pic1"]];
    imageview.frame = CGRectMake(20, 15, 22, 19);
    [topView addSubview:imageview];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 14, 200, 22)];
    [topView addSubview:titleLabel];
    titleLabel.font = SystemFontOfSize(17);
    titleLabel.text = ChineseStringOrENFun(@"Compan", @"Compan");
    titleLabel.textColor = UIColor.whiteColor;
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 49, outwith-20, 0.5)];
    lineview.backgroundColor = UIRGBColor(225, 225, 225, 0.5);
    [topView addSubview:lineview];
    [self.contentView addSubview:topView];
    
    for (int index = 0; index < roominfo.course.plan.count; index++) {
        Plan *plan = [roominfo.course.plan objectAtIndex:index];
        UIView *planView = [[UIView alloc] initWithFrame:CGRectMake(0, 60+40*index, outwith-20, 40)];
        [self.contentView addSubview:planView];
        UILabel *planTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 15, outwith-180, 20)];
        planTitle.textColor = LightGaryTextColor;
        planTitle.font = SystemFontOfSize(14);
        [planView addSubview:planTitle];
        planTitle.text = plan.stage;
        UILabel*timeLabel =  [[UILabel alloc] initWithFrame:CGRectMake(outwith-130, 15, 100, 20)];
        timeLabel.textColor = LightGaryTextColor;
        timeLabel.font = SystemFontOfSize(14);
        timeLabel.textAlignment = NSTextAlignmentRight;
        NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld:00",plan.duration/60,plan.duration%60];
        [planView addSubview:timeLabel];
        timeLabel.text = timeString;
    }
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
