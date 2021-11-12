//
//  CoachModel.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/7.
//

#import "BaseObject.h"

NS_ASSUME_NONNULL_BEGIN
//教练对象
@interface CoachModel : BaseObject
@property (nonatomic , copy) NSString              * course_id;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * genderString;
@property (nonatomic , assign) NSInteger           gender;
@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * mobile;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * teach;
@property (nonatomic , assign) NSInteger           status;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * last_login;
@property (nonatomic , copy) NSString              * created_at;
@property (nonatomic , copy) NSString              * updated_at;

@end

NS_ASSUME_NONNULL_END

/*
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
 */
