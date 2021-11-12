//
//  UserInfo.h
//  fitworld
//
//

#import "BaseObject.h"

@interface PractiseStatic : BaseObject

@property (nonatomic , assign) NSInteger              total;

- (BOOL)isEqualToUserInfo:(PractiseStatic *)practiseStatic;

@end
