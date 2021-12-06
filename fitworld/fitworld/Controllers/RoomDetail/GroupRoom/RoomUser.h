//
//  RoomUser.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/6.
//

#import "BaseJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomUser : BaseJSONModel

@property(nonatomic, strong)NSString *id;
@property(nonatomic, strong)NSString *username;
@property(nonatomic, strong)NSString *nickname;
@property(nonatomic, strong)NSString *mobile_code;
@property(nonatomic, strong)NSString *mobile;
@property(nonatomic, strong)NSString *avatar;
@property(nonatomic, strong)NSString *gender;
@property(nonatomic, strong)NSString *birthday;
@property(nonatomic, strong)NSString *height;
@property(nonatomic, strong)NSString *weight;
@property(nonatomic, strong)NSString *country;
@property(nonatomic, strong)NSString *country_icon;
@property(nonatomic, strong)NSString *city;
@property(nonatomic, strong)NSString *lan;
@property(nonatomic, strong)NSString *profession;
@property(nonatomic, strong)NSString *introduction;
@property(nonatomic, strong)NSString *tags;
@property(nonatomic, strong)NSString *remark;
@property(nonatomic, strong)NSString *cal;
@property(nonatomic, strong)NSString *heart_rate_min;
@property(nonatomic, strong)NSString *heart_rate_max;
@property(nonatomic, strong)NSString *duration;
@property(nonatomic, strong)NSString *status;
@property(nonatomic, strong)NSString *invite_uid;
@property(nonatomic, strong)NSString *last_login;
@property(nonatomic, strong)NSString *last_login_ip;
@property(nonatomic, assign)long created_at;
@property(nonatomic, assign)long updated_at;
@property(nonatomic, assign)NSInteger is_accept;
@property(nonatomic, assign)BOOL is_creator;

@end

NS_ASSUME_NONNULL_END


//id": "46009524363987460",
//            "username": "+86:18601061163",
//            "nickname": "186****1163",
//            "mobile_code": "+86",
//            "mobile": "18601061163",
//            "avatar": "/assets/home/images/avatar.png",
//            "gender": 0,
//            "birthday": "",
//            "height": 0,
//            "weight": 0,
//            "country": "Guizhou",
//            "country_icon": "http://1.117.70.210:8091/assets/img/Guizhou.png",
//            "city": "Qianxinan Buyi-Miao Autonomous Prefecture",
//            "lan": "中文",
//            "profession": "",
//            "introduction": "每天开开心心",
//            "tags": "",
//            "remark": "",
//            "cal": 0,
//            "heart_rate_min": 0,
//            "heart_rate_max": 0,
//            "duration": 0,
//            "status": 1,
//            "invite_uid": "",
//            "last_login": 1638749737,
//            "last_login_ip": "118.247.85.59",
//            "created_at": 1636854213,
//            "updated_at": 1638749737,
//            "is_accept": 1,
//            "is_creator": true
