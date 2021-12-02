//
//  CoachComment.h
//  FFitWorld
//
//  Created by xiejc on 2021/12/2.
//

#import "BaseJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoachComment : BaseJSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *obj_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger grade;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *ip;
@property (nonatomic, assign) NSInteger created_at;
@property (nonatomic, assign) NSInteger updated_at;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country_icon;
@property (nonatomic, assign) BOOL is_favorite;
@property (nonatomic, assign) NSInteger favorite_cnt;


/*
 "id": "48542032200731140",
             "obj_id": "44768959819483652",
             "type": "coach",
             "content": "这个教练还行",
             "grade": 0,
             "userid": "37092822804859396",
             "ip": "111.196.59.111",
             "created_at": 1638363705,
             "updated_at": 1638363705,
             "avatar": "/upload/user/avatar/377563530221586948.jpeg",
             "nickname": "姚毅123",
             "country": "中国",
             "city": "保定",
             "country_icon": "http://1.117.70.210:8091/assets/img/中国.png",
             "is_favorite": 0,
             "favorite_cnt": 10
 */

@end

NS_ASSUME_NONNULL_END
