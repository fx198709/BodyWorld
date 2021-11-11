//
//  SidePanel.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClassMember.h"

@interface GuestPanel : UIView

@property (copy) void(^pressBtnChat)(void);

@property (nonatomic, strong) NSString * mUserId;

- (id)init;


- (void)syncSession:(ClassMember*)session;

- (void)attachGuestRenderView;
- (void)detachGuestRenderView;

@end
