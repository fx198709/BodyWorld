//
//  UserCenterInfo.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/14.
//

#import "BaseJSONModel.h"
#import "UserInfo.h"
#import "UserCenterWeekData.h"
#import "UserCenterGroup.h"

@protocol NSNumber;

@interface UserCenterInfo : BaseJSONModel

@property (nonatomic, strong) UserCenterWeekData *week_data;
@property (nonatomic, strong) UserInfo *user_info;
@property (nonatomic, strong) UserCenterGroup *buddy;
@property (nonatomic, strong) UserCenterGroup *group;
@property (nonatomic, strong) NSArray<NSNumber> *day_of_month;
@property (nonatomic, assign) int total;

@end
