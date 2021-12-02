//
//  UserHeadPicView.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/10.
//

#import "UserHeadPicView.h"
@implementation UserHeadPicView

- (void)changeHeadData:(BaseObject*)headModel{
    
}
- (void)changeDataWithModel:(NSString*)url{
    RemoveSubviews(self, @[]);
    CGSize  parentSize = self.frame.size;
    _userBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, parentSize.width, parentSize.height)];
    [self addSubview:_userBtn];
    _userBtn.backgroundColor = UIColor.whiteColor;
    _userBtn.clipsToBounds = YES;
    _userBtn.layer.cornerRadius = parentSize.width/2;
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(2,2, parentSize.width-4, parentSize.height-4)];
    [self addSubview:userImage];
    userImage.clipsToBounds = YES;
    userImage.layer.cornerRadius = (parentSize.width-4)/2;
    [userImage sd_setImageWithURL:[NSURL URLWithString:url]];
}

- (void)changeCoachModelData:(CoachModel*)headModel{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, headModel.avatar];
    [self changeDataWithModel:urlString];
}

- (void)changeUserInfoModelData:(UserInfo*)headModel{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, headModel.avatar];
    [self changeDataWithModel:urlString];
}
- (void)changeRoomModelData:(Room*)roomModel{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, roomModel.room_creator.avatar];
    [self changeDataWithModel:urlString];
}

- (void)changeCommentModelData:(CoachComment*)comment{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, comment.avatar];
    [self changeDataWithModel:urlString];
}




@end
