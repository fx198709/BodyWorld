//
//  HasJoinGroupRoomView.m
//  FFitWorld
//
//  Created by feixiang on 2021/12/13.
//

#import "HasJoinGroupRoomView.h"
#import "UserInfo.h"
@implementation HasJoinGroupRoomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)changeviewWithUselist:(NSArray*)userList{
    self.layer.cornerRadius = 17;
    self.clipsToBounds = YES;
    _userNumberLabel.textColor = SelectGreenColor;
    _firstUserImageview.layer.cornerRadius = 12;
    _firstUserImageview.clipsToBounds = YES;
    _secondUserImageview.layer.cornerRadius = 12;
    _secondUserImageview.clipsToBounds = YES;
    _textLabel.text =ChineseStringOrENFun(@"用户已预约", @"People has preview");
    _secondUserImageview.hidden = NO;
    UIImage *normalimage = [UIImage imageNamed:@"choose_course_foot_logo3_unselected"];
    if (userList == nil || userList.count == 0) {
        _userNumberLabel.text = @"0";
        _rightConstarint.constant = 23;
        _firstUserImageview.image = normalimage;
        _secondUserImageview.image =normalimage;
    }else{
        if (userList.count == 1) {
            _userNumberLabel.text = @"1";
            _rightConstarint.constant = 9;
            _secondUserImageview.hidden = YES;
            UserInfo *user = [userList lastObject];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, user.avatar]];
            [_firstUserImageview sd_setImageWithURL:url];
        }else{
            _userNumberLabel.text = [NSString stringWithFormat:@"%ld",userList.count];
            _rightConstarint.constant = 23;
            UserInfo *user1 = [userList objectAtIndex:0];
            NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, user1.avatar]];
            [_firstUserImageview sd_setImageWithURL:url1];
            UserInfo *user2 = [userList objectAtIndex:0];
            NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, user2.avatar]];
            [_firstUserImageview sd_setImageWithURL:url2];
        }
    }
}


@end
