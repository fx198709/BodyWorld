#import "BaseObject.h"
#import "DatePlan.h"
#import "Plan.h"

@interface Course : BaseObject

@property (nonatomic , strong) NSArray <DatePlan *>              * date_plan;
@property (nonatomic , strong) NSArray <Plan *>              * plan;
@property (nonatomic , assign) NSInteger              active_status;
@property (nonatomic , assign) NSInteger              cal;
@property (nonatomic , assign) NSInteger              check_status;
@property (nonatomic , copy) NSString              * coach_id;
@property (nonatomic , copy) NSString              * coach_name;
@property (nonatomic , copy) NSString              * course_id;
@property (nonatomic , copy) NSString              * course_type;
@property (nonatomic , copy) NSString              * course_type_name;
@property (nonatomic , copy) NSString              * created_at;
@property (nonatomic , copy) NSString              * desc;
@property (nonatomic , copy) NSString              * device_id;
@property (nonatomic , copy) NSString              * device_name;
@property (nonatomic , assign) NSInteger              duration;
@property (nonatomic , copy) NSString              * feedback;
@property (nonatomic , copy) NSString              * heart_rate;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , assign) NSInteger              max_num;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * type;
@property (nonatomic , assign) NSInteger              type_int;
@property (nonatomic , copy) NSString              * updated_at;
@property (nonatomic , strong) NSString              * updated_at_weekDay;

@property (nonatomic , copy) NSString              * video_id;

- (BOOL)isEqualToCourse:(Course *)course;

@end
