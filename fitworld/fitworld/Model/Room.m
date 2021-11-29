#import "Room.h"


@implementation Room


- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
    if (self = [super initWithDictionary:dict error:err]) {
        [self dealData];
    }
    return self;
}
- (void)dealData {
    self.creator_country_icon = [self.creator_country_icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
//    _allow_record = [json[@"allow_record"] boolValue];
//    _allow_watch = [json[@"allow_watch"] boolValue];
//    _count_me_in = [json[@"count_me_in"] boolValue];
//    _course = [[Course alloc] initWithJSON:json[@"course"]];
//    _course_id = [self checkForNull: json[@"course_id"]];
//    _created_at = [self checkForNull: json[@"created_at"]];
//    _creator = [self checkForNull: json[@"creator"]];
//    _end_time = [json[@"end_time"] integerValue];
//    _event_id = [self checkForNull: json[@"event_id"]];
//    _event_type = [self checkForNull: json[@"event_type"]];
//    _exercise_count = [json[@"exercise_count"] integerValue];
//    _id = [self checkForNull: json[@"id"]];
//    _inadvance = [json[@"inadvance"] integerValue];
//    _invite_count = [json[@"invite_count"] integerValue];
//    _is_room_user = [json[@"is_room_user"] boolValue];
//    _is_start_in_advance = [json[@"is_start_in_advance"] boolValue];
//    _name = [self checkForNull: json[@"name"]];
//    Room_creator * create = [[Room_creator alloc] initWithJSON:json[@"room_creator"]];
//    _room_creator = create;
//    _sdk_status = [self checkForNull: json[@"sdk_status"]];
//    _service_type = [self checkForNull: json[@"service_type"]];
//    _start_time = [json[@"start_time"] integerValue];
//    _status = [json[@"status"] integerValue];
//    _updated_at = [NSString stringWithFormat:@"%@",[self checkForNull: json[@"updated_at"]]];
//    _watch_count = [json[@"watch_count"] integerValue];
    
    //详情多用的字段
//    self.type = NSStringFromDic(json, @"type", @"");
//    self.type_int = LongValueFromDic(json, @"type_int", 0);
//    self.course_type = NSStringFromDic(json, @"course_type", @"");
//    self.course_type_name = NSStringFromDic(json, @"course_type_name", @"");
//    self.pic = NSStringFromDic(json, @"pic", @"");
//    self.desc = NSStringFromDic(json, @"desc", @"");
//    self.video_id = NSStringFromDic(json, @"video_id", @"");
//    self.duration = LongValueFromDic(json, @"duration", 0);
//    self.cal = NSStringFromDic(json, @"cal", @"");
//    self.heart_rate = NSStringFromDic(json, @"heart_rate", @"");
//    self.coach_id = NSStringFromDic(json, @"coach_id", @"");
//    self.coach_name = NSStringFromDic(json, @"coach_name", @"");
//    self.device_id = NSStringFromDic(json, @"device_id", @"");
//    self.device_name = NSStringFromDic(json, @"device_name", @"");
//    self.max_num = LongValueFromDic(json, @"max_num", 0);
//    self.check_status = LongValueFromDic(json, @"check_status", 0);
//    self.active_status = LongValueFromDic(json, @"active_status", 0);
//    self.feedback = NSStringFromDic(json, @"feedback", @"");
//    self.invite_user_count = NSStringFromDic(json, @"invite_user_count", @"");
//    self.join_user_count = NSStringFromDic(json, @"join_user_count", @"");
//    self.watch_user_count = NSStringFromDic(json, @"watch_user_count", @"");
//    self.is_join = BOOLValueFromDic(json, @"is_join", NO);
//  
//    self.room_status = LongValueFromDic(json, @"max_num", 0);
//    self.creator_nickname = NSStringFromDic(json, @"creator_nickname", @"");
//    self.creator_userid = NSStringFromDic(json, @"creator_userid", @"");
//    self.creator_avatar = NSStringFromDic(json, @"creator_avatar", @"");
//    self.creator_country = NSStringFromDic(json, @"creator_country", @"");
//    self.creator_city = NSStringFromDic(json, @"creator_city", @"");
//    self.creator_country_icon = NSStringFromDic(json, @"creator_country_icon", @"");
//
//    self.calorie = LongValueFromDic(json, @"calorie", 0);

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

//这个课程，是否已经开始了
- (BOOL)isBegin{
    NSTimeInterval timeNow = [[NSDate date] timeIntervalSince1970];
//     当前时间 大于房间开始时间
    return (self.status != 0 || self.start_time < timeNow);
}

//commtools 里面还有一份处理
- (int)reachRoomDealState{
    if ([self isBegin]) {
//        已经开始直播
        if ([self.room_creator.id isEqualToString:[APPObjOnce sharedAppOnce].currentUser.id]) {
//            房主
            self.roomDealState = 5;
        }else{
            if (self.is_join) {
                self.roomDealState = 5;
            }else{
                if (self.allow_watch) {
                    if (self.course.max_num > self.invite_count) {
                        self.roomDealState = 5;
                    }else{
                        self.roomDealState = 4;
                    }
                }else{
                    self.roomDealState = 3;
                }
            }
        }
    }else{
        if ([self.room_creator.id isEqualToString:[APPObjOnce sharedAppOnce].currentUser.id]) {
    //        当前使用人
            self.roomDealState = 6;
        }else{
            if (self.is_join) {
                self.roomDealState = 2;
            }else{
                if (self.allow_watch) {
                    if (self.course.max_num > self.invite_count) {
                        self.roomDealState = 1;
                       
                    }else{
                        self.roomDealState = 4;
                    }
                }else{
                    self.roomDealState = 3;
                }
            }
        }
    }
    return  self.roomDealState;
}




@end
