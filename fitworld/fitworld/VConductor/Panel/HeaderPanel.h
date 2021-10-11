//
//  HeaderPanel.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VConductorClient.h"

@interface HeaderPanel : UIView

- (id)init;
- (void)stopTimer;

- (void)setRoomTitle:(NSString*)title;
- (void)syncSession:(ClassMember*)session;

@property (copy) void(^pressBtnSwitchMode)(void);
@property (copy) void(^pressBtnQuit)(void);
@property (copy) void(^pressBtnHand)(void);
@property (copy) void(^pressBtnMic)(void);
@property (copy) void(^pressBtnCamera)(void);
@property (copy) void(^pressBtnFullScreen)(void);

@end
