//
//  CoachModel.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/7.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN
//教练对象
@interface CoachModel : BaseJSONModel

@property (nonatomic , copy) NSString              * course_id;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * genderString;
@property (nonatomic , assign) NSInteger           gender;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * mobile;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic , copy) NSString              * country_icon;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * teach;
@property (nonatomic , assign) NSInteger           status;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * last_login;
@property (nonatomic , copy) NSString              * created_at;
@property (nonatomic , copy) NSString              * updated_at;
@property (nonatomic , assign) NSInteger        comment_total;
@property (nonatomic , assign) NSInteger        comment_grade;
@property (nonatomic , copy) NSString              * gym_name;
@property (nonatomic , copy) NSString              * gym_pic;
@property (nonatomic , copy) NSString              * id;

@end

NS_ASSUME_NONNULL_END

/*
 "id": "44768959819483652",
         "username": "tom",
         "nickname": "tom",
         "gender": 1,
         "avatar": "/upload/coach/avatar/382079414092958212.jpg",
         "mobile": "",
         "country": "德国",
         "country_icon": "http://1.117.70.210:8091/assets/img/德国.png",
         "city": "Munich",
         "teach": "燃脂,增肌",
         "status": 1,
         "remark": "",
         "last_login": 1638373689,
         "created_at": 1636114779,
         "updated_at": 1638373689,
         "comment_total": 16,
         "comment_grade": 0,
         "gym_name": "",
         "gym_pic": ""
 */
