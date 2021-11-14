//
//  UserCenterGroup.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/14.
//

#import "BaseJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserCenterGroup : BaseJSONModel

@property (nonatomic, strong) NSString *course_type;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int duration;

@end

NS_ASSUME_NONNULL_END
