//
//  MTCalendarCell.h
//  MTCalender
//
//  Created by Tina on 2019/3/23.
//  Copyright © 2019年 Tina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTCalenderModel.h"


@interface MTCalendarCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong, nullable) MTCalenderModel *date;


@end


