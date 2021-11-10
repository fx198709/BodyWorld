//
//  UserHeadPicView.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/10.
//

#import "UserHeadPicView.h"

@implementation UserHeadPicView

- (void)changeHeadData:(BaseObject*)headModel{
    RemoveSubviews(self, @[]);
    CGSize  parentSize = self.frame.size;
    UIView  *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentSize.width, parentSize.height)];
    [self addSubview:whiteBackView];
    whiteBackView.backgroundColor = UIColor.whiteColor;
    whiteBackView.clipsToBounds = YES;
    whiteBackView.layer.cornerRadius = parentSize.width/2;
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(3,3, parentSize.width-6, parentSize.height-6)];
    [self addSubview:userImage];
    userImage.clipsToBounds = YES;
    userImage.layer.cornerRadius = parentSize.width/2;
    NSString *url = @"";
    [userImage sd_setImageWithURL:[NSURL URLWithString:url]];
}


@end
