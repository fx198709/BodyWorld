//
//  SidePanel.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserHeadPicView.h"
#import "ClassMember.h"
//用户自己的视图
@interface SidePanel : UIView
@property (nonatomic, strong)UserHeadPicView* guestImageView;
@property (nonatomic, strong) NSString* userImageString;


@property (copy) void(^pressBtnChat)(void);

- (id)init;

- (void)syncSession:(ClassMember*)session;

- (void)attachLocalView;
- (void)detachLocalView;

//删除头像
- (void)deleteImageSubview;
//调整头像的位置
- (void)changeUserImageLayout;
//创建头像
- (void)createImageSubview;

@end
