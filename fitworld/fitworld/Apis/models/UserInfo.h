//
//  UserInfo.h
//  fitworld
//
//  Created by 李萍 on 15/12/14.
//  Copyright © 2015年 chenhaoxiang. All rights reserved.
//

#import "BaseObject.h"

@interface UserInfo : BaseObject

@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * birthday;
@property (nonatomic , assign) NSInteger              cal;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic , copy) NSString              * created_at;
@property (nonatomic , assign) NSInteger              duration;
@property (nonatomic , assign) NSInteger              gender;
@property (nonatomic , assign) NSInteger              heart_rate_max;
@property (nonatomic , assign) NSInteger              heart_rate_min;
@property (nonatomic , assign) NSInteger              height;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * introduction;
@property (nonatomic , copy) NSString              * last_login;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * profession;
@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , assign) NSInteger              status;
@property (nonatomic , strong) NSArray <NSString *>              * tags;
@property (nonatomic , copy) NSString              * updated_at;
@property (nonatomic , copy) NSString              * username;
@property (nonatomic , assign) NSInteger              weight;
@property (nonatomic , strong) NSString*              msg;
@property (nonatomic , strong) NSString*              msg_cn;

@property (nonatomic , assign) BOOL              hasSelect;


- (BOOL)isEqualToUserInfo:(UserInfo *)userInfo;

@end
