//
//  SidePanel.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClassMember.h"

@interface GuestPanel : UIView
@property (nonatomic, strong) UIView* mMyView;
@property (nonatomic, strong) UILabel* mMyLabel;
@property (nonatomic, strong) UILabel* mNameLabel;
@property (nonatomic, strong) UIButton* mChatBtn;
@property (nonatomic, strong) NSString* userImageString;

@property (copy) void(^pressBtnChat)(void);

@property (nonatomic, strong) NSString * mUserId;

- (id)init;


- (void)syncSession:(ClassMember*)session;

- (void)attachGuestRenderView;
- (void)detachGuestRenderView;

//屏蔽其他人 只显示头像
- (void)onlyShowUserImage;
//显示其他人的流
- (void)showUservideo;

@end
