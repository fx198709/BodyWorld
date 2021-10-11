#import "PractiseWeek.h"

@implementation PractiseWeek

- (instancetype)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        
        _heart_rate_min =  [json[@"heart_rate_min"] longLongValue];
        _heart_rate_max =  [json[@"heart_rate_max"] longLongValue];
        _cal =  [json[@"cal"] longLongValue];
        _total =  [json[@"total"] longLongValue];


    }
    return self;
}

- (BOOL)isEqualToUserInfo:(PractiseWeek *)practiseWeek
{
    return YES;
}


@end
