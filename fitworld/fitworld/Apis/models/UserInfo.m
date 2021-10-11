#import "UserInfo.h"

@implementation UserInfo

- (instancetype)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        _avatar = [self checkForNull: json[@"avatar"]];
        _birthday = [self checkForNull: json[@"birthday"]];
        _cal = [json[@"cal"] longLongValue];
        _city = [self checkForNull: json[@"city"]];
        _country = [self checkForNull: json[@"country"]];
        _created_at = [self checkForNull: json[@"created_at"]];
        _duration =  [json[@"duration"] longLongValue];
        _gender =  [json[@"gender"] longLongValue];
        _heart_rate_max =  [json[@"heart_rate_max"] longLongValue];
        _heart_rate_min =  [json[@"heart_rate_min"] longLongValue];
        _height =  [json[@"height"] longLongValue];
        _id = [self checkForNull: json[@"id"]];
        _introduction = [self checkForNull: json[@"introduction"]];
        _last_login = [self checkForNull: json[@"last_login"]];
        _nickname = [self checkForNull: json[@"nickname"]];
        _profession = [self checkForNull: json[@"profession"]];
        _remark = [self checkForNull: json[@"remark"]];
        _status =  [json[@"status"] longLongValue];
        _tags = json[@"tags"];
        _updated_at = [self checkForNull: json[@"updated_at"]];
        _username = [self checkForNull: json[@"username"]];
        _weight =  [json[@"weight"] longLongValue];
    }
    return self;
}

- (BOOL)isEqualToUserInfo:(UserInfo *)userInfo
{
    return YES;
}


@end
