#import "Room.h"



@implementation Room_creator

- (instancetype)initWithJSON:(NSDictionary *)json
{
    if (self = [super init]) {
        _avatar = [self checkForNull: json[@"avatar"]];
        _city = [self checkForNull: json[@"city"]];
        _country = [self checkForNull: json[@"country"]];
        _gender = [json[@"gender"] integerValue];
        _genderString = SexNameFormGender(_gender);
        
        _id = [self checkForNull: json[@"id"]];
        _nickname = [self checkForNull: json[@"nickname"]];
        _username = [self checkForNull: json[@"username"]];
        _country_icon =[self checkForNull: json[@"country_icon"]];
    }
    return  self;
}

@end

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
        Room_creator * create = [[Room_creator alloc] initWithJSON:json[@"room_creator"]];
        _room_creator = create;
        _sdk_status = [self checkForNull: json[@"sdk_status"]];
        _service_type = [self checkForNull: json[@"service_type"]];
        _start_time = [json[@"start_time"] integerValue];
        _status = [json[@"status"] integerValue];
        _updated_at = [NSString stringWithFormat:@"%@",[self checkForNull: json[@"updated_at"]]];
        _watch_count = [json[@"watch_count"] integerValue];
        
        //详情多用的字段
        self.type = NSStringFromDic(json, @"type", @"");
        self.type_int = LongValueFromDic(json, @"type_int", 0);
        self.course_type = NSStringFromDic(json, @"course_type", @"");
        self.course_type_name = NSStringFromDic(json, @"course_type_name", @"");
        self.pic = NSStringFromDic(json, @"pic", @"");
        self.desc = NSStringFromDic(json, @"desc", @"");
        self.video_id = NSStringFromDic(json, @"video_id", @"");
        self.duration = LongValueFromDic(json, @"duration", 0);
        self.cal = NSStringFromDic(json, @"cal", @"");
        self.heart_rate = NSStringFromDic(json, @"heart_rate", @"");
        self.coach_id = NSStringFromDic(json, @"coach_id", @"");
        self.coach_name = NSStringFromDic(json, @"coach_name", @"");
        self.device_id = NSStringFromDic(json, @"device_id", @"");
        self.device_name = NSStringFromDic(json, @"device_name", @"");
        self.max_num = LongValueFromDic(json, @"max_num", 0);
        self.check_status = LongValueFromDic(json, @"check_status", 0);
        self.active_status = LongValueFromDic(json, @"active_status", 0);
        self.feedback = NSStringFromDic(json, @"feedback", @"");
        NSMutableArray *tempPlanArray = [[NSMutableArray alloc] init];
        NSArray *planArray =[json objectForKey:@"plan"];
        if ([planArray isKindOfClass:NSArray.class] ) {
            for (NSDictionary *plandic in planArray) {
                Plan *tempPlan = [[Plan alloc] initWithJSON:plandic];
                [tempPlanArray addObject:tempPlan];
            }
        }
        self.plan = tempPlanArray;
        
        NSMutableArray *tempDatePlanArray = [[NSMutableArray alloc] init];
        NSArray *dateplanArray =[json objectForKey:@"dataPlan"];
        if ([dateplanArray isKindOfClass:NSArray.class] ) {
            for (NSDictionary *dateplandic in dateplanArray) {
                Plan *tempPlan = [[Plan alloc] initWithJSON:dateplandic];
                [tempDatePlanArray addObject:tempPlan];
            }
        }
        self.dataPlan =tempDatePlanArray;
        
        if ([json objectForKey:@"coach"]) {
            self.coach = [[CoachModel alloc] initWithJSON:[json objectForKey:@"coach"]];
        }
        
        self.invite_user_count = NSStringFromDic(json, @"invite_user_count", @"");
        self.join_user_count = NSStringFromDic(json, @"join_user_count", @"");
        self.watch_user_count = NSStringFromDic(json, @"watch_user_count", @"");
        self.is_join = BOOLValueFromDic(json, @"is_join", NO);
      
        self.room_status = LongValueFromDic(json, @"max_num", 0);
        self.creator_nickname = NSStringFromDic(json, @"creator_nickname", @"");
        self.creator_userid = NSStringFromDic(json, @"creator_userid", @"");
        self.creator_avatar = NSStringFromDic(json, @"creator_avatar", @"");
        self.creator_country = NSStringFromDic(json, @"creator_country", @"");
        self.creator_city = NSStringFromDic(json, @"creator_city", @"");
        self.creator_country_icon = NSStringFromDic(json, @"creator_country_icon", @"");
        self.calorie = LongValueFromDic(json, @"calorie", 0);

    }
    return self;
}
/*
 //详情多用的字段
 @property (nonatomic , strong) NSString              *type;
 @property (nonatomic , assign) NSInteger              type_int;
 @property (nonatomic , strong) NSString              *course_type;
 @property (nonatomic , strong) NSString              *course_type_name;
 @property (nonatomic , strong) NSString              *pic;
 @property (nonatomic , strong) NSString              *desc;
 @property (nonatomic , strong) NSString              *video_id;
 @property (nonatomic , strong) NSString              *duration;
 @property (nonatomic , strong) NSString              *cal;
 @property (nonatomic , strong) NSString              *heart_rate;
 @property (nonatomic , strong) NSString              *coach_id;
 @property (nonatomic , strong) NSString              *coach_name;
 @property (nonatomic , strong) NSString              *device_id;
 @property (nonatomic , strong) NSString              *device_name;
 @property (nonatomic , assign) NSInteger              max_num;
 @property (nonatomic , assign) NSInteger              check_status;
 @property (nonatomic , assign) NSInteger              active_status;
 @property (nonatomic , strong) NSString              *feedback;
 @property (nonatomic , strong) NSArray<Plan*>          *plan;
 @property (nonatomic , strong) NSArray<DatePlan*>      *dataPlan;
 @property (nonatomic , strong) CoachModel      *coach;
 @property (nonatomic , strong) NSString              *invite_user_count;
 @property (nonatomic , strong) NSString              *join_user_count;
 @property (nonatomic , strong) NSString              *watch_user_count;
 @property (nonatomic , assign) BOOL              is_join;
 @property (nonatomic , assign) NSInteger              room_status;
 @property (nonatomic , strong) NSString              *creator_nickname;
 @property (nonatomic , strong) NSString              *creator_userid;
 @property (nonatomic , strong) NSString              *creator_avatar;
 @property (nonatomic , strong) NSString              *creator_country;
 @property (nonatomic , strong) NSString              *creator_city;
 @property (nonatomic , strong) NSString              *creator_country_icon;
 @property (nonatomic , assign) NSInteger              calorie;
 */

- (BOOL)isEqualToRoom:(Room *)room
{
    return YES;
}


@end
