//
//  UserInfoView.m
//  FFitWorld
//
//  Created by feixiang on 2021/12/6.
//

#import "UserInfoView.h"
#import "UserHeadPicView.h"
@implementation UserInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)changeDatawithModel:(UserInfo*)userInfo andIsCreater:(BOOL)isCreate{
    self.user = userInfo;
    UserHeadPicView * coachimageview = [[UserHeadPicView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
    [self addSubview:coachimageview];
    [coachimageview changeUserInfoModelData:userInfo];
    
    UILabel *textview = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, 60, 40)];
    textview.backgroundColor = UIColor.clearColor;
    textview.textColor = UIColor.whiteColor;
    textview.text = userInfo.nickname;
    textview.textAlignment = NSTextAlignmentCenter;
    textview.numberOfLines = 0;
    textview.preferredMaxLayoutWidth = 60;
    textview.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:textview];
    textview.font = SystemFontOfSize(11);
    textview.clipsToBounds = YES;
    
//
    if (isCreate) {
        if (!userInfo.is_creator && !userInfo.is_join) {
            coachimageview.alpha = 0.5;
            _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
            [self addSubview:_deleteBtn];
            UIImage *delImage = [UIImage imageNamed:@"prepared_course_user_remove"];
            UIImageView *delImageview = [[UIImageView alloc] initWithImage:delImage];
            delImageview.frame = CGRectMake(7, 7, 16, 16);
            [_deleteBtn addSubview:delImageview];
        }
    }
}

- (void)changeDatawithRoomUser:(RoomUser*)userInfo andIsCreater:(BOOL)isCreate{
    self.roomUser = userInfo;
    if (userInfo == nil) {
        UIImage *nouser = [UIImage imageNamed:@"randomPeople"];
        UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
        imageview.image = nouser;
        [self addSubview:imageview];
    }else{
        UserHeadPicView * coachimageview = [[UserHeadPicView alloc] initWithFrame:CGRectMake(0, 10, 60, 60)];
        [self addSubview:coachimageview];
        NSString *urlString = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, userInfo.avatar];
        [coachimageview changeDataWithUserImageUrl:urlString];
    }
    
    
    UILabel *textview = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, 60, 40)];
    textview.backgroundColor = UIColor.clearColor;
    textview.textColor = UIColor.whiteColor;
    textview.text = userInfo.nickname?userInfo.nickname:@"";
    textview.textAlignment = NSTextAlignmentCenter;
    textview.numberOfLines = 0;
    textview.preferredMaxLayoutWidth = 60;
    textview.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:textview];
    textview.font = SystemFontOfSize(11);
    textview.clipsToBounds = YES;
    
//
//    if (isCreate) {
//        if (!userInfo.is_creator && !userInfo.is_join) {
//            coachimageview.alpha = 0.5;
//            _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 5, 30, 30)];
//            [self addSubview:_deleteBtn];
//            UIImage *delImage = [UIImage imageNamed:@"prepared_course_user_remove"];
//            UIImageView *delImageview = [[UIImageView alloc] initWithImage:delImage];
//            delImageview.frame = CGRectMake(7, 7, 16, 16);
//            [_deleteBtn addSubview:delImageview];
//        }
//    }
    
}




@end
