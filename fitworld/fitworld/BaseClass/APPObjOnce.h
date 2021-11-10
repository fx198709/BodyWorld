//
//  APPObjOnce.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/10.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface APPObjOnce : NSObject
@property (nonatomic, strong) UserInfo *currentUser;
+ (instancetype)sharedAppOnce;
@end

NS_ASSUME_NONNULL_END
