//
//  CoachModel.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/7.
//

#import "CoachModel.h"

@implementation CoachModel
- (instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        
        _course_id =  NSStringFromDic(json, @"course_id", @"");
//LongValueFromDic(json, @"created_at", 0);;
        self.username = NSStringFromDic(json, @"username", @"");
        self.nickname = NSStringFromDic(json, @"nickname", @"");
        self.gender = LongValueFromDic(json, @"gender", 0);
        self.genderString = SexNameFormGender(self.gender);
        self.avatar = NSStringFromDic(json, @"avatar", @"");
        self.mobile = NSStringFromDic(json, @"mobile", @"");
        self.country = NSStringFromDic(json, @"country", @"");
        self.city = NSStringFromDic(json, @"city", @"");
        self.teach = NSStringFromDic(json, @"teach", @"");
        self.status = LongValueFromDic(json, @"status", 0);
        self.remark = NSStringFromDic(json, @"remark", @"");
        self.last_login = NSStringFromDic(json, @"last_login", @"");
        self.created_at = NSStringFromDic(json, @"created_at", @"");
        self.updated_at = NSStringFromDic(json, @"updated_at", @"");

        
    }
    return self;
}


- (void)dealData {
    self.country_icon = [self.country_icon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}



@end
/*
 @property (nonatomic , copy) NSString              * course_id;
 @property (nonatomic , copy) NSString              * username;
 @property (nonatomic , copy) NSString              * nickname;
 @property (nonatomic , copy) NSString              * gender;
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
 */
