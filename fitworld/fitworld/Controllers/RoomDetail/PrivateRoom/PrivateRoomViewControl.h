//
//  GroupRoomViewControl.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRoomViewController.h"
#import "Room.h"
@interface PrivateRoomViewControl : BaseRoomViewController
//进入直播间的前一个vc
@property(nonatomic, weak)UIViewController * invc;
@property(nonatomic, strong)Room * currentRoom;

- (id)initWith:(NSDictionary*)code;

@end
