#import "BaseObject.h"
#import "Course.h"
#import "CoachModel.h"
#import "Plan.h"
#import "DatePlan.h"
#import "RoomCreator.h"


//@protocol Course;
//@protocol RoomCreator;
@protocol Plan;
@protocol DatePlan;

@interface Room : BaseJSONModel

@property (nonatomic , assign) BOOL              allow_record;
@property (nonatomic , assign) BOOL              allow_watch; //允许观察
@property (nonatomic , assign) BOOL              count_me_in;
@property (nonatomic , strong) Course              * course;
@property (nonatomic , copy) NSString              * course_id;
@property (nonatomic , copy) NSString              * created_at;
@property (nonatomic , copy) NSString              * creator;
@property (nonatomic , assign) NSInteger              end_time;
@property (nonatomic , copy) NSString              * event_id; //房间id
@property (nonatomic , copy) NSString              * event_type;
@property (nonatomic , assign) NSInteger              exercise_count;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , assign) NSInteger              inadvance;
@property (nonatomic , assign) NSInteger              invite_count;
@property (nonatomic , assign) BOOL              is_room_user;
@property (nonatomic , assign) BOOL              is_start_in_advance;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , strong) RoomCreator              * room_creator;
@property (nonatomic , copy) NSString              * sdk_status;
@property (nonatomic , copy) NSString              * service_type;
@property (nonatomic , assign) NSInteger              start_time;
@property (nonatomic , assign) NSInteger              status; //不为0  表示正在直播
@property (nonatomic , copy) NSString              * updated_at;
@property (nonatomic , assign) NSInteger              watch_count;
@property (nonatomic , strong) NSString              *course_type;
@property (nonatomic , assign) BOOL                  is_join;

 //详情多用的字段
 @property (nonatomic , strong) NSString              *type;
 @property (nonatomic , assign) NSInteger              type_int;
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
 @property (nonatomic , assign) NSInteger              room_status;
 @property (nonatomic , strong) NSString              *creator_nickname;
 @property (nonatomic , strong) NSString              *creator_userid;
 @property (nonatomic , strong) NSString              *creator_avatar;
 @property (nonatomic , strong) NSString              *creator_country;
 @property (nonatomic , strong) NSString              *creator_city;
 @property (nonatomic , strong) NSString              *creator_country_icon;
 @property (nonatomic , assign) NSInteger              calorie;
 
#pragma mark - 自定义字段
@property (nonatomic , assign) NSInteger              roomDealState; //自己添加的一个状态


- (BOOL)isEqualToRoom:(Room *)room;

- (BOOL)isBegin;

//获取房间的真正状态
- (int)reachRoomDealState;

/*
 public static int ROOM_ITEM_APPOINTMENT = 1;    //1  显示预约    -> 预约 1  显示预约    -> 预约        绿色背景
 public static int ROOM_ITEM_ALREADY_APPOINTMENT = 2;    // //显示已预约 2  显示已预约  --> 取消预约    绿色背景
 public static int ROOM_ITEM_LOCK = 3;       //显示上锁 3  显示上锁   -- >无操作       灰色
 public static int ROOM_ITEM_FULL = 4;  //已约满    --> 无操作 4  已约满    --> 无操作       灰色
 public static int ROOM_ITEM_IN = 5;      //5  立即进入 5  立即进入   -->进入房间       红
 public static int ROOM_ITEM_PREPER = 6;  //6  房东立即进入  -->进入准备页面   红
 */


@end

/*
 "id": "43894864064023044",
 "type": "Buddy",
 "type_int": 0,
 "course_type": "31035841618971140",
 "course_type_name": "燃脂",
 "name": "测试用3分钟课程",
 "course_id": "43894864064023044",
 "pic": "/upload/379272659038374404.jpeg",
 "desc": "\u003cp\u003e3分钟燃脂运动测试用\u003c/p\u003e\n",
 "video_id": "31035842827258372",
 "duration": 10,
 "cal": 100,
 "heart_rate": "120",
 "coach_id": "43544829665217028",
 "coach_name": "浩沙教练1",
 "device_id": "",
 "device_name": "",
 "max_num": 6,
 "check_status": 1,
 "active_status": 0,
 "feedback": "",
 "created_at": 1635593777,
 "updated_at": 1635593784,
 "plan": [{
     "duration": 3,
     "stage": "哑铃"
 }],
 "date_plan": [],
 "coach": {
     "id": "43544829665217028",
     "username": "haosha001",
     "nickname": "浩沙教练1",
     "gender": 1,
     "avatar": "/upload/coach/avatar/378922653446048260.jpg",
     "mobile": "18888888888",
     "country": "china",
     "city": "北京",
     "teach": "燃脂",
     "status": 1,
     "remark": "哈哈哈哈哈哈",
     "last_login": 1635553453,
     "created_at": 1635385141,
     "updated_at": 1635553453
 },
 "invite_user_count": 3,
 "join_user_count": 1,
 "watch_user_count": 0,
 "is_room_user": false,
 "is_join": false,
 "allow_watch": false,
 "start_time": 1636220964,
 "room_status": 1,
 "creator_nickname": "Michaeltyyu",
 "creator_userid": "38616129811253764",
 "creator_avatar": "/avatar/43926060055661060.jpg",
 "creator_country": "Argentina",
 "creator_city": "La Plata",
 "creator_country_icon": "http://1.117.70.210:8091/assets/img/Argentina.jpg",
 "count_me_in": false,
 "calorie": 0
 */
