//
//  MTCalendarView.h
//  MTCalender
//
//  Created by Tina on 2019/3/24.
//  Copyright © 2019年 Tina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTCalendarView : UIView

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;


- (void)reloadData;

@end

