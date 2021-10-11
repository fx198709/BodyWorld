//
//  VSRoomUser.h
//  VSVideo
//
//  Created by pliu on 21/03/2019.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSRoomUser : NSObject
@property (readonly, strong) NSString* userId;
@property (readonly, strong) NSString* clientId;
@property (readonly, strong) NSString* sessionId;
@property (readonly, strong) NSString* roomId;
@property (readonly, assign) BOOL muted;
@property (readonly, assign) BOOL blind;
@property (readonly, strong) NSString* streamId;
@property (readonly, strong) NSString* secondStreamId;
@property (readonly, strong) NSDictionary *custom;

- (BOOL)hasStream;
- (BOOL)hasSecondStream;
@end

NS_ASSUME_NONNULL_END
