#import "UserInfo.h"

@implementation UserInfo

+ (instancetype)sharedUserInfo {
    static UserInfo *_shareduser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareduser = [[UserInfo alloc] init];
    });
    
    return _shareduser;
}

- (instancetype)initWithJSON:(NSDictionary *)json
{
    NSError *error;

    if (self = [[UserInfo alloc] initWithDictionary:json error:&error]) {
        _hasSelect = NO;
    }
    return self;
}

- (BOOL)isEqualToUserInfo:(UserInfo *)userInfo
{
    return YES;
}


@end
