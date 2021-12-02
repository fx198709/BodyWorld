//
//  GroupDetailTableViewCell.m
//  FFitWorld
//
//  Created by feixiang on 2021/12/3.
//

#import "GroupDetailTableViewCell.h"
#import "UserHeadPicView.h"
#import "CoachViewController.h"

@implementation GroupDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeDatewithRoom:(Room*)selectRoom{
    RemoveSubviews(self.contentView, @[]);
    _currentRoom = selectRoom;
    int outwith = ScreenWidth;
    UIView *detailView = [[UIView alloc] init];
    [self.contentView addSubview:detailView];
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(outwith);
    }];
    
    
    UIView *userLeftView = [[UIView alloc]init];
    userLeftView.backgroundColor = UIColor.blackColor;
    [detailView addSubview:userLeftView];
    [userLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(detailView);
        make.top.equalTo(detailView);
        make.height.mas_equalTo(50);
        make.width.equalTo(detailView).multipliedBy(0.33);

    }];
    
    
    UILabel *getTimeLabel = [[UILabel alloc] init];
    getTimeLabel.text = [NSString stringWithFormat:@"%ld", (long)selectRoom.duration]; //@"5";
    getTimeLabel.font = [UIFont boldSystemFontOfSize:20];
    getTimeLabel.textColor= UIColor.whiteColor;
    getTimeLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = ChineseStringOrENFun(@"时长(分)", @"Time(min)");
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor= UIColor.whiteColor;

    timeLabel.adjustsFontSizeToFitWidth = YES;

    [userLeftView addSubview:timeLabel];
    [userLeftView addSubview:getTimeLabel];
    
    [getTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(userLeftView);
        make.top.equalTo(userLeftView).offset(5);
    }];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(getTimeLabel.mas_bottom).offset(8);
        make.centerX.equalTo(userLeftView);
    }];
    
    UIView *userMidView = [[UIView alloc]init];
    userMidView.backgroundColor = UIColor.blackColor;
    [detailView addSubview:userMidView];
    [userMidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView);
        make.left.equalTo(userLeftView.mas_right);
        make.height.mas_equalTo(50);
        make.width.equalTo(detailView).multipliedBy(0.33);
        
    }];
    

    UILabel *getHeartLabel = [[UILabel alloc] init];
    getHeartLabel.text = selectRoom.heart_rate.length > 0?selectRoom.heart_rate:@"  ";
    getHeartLabel.font = [UIFont boldSystemFontOfSize:20];;
    getHeartLabel.textColor= UIColor.whiteColor;
    getHeartLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *heartLabel = [[UILabel alloc] init];
    heartLabel.text = ChineseStringOrENFun(@"心率(Bpm)", @"Heart rate(Bpm)");
    heartLabel.font = [UIFont systemFontOfSize:13];
    heartLabel.textColor= UIColor.whiteColor;
    heartLabel.adjustsFontSizeToFitWidth = YES;

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
    userRightView.backgroundColor = UIColor.blackColor;
    [detailView addSubview:userRightView];
    [userRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView);
        make.right.equalTo(detailView);
        make.height.equalTo(userLeftView);
        make.left.equalTo(userMidView.mas_right);
    }];
    
    UILabel *getKcalLabel = [[UILabel alloc] init];
    getKcalLabel.text = [NSString stringWithFormat:@"%@", selectRoom.cal];
    getKcalLabel.font = [UIFont boldSystemFontOfSize:20];;
    getKcalLabel.textColor= UIColor.whiteColor;
    getKcalLabel.adjustsFontSizeToFitWidth = YES;
    
    UILabel *kcalLabel = [[UILabel alloc] init];
    kcalLabel.text =ChineseStringOrENFun(@"卡路里(Kcal)", @"Consumption(Kcal)");
    kcalLabel.textColor= UIColor.whiteColor;
    kcalLabel.font = [UIFont systemFontOfSize:13];
    kcalLabel.adjustsFontSizeToFitWidth = YES;

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
    
//    备注
    
    UILabel *vdesclabel = [[UILabel alloc]init];
    [self.contentView addSubview:vdesclabel];
    [vdesclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userLeftView.mas_bottom).offset(25);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);

    }];
    vdesclabel.preferredMaxLayoutWidth = ScreenWidth-20;
    vdesclabel.numberOfLines = 0;
    vdesclabel.font = SystemFontOfSize(15);
    vdesclabel.textColor = UIRGBColor(225, 225, 225, 1);
    vdesclabel.text = selectRoom.desc;
    [vdesclabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [vdesclabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = LineColor;
    [self.contentView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vdesclabel.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
//    教练
    UIView *coachView = [[UIView alloc] init];
    [self.contentView addSubview:coachView];
    [coachView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(lineview.mas_bottom).offset(5);
        make.height.mas_equalTo(80);
    }];
    
    UserHeadPicView * coachimageview = [[UserHeadPicView alloc] initWithFrame:CGRectMake(10, 20, 50, 50)];
    [coachView addSubview:coachimageview];
    [coachimageview changeCoachModelData:selectRoom.coach];
    [coachimageview.userBtn addTarget:self action:@selector(coachBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *courseLabel = [[UILabel alloc] init];
    courseLabel.adjustsFontSizeToFitWidth = YES;
    courseLabel.text = selectRoom.coach.nickname;
    courseLabel.textColor = UIColor.whiteColor;
    courseLabel.font =SystemFontOfSize(16);
    [coachView addSubview:courseLabel];
    [courseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coachView.mas_left).offset(75);
        make.top.equalTo(coachView).offset(25);
    }];
    
    UIImageView *countryImage = [[UIImageView alloc] init];
    [coachView addSubview:countryImage];
    [countryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(courseLabel.mas_right).offset(6);
        make.centerY.equalTo(courseLabel);
        make.size.mas_equalTo(CGSizeMake(20, 10));
    }];
    NSString *url = selectRoom.coach.country_icon;
    [countryImage sd_setImageWithURL:[NSURL URLWithString:url]];
    countryImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *courseCityLabel = [[UILabel alloc] init];
    courseCityLabel.adjustsFontSizeToFitWidth = YES;
    courseCityLabel.text = [NSString stringWithFormat:@"%@ - %@", selectRoom.coach.city, selectRoom.coach.country];
    courseCityLabel.textColor = LightGaryTextColor;
    courseCityLabel.font = SystemFontOfSize(14);
    [coachView addSubview:courseCityLabel];
    [courseCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(courseLabel.mas_bottom).offset(6);
        make.left.equalTo(courseLabel);
    }];
    
//    UIButton *followCoachBtn = [[UIButton alloc] init];
//
//    NSString *btntitle = ChineseStringOrENFun(@"关注", @"Follow");
//    [followCoachBtn setTitle:btntitle forState:UIControlStateNormal];
//    [followCoachBtn setTitle:btntitle forState:UIControlStateHighlighted];
//    followCoachBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
//    UIColor *greenColor = SelectGreenColor;
//    [followCoachBtn setTitleColor:greenColor forState:UIControlStateNormal];
//     [followCoachBtn setTitleColor:greenColor forState:UIControlStateHighlighted];
//    [coachView addSubview:followCoachBtn];
//    [followCoachBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(coachView.mas_top).offset(20);
//        make.right.equalTo(coachView).offset(-10);
//        make.height.mas_equalTo(40);
//        make.width.mas_equalTo(90);
//    }];
//    followCoachBtn.layer.cornerRadius = 20;
//    followCoachBtn.clipsToBounds = YES;
//    followCoachBtn.backgroundColor = UIColorFromRGB(37, 37, 37);
//    [followCoachBtn addTarget:self action:@selector(followBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineview1 = [[UIView alloc] init];
    lineview1.backgroundColor = LineColor;
    [self.contentView addSubview:lineview1];
    [lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coachView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *programLabel = [[UILabel alloc] init];
    programLabel.text = ChineseStringOrENFun(@"锻炼计划", @"Program");
    programLabel.font = [UIFont boldSystemFontOfSize:18];
    programLabel.textColor = UIColor.whiteColor;
    programLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:programLabel];
    [programLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview1.mas_bottom).offset(16);
        make.left.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(35);
    }];
    
    int planCount = (int)selectRoom.course.plan.count;
    int  backViewHeight = 40+ 30*planCount+30;
    UIView *planBackView = [[UIView alloc] init];
    [self.contentView addSubview:planBackView];
    [planBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(programLabel.mas_bottom).offset(16);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(backViewHeight);
    }];
    planBackView.backgroundColor = BgGrayColor;
    planBackView.layer.cornerRadius = 15;
    planBackView.clipsToBounds = YES;
    int allwith = outwith-60;
    UILabel *headleftLabel = [[UILabel alloc] init];
    [planBackView addSubview:headleftLabel];
    headleftLabel.textColor = UIColor.whiteColor;
    headleftLabel.font = [UIFont boldSystemFontOfSize:17];
    headleftLabel.frame = CGRectMake(20, 5, allwith* 0.4, 40);
//    headleftLabel.textAlignment = NSTextAlignmentCenter;
    headleftLabel.text = ChineseStringOrENFun(@"时长（分钟）", @"Time(min)");
    UILabel *headrightLabel = [[UILabel alloc] init];
    [planBackView addSubview:headrightLabel];
    headrightLabel.textColor = UIColor.whiteColor;
    headrightLabel.font = [UIFont boldSystemFontOfSize:20];
    headrightLabel.frame = CGRectMake(allwith* 0.4+30, 5, allwith* 0.6, 40);
    headrightLabel.text = ChineseStringOrENFun(@"内容", @"Content");
    for (int index=0; index< planCount; index++) {
        int starty = 40+10+30*index;
        Plan * plan = [selectRoom.course.plan objectAtIndex:index];
        UILabel *leftlabel = [self contentLabel];
        [planBackView addSubview:leftlabel];
        leftlabel.text = [NSString stringWithFormat:@"%ld",plan.duration];
//        leftlabel.textAlignment = NSTextAlignmentCenter;
        leftlabel.frame = CGRectMake(20, starty, allwith*0.4, 30);
        UILabel *rightlabel = [self contentLabel];
        [planBackView addSubview:rightlabel];
        rightlabel.frame = CGRectMake(allwith* 0.4+30, starty, allwith*0.6, 30);
        rightlabel.text = plan.stage;
    }
    
    
    UILabel *commentLabel = [[UILabel alloc] init];
    commentLabel.text = ChineseStringOrENFun(@"课程评价", @"Program");
    commentLabel.font = [UIFont boldSystemFontOfSize:18];
    commentLabel.textColor = UIColor.whiteColor;
    commentLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:commentLabel];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(planBackView.mas_bottom).offset(16);
        make.left.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(35);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
}


- (UILabel*)contentLabel{
    UILabel *vLabel = [[UILabel alloc] init];
    vLabel.textColor = UIRGBColor(225, 225, 225, 1);
    vLabel.font = SystemFontOfSize(17);
    return  vLabel;
}


- (void)coachBtnClicked{
    UIViewController *control = [CommonTools findControlWithView:self];
     CoachViewController *coachVC = VCBySBName(@"CoachViewController");
     coachVC.coacheId = _currentRoom.coach.id;
     [control.navigationController pushViewController:coachVC animated:YES];
     
}

 

@end
