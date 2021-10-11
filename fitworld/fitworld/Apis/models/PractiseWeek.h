//
//  UserInfo.h
//  fitworld
//
//

#import "BaseObject.h"

@interface PractiseWeek : BaseObject

@property (nonatomic , assign) NSInteger              heart_rate_min;
@property (nonatomic , assign) NSInteger              heart_rate_max;
@property (nonatomic , assign) NSInteger              cal;
@property (nonatomic , assign) NSInteger              total;

- (BOOL)isEqualToUserInfo:(PractiseWeek *)practiseWeek;

@end
