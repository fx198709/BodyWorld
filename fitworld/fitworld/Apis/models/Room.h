#import "BaseObject.h"
#import "Course.h"

@interface Room_creator :BaseObject
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic , assign) NSInteger              gender;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * username;

@end

@interface Room : BaseObject

@property (nonatomic , assign) BOOL              allow_record;
@property (nonatomic , assign) BOOL              allow_watch;
@property (nonatomic , assign) BOOL              count_me_in;
@property (nonatomic , strong) Course              * course;
@property (nonatomic , copy) NSString              * course_id;
@property (nonatomic , copy) NSString              * created_at;
@property (nonatomic , copy) NSString              * creator;
@property (nonatomic , assign) NSInteger              end_time;
@property (nonatomic , copy) NSString              * event_id;
@property (nonatomic , copy) NSString              * event_type;
@property (nonatomic , assign) NSInteger              exercise_count;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , assign) NSInteger              inadvance;
@property (nonatomic , assign) NSInteger              invite_count;
@property (nonatomic , assign) BOOL              is_room_user;
@property (nonatomic , assign) BOOL              is_start_in_advance;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , strong) Room_creator              * room_creator;
@property (nonatomic , copy) NSString              * sdk_status;
@property (nonatomic , copy) NSString              * service_type;
@property (nonatomic , assign) NSInteger              start_time;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , copy) NSString              * updated_at;
@property (nonatomic , assign) NSInteger              watch_count;

- (BOOL)isEqualToRoom:(Room *)room;

@end
