//
//  TrainingStartViewController.h
//  fitworld
//
//  Created by 王巍 on 2021/8/6.
//

#import <UIKit/UIKit.h>
#import "Room.h"
#import "OurDatePickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrainingStartViewController : BaseNavViewController<OurDatePickerViewDelegate>
@property(nonatomic,strong) Course *selectCourse;
@end

NS_ASSUME_NONNULL_END
