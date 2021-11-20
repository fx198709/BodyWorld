//
//  RoomVC.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomVC : BaseNavViewController
//进入直播间的前一个vc
@property(nonatomic, weak)UIViewController * invc;

- (id)initWith:(NSDictionary*)code;


@end
