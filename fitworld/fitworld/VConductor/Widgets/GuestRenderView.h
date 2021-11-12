//
//  GuestRenderView.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassMember.h"
@interface GuestRenderView : UIView

@property(nonatomic, strong)ClassMember *guestMember;
- (ClassMember*)reachGuestMember;
- (id)initWithUserId:(NSString*)uId forMainVideo:(BOOL)main;
- (NSString*)userId;
- (void)bindMedia;
- (void)unbindMedia;

//- (void)openGuestMedia;
//- (void)closeGuestMedia;
@end
