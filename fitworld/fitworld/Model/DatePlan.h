#import "BaseObject.h"

@interface DatePlan : BaseObject

@property (nonatomic , copy) NSString              * plan_date;
@property (nonatomic , copy) NSString              * plan_time;
@property (nonatomic , assign) NSInteger              plan_timestamp;

- (BOOL)isEqualToDatePlan:(DatePlan *)datePlan;

@end
