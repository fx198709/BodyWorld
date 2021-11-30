//
//  Train1TableViewCell.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/20.
//

#import "Train1TableViewCell.h"

@implementation Train1TableViewCell

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
    detailView.backgroundColor = BgGrayColor;
    detailView.layer.cornerRadius = 8;
    detailView.clipsToBounds = YES;
    
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(90);
        make.width.mas_equalTo(outwith);
    }];
    
    
    UIView *userLeftView = [[UIView alloc]init];
    userLeftView.backgroundColor = UIColor.clearColor;
    [detailView addSubview:userLeftView];
    [userLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detailView);
        make.top.equalTo(detailView).offset(15);
        make.height.mas_equalTo(50);
        make.width.equalTo(detailView).multipliedBy(0.33);

    }];
    
    
    UILabel *getTimeLabel = [[UILabel alloc] init];
    NSString *actionString = [NSString stringWithFormat:@"%ld",roominfo.course.plan.count];
    getTimeLabel.text = actionString; //@"5";
    getTimeLabel.font = [UIFont boldSystemFontOfSize:22];
    getTimeLabel.textColor= UIColor.whiteColor;
    
   
    
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = ChineseStringOrENFun(@"Action", @"Action");
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor= UIColor.whiteColor;
    [userLeftView addSubview:timeLabel];
    [userLeftView addSubview:getTimeLabel];
    
    UILabel *groupLabel = [[UILabel alloc] init];
    groupLabel.text = ChineseStringOrENFun(@"Group", @"Group"); //@"5";
    groupLabel.font = SystemFontOfSize(14);
    groupLabel.textColor= UIColor.whiteColor;
    [userLeftView addSubview:groupLabel];
    [groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userLeftView).offset(10);
        make.top.equalTo(userLeftView).offset(12);
    }];
    
    [getTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(groupLabel.mas_left).offset(-2);
        make.top.equalTo(userLeftView).offset(5);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getTimeLabel.mas_bottom).offset(8);
        make.centerX.equalTo(userLeftView);
    }];
    
    UIView *userMidView = [[UIView alloc]init];
    userMidView.backgroundColor = UIColor.clearColor;
    [detailView addSubview:userMidView];
    [userMidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView);
        make.left.equalTo(userLeftView.mas_right);
        make.height.mas_equalTo(50);
        make.width.equalTo(detailView).multipliedBy(0.33);
        
    }];
    

    UILabel *getHeartLabel = [[UILabel alloc] init];
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld:00",
                            (long)roominfo.course.duration/60,
                            (long)roominfo.course.duration%60];

    getHeartLabel.text = timeString;
    getHeartLabel.font = [UIFont boldSystemFontOfSize:22];;
    getHeartLabel.textColor= UIColor.whiteColor;
    
    UILabel *heartLabel = [[UILabel alloc] init];
    heartLabel.text = ChineseStringOrENFun(@"时长(分)", @"Time(min)");
    heartLabel.font = [UIFont systemFontOfSize:13];
    heartLabel.textColor= UIColor.whiteColor;

    [userMidView addSubview:heartLabel];
    [userMidView addSubview:getHeartLabel];
    
    [getHeartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userMidView);
        make.top.equalTo(userMidView).offset(5);
    }];
    [heartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getHeartLabel.mas_bottom).offset(8);
        make.centerX.equalTo(userMidView);
    }];
    
    
    UIView *userRightView = [[UIView alloc]init];
    userRightView.backgroundColor = UIColor.clearColor;
    [detailView addSubview:userRightView];
    [userRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView);
        make.right.equalTo(detailView);
        make.height.equalTo(userLeftView);
        make.left.equalTo(userMidView.mas_right);
    }];
    
    UILabel *getKcalLabel = [[UILabel alloc] init];
    getKcalLabel.text = [NSString stringWithFormat:@"%@", roominfo.course.cal];
    getKcalLabel.font = [UIFont boldSystemFontOfSize:22];
    getKcalLabel.textColor= UIColor.whiteColor;
    
    UILabel *kcalLabel = [[UILabel alloc] init];
    kcalLabel.text =ChineseStringOrENFun(@"卡路里(Kcal)", @"Consumption(Kcal)");
    kcalLabel.textColor= UIColor.whiteColor;
    kcalLabel.font = [UIFont systemFontOfSize:13];

    [userRightView addSubview:kcalLabel];
    [userRightView addSubview:getKcalLabel];
    
    [getKcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userRightView);
        make.top.equalTo(userRightView).offset(5);
    }];
    
    [kcalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getKcalLabel.mas_bottom).offset(8);
        make.centerX.equalTo(userRightView);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
