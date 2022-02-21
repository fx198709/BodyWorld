//
//  SidePanel.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClassMember.h"
//用户自己的视图
@interface SidePanel : UIView

@property (copy) void(^pressBtnChat)(void);

- (id)init;

- (void)syncSession:(ClassMember*)session;

- (void)attachLocalView;
- (void)detachLocalView;

@end
