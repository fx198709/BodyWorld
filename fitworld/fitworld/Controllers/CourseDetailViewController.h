//
//  CourseDetailViewController.h
//  fitworld
//
//  Created by 王巍 on 2021/7/20.
//

#import <UIKit/UIKit.h>
#import "Room.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseDetailViewController : BaseNavViewController
@property(nonatomic,strong) Room *selectRoom;
@end

NS_ASSUME_NONNULL_END
