#import <Foundation/Foundation.h>

#import "VSRoomParam.h"

@class VSRoomLoader;
@protocol VSRoomLoaderObserver <NSObject>
- (void)OnRoomLoadSuccess:(VSRoomParam*)param;
- (void)OnRoomLoadFailed:(NSInteger)errCode andDesc:(NSString*)errStr;
- (void)OnRoomEventInfoFetched:(NSString*)info;
@end

@interface VSRoomLoader : NSObject
@property (readonly, strong) NSString* mApiKey;
@property (readonly, strong) NSString* mVrcUrl;
@property (readonly, strong) NSString* mTenantId;
@property (readonly, strong) NSString* mEventId;
@property (readonly, strong) NSDictionary* mRoomInfo;

- (id)initWithEntry:(NSString*)vrcUrl andEventId:(NSString*)eventId andRoomInfo:(NSDictionary*)roomInfo andObserver:(id<VSRoomLoaderObserver>)observer;
- (void)startLoad;

- (void)requestRoomEventInfo;

@end

