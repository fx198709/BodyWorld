//
//  Train3TableViewCell.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/20.
//

#import "Train3TableViewCell.h"
#import "UserHeadPicView.h"
@implementation Train3TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor blackColor];
}

- (void)changeDataWithUserList:(NSArray*)userList{
    RemoveSubviews(self.contentView, @[]);
    self.currentUsers = userList;
    int outwith = ScreenWidth-20;
    UIView *detailView = [[UIView alloc] init];
    detailView.backgroundColor = BuddyTableBackColor;
    detailView.layer.cornerRadius = 8;
    detailView.clipsToBounds = YES;
    [self.contentView addSubview:detailView];
    int allheight = 60+ userList.count * 50;
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
    titleLabel.text = ChineseStringOrENFun(@"伙伴", @"Partner");
    titleLabel.textColor = UIColor.whiteColor;
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(10, 49, outwith-20, 0.5)];
    lineview.backgroundColor = UIRGBColor(225, 225, 225, 0.5);
    [topView addSubview:lineview];
    [self.contentView addSubview:topView];
    
    for (int index = 0; index < userList.count; index++) {
        UserInfo *user = [userList objectAtIndex:index];
        UIView *planView = [[UIView alloc] initWithFrame:CGRectMake(0, 60+50*index, outwith-20, 50)];
        [self.contentView addSubview:planView];
        UserHeadPicView * coachimageview = [[UserHeadPicView alloc] initWithFrame:CGRectMake(40, 10, 30, 30)];
        [planView addSubview:coachimageview];
        [coachimageview changeUserInfoModelData:user];
        
        UILabel *planTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, outwith-220, 20)];
        planTitle.textColor = LittleTextColor;
        planTitle.font = SystemFontOfSize(14);
        [planView addSubview:planTitle];
        planTitle.text = user.nickname;
        
        if (!user.is_friend && user.id != [APPObjOnce sharedAppOnce].currentUser.id) {
//            不是好友，增加一个好友的功能
            UIButton *vbutton = [[UIButton alloc] initWithFrame:CGRectMake(outwith-80, 3, 40, 40)];
            [planView addSubview:vbutton];
            UIImage *peopleImage = [UIImage imageNamed:@"add_people"];
            [vbutton setImage:peopleImage forState:UIControlStateNormal];
            [vbutton setImage:peopleImage forState:UIControlStateHighlighted];
            vbutton.tag = 100+index;
            [vbutton addTarget:self action:@selector(addPeopleBtnClciked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    
}

- (void)addPeopleBtnClciked:(UIButton*)vbutton{
    NSInteger tag = vbutton.tag -100;
    if (self.currentUsers.count > tag) {
        UserInfo *user = [self.currentUsers objectAtIndex:tag];
        if (self.peopleBtnClick) {
            self.peopleBtnClick(user);
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
