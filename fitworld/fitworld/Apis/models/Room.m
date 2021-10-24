#import "Room.h"

@implementation Room

- (instancetype)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        _allow_record = [json[@"allow_record"] boolValue];
        _allow_watch = [json[@"allow_watch"] boolValue];
        _count_me_in = [json[@"count_me_in"] boolValue];
        _course = [[Course alloc] initWithJSON:json[@"course"]];
        _course_id = [self checkForNull: json[@"course_id"]];
        _created_at = [self checkForNull: json[@"created_at"]];
        _creator = [self checkForNull: json[@"creator"]];
        _end_time = [json[@"end_time"] integerValue];
        _event_id = [self checkForNull: json[@"event_id"]];
        _event_type = [self checkForNull: json[@"event_type"]];
        _exercise_count = [json[@"exercise_count"] integerValue];
        _id = [self checkForNull: json[@"id"]];
        _inadvance = [json[@"inadvance"] integerValue];
        _invite_count = [json[@"invite_count"] integerValue];
        _is_room_user = [json[@"is_room_user"] boolValue];
        _is_start_in_advance = [json[@"is_start_in_advance"] boolValue];
        _name = [self checkForNull: json[@"name"]];
        _room_creator = [self checkForNull: json[@"room_creator"]];
        _sdk_status = [self checkForNull: json[@"sdk_status"]];
        _service_type = [self checkForNull: json[@"service_type"]];
        _start_time = [json[@"start_time"] integerValue];
        _status = [json[@"status"] integerValue];
        _updated_at = [NSString stringWithFormat:@"%@",[self checkForNull: json[@"updated_at"]]];
        _watch_count = [json[@"watch_count"] integerValue];
    }
    return self;
}

- (BOOL)isEqualToRoom:(Room *)room
{
    return YES;
}


@end
