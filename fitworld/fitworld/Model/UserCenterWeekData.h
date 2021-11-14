//
//  UserCenterWeekData.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/14.
//

#import "BaseJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCenterWeekData : BaseJSONModel

@property (nonatomic, assign) int heart_rate_min;
@property (nonatomic, assign) int heart_rate_max;
@property (nonatomic, assign) int cal;
@property (nonatomic, assign) int total;
@property (nonatomic, assign) int duration;

@end

NS_ASSUME_NONNULL_END
