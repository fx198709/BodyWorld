#import "Plan.h"

@implementation Plan

- (instancetype)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        _duration = [json[@"duration"] longLongValue];
        _stage = [self checkForNull: json[@"stage"]];
    }
    return self;
}

- (BOOL)isEqualToPlan:(Plan *)plan
{
    return YES;
}


@end
