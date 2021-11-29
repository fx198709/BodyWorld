#import "Course.h"

@implementation Course
//
//- (instancetype)initWithJSON:(NSDictionary *)json
//{
//    if (self = [super init]) {
//        _active_status = [json[@"active_status"] integerValue];
//        _cal = [json[@"cal"] integerValue];
//        _check_status = [json[@"check_status"] integerValue];
//        _coach_id = [self checkForNull: json[@"coach_id"]];
//        _coach_name = [self checkForNull: json[@"coach_name"]];
//        _course_id = [self checkForNull: json[@"course_id"]];
//        _course_type = [self checkForNull: json[@"course_type"]];
//        _course_type_name = [self checkForNull: json[@"course_type_name"]];
//        _created_at = [self checkForNull: json[@"created_at"]];
//        _desc = [self checkForNull: json[@"desc"]];
//        _device_id = [self checkForNull: json[@"device_id"]];
//        _device_name = [self checkForNull: json[@"device_name"]];
//        _duration = [json[@"duration"] integerValue];
//        _feedback = [self checkForNull: json[@"feedback"]];
//        _heart_rate = [self checkForNull: json[@"heart_rate"]];
//        _id = [self checkForNull: json[@"id"]];
//        _max_num = [json[@"max_num"] integerValue];
//        _name = [self checkForNull: json[@"name"]];
//        _pic = [self checkForNull: json[@"pic"]];
//        _type = [self checkForNull: json[@"type"]];
//        _type_int = [json[@"type_int"] integerValue];
//        _updated_at = [self checkForNull: json[@"updated_at"]];
//        _video_id = [self checkForNull: json[@"video_id"]];
//        _updated_at_weekDay = ReachWeekTime([json[@"updated_at"] longLongValue]);
////        _date_plan = [self jsonToObject: [self checkForNull: json[@"date_plan"]]];
////        _plan = [self jsonToObject: [self checkForNull: json[@"plan"]]];
//
//    }
//    return self;
//}

- (BOOL)isEqualToCourse:(Course *)course
{
    return YES;
}


@end
