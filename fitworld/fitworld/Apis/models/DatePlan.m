#import "DatePlan.h"

@implementation DatePlan

- (instancetype)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        _plan_date = [self checkForNull: json[@"plan_date"]];
        _plan_time = [self checkForNull: json[@"plan_time"]];
        _plan_timestamp = [json[@"plan_timestamp"] longLongValue];
    }
    return self;
}

- (BOOL)isEqualToDatePlan:(DatePlan *)datePlan
{
    return YES;
}


@end
