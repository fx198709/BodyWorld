//
//  YJListViewController.h
//  YJPageController
//
//  Created by 于英杰 on 2019/4/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface TrainingInviteViewController : BaseNavViewController
@property(nonatomic,copy)NSString* pageVCindex;
@property(nonatomic,assign) CGFloat viewheight;
@property(nonatomic,strong) Course *selectCourse;
@property(nonatomic, strong) NSDate * inselectDate;

@property(nonatomic,copy)NSString* searchString;
@property(nonatomic,assign) NSInteger allowOtherType;


@end
