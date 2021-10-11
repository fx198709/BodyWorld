#import "PractiseStatic.h"

@implementation PractiseStatic

- (instancetype)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        
        _total =  [json[@"total"] longLongValue];


    }
    return self;
}

- (BOOL)isEqualToUserInfo:(PractiseStatic *)practiseStatics
{
    return YES;
}


@end
