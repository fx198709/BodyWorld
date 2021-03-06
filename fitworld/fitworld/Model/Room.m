#import "Room.h"


@implementation Room


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

//commtools 里面还有一份处理  以commtools里面的为准
- (int)reachRoomDealState{
    //    创建者的id 做一个兼容
    NSString * roomCreaterID = self.room_creator.id ? self.room_creator.id:self.creator_userid;
    if ([self isBegin]) {
        //        已经开始直播
        if ([roomCreaterID isEqualToString:[APPObjOnce sharedAppOnce].currentUser.id]) {
            //            房主
            self.roomDealState = 5;
        }else if(self.is_room_user){
            self.roomDealState = 5;
        }
        else{
            if (self.allow_watch) {
                long maxnumber = MAX(self.max_num, self.course.max_num);
                if (maxnumber > self.invite_count) {
                    self.roomDealState = 5;
                }else{
                    self.roomDealState = 4;
                }
            }else{
                self.roomDealState = 3;
            }
        }
    }else{
        if ([roomCreaterID isEqualToString:[APPObjOnce sharedAppOnce].currentUser.id]) {
            //            创建人
            
            self.roomDealState = 6;
        }else if(self.is_room_user){ //被邀请人 或者加入人
            if (self.is_join) {
                
                self.roomDealState = 2;
            }else{
                self.roomDealState = 1;
            }
        }else{
            if (self.allow_watch) {
                long maxnumber = MAX(self.max_num, self.course.max_num);
                if (maxnumber > self.invite_count) {
                    self.roomDealState = 1;
                    
                }else{
                    self.roomDealState = 4;
                    
                }
            }else{
                self.roomDealState = 3;
                
            }
        }
    }
    
    return self.roomDealState;
}

@end
