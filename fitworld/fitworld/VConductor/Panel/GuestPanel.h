//
//  SidePanel.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClassMember.h"
//访客的view
@interface GuestPanel : UIView
@property (nonatomic, strong) UIView* mMyView;
@property (nonatomic, strong) UILabel* mMyLabel;
@property (nonatomic, strong) UILabel* mNameLabel;
@property (nonatomic, strong) UIButton* mChatBtn;
@property (nonatomic, strong) NSString* userImageString;
@property (nonatomic, assign) BOOL needShowVideo; //是否需要展示，屏蔽的时候就不需要展示这个了

@property (copy) void(^pressBtnChat)(void);

@property (nonatomic, strong) NSString * mUserId;

- (id)init;
- (void)changeCountryIcon:(NSString*)imageurl;

//- (void)syncSession:(ClassMember*)session;
//第一次绑定没有效果，取消，再绑定一次
- (void)attachGuestRenderView:(int)Type; // 0 立刻绑定  1稍后绑定
- (void)detachGuestRenderView;

//屏蔽其他人 只显示头像
- (void)onlyShowUserImage;

//改变屏蔽他人的位置
- (void)changeUserImageLayout;

//显示其他人的流
- (void)showUservideo;

- (void)syncRemoteView;


@end
