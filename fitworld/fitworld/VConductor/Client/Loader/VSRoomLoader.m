#import "VSRoomLoader.h"
#import "VSHttpClient.h"
#import "ToolFunc.h"
//#import <WebRTC/RTCLogging.h>
#define RTCLogError NSLog

@interface VSRoomLoader() {
  
}
@property (nonatomic, weak) id<VSRoomLoaderObserver> mObserver;
@property (readonly, strong) NSString* mPreVrcToken;
@property (readonly, strong) NSString* mVrcToken;
@end

@implementation VSRoomLoader

@synthesize mPreVrcToken;
@synthesize mVrcToken;
@synthesize mApiKey;
@synthesize mVrcUrl;
@synthesize mTenantId;
@synthesize mEventId;
@synthesize mRoomInfo;
@synthesize mObserver;

- (id)initWithEntry:(NSString*)vrcUrl andEventId:(NSString*)eventId andRoomInfo:(NSDictionary*)roomInfo andObserver:(id<VSRoomLoaderObserver>)observer {
  self = [super init];
  mApiKey = @"o9d9fjewlsdhioiqwjioeeijlkjwlr9c";
  
  mPreVrcToken = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MjMzOTI5MzQsInRva2VuIjoiZjllNGRjNGItMGRiYy00ZTUyLTgxYjItNmEyNmVkOWEzMjlhIn0.GB6CuG6MmT-3a8uJxgIhfhOa4hvG-FxD8ybi1ZuRj4U";
  mVrcUrl = vrcUrl;
  mEventId = eventId;
  mRoomInfo = roomInfo;
  
  mObserver = observer;
  
  return self;
}

- (void)startLoad {
  NSString *queryTenantUrl = [NSString stringWithFormat:@"%@/rms/v1/room/%@/noTenant", mVrcUrl, mEventId];
  NSDictionary *queryTenantHeader = @{@"Authorization" : mPreVrcToken};
  [VSHttpClient sendRequestWithUrl:queryTenantUrl andMethod:@"GET" andHeaders:queryTenantHeader andPayload:nil andCallback:^(BOOL succeed, NSString *response, NSError *error) {
    if (!succeed) {
      RTCLogError(@"Received bad response: %@", response);
      dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.mObserver OnRoomLoadFailed:error.code andDesc:error.localizedDescription];
      });
      return;
    }
    [self queryTenantApply:response];
  }];
}

- (void)queryTenantApply:(NSString*)queryResponse {
  NSDictionary *queryTenantRet = [ToolFunc dictionaryMessage:queryResponse];
  NSNumber *retCode = [queryTenantRet objectForKey:@"code"];
  NSDictionary *entryData = [queryTenantRet objectForKey:@"data"];
  if (retCode.integerValue != 200 || ([entryData objectForKey:@"tenant_id"] == nil)) {
    RTCLogError(@"Received bad response: %@", queryResponse);
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [self.mObserver OnRoomLoadFailed:retCode.integerValue andDesc:queryResponse];
    });
    return;
  }
  mTenantId = [entryData objectForKey:@"tenant_id"];
  
  NSString *loginUrl = [mVrcUrl stringByAppendingString:@"/rms/v1/authentication"];
  NSDictionary *loginParam = @{@"apikey" : mApiKey, @"tenant_id" : mTenantId};
  [VSHttpClient sendRequestWithUrl:loginUrl andMethod:@"POST" andHeaders:nil andPayload:loginParam andCallback:^(BOOL succeed, NSString *response, NSError *error) {
    if (!succeed) {
      RTCLogError(@"Received bad response: %@", response);
      dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.mObserver OnRoomLoadFailed:error.code andDesc:error.localizedDescription];
      });
      return;
    }
    [self requestApply:response];
  }];
}

- (void)requestApply:(NSString*)authResponse {
  NSDictionary *authRet = [ToolFunc dictionaryMessage:authResponse];
  NSNumber *retCode = [authRet objectForKey:@"code"];
  if (retCode.integerValue != 200) {
    RTCLogError(@"Received bad response: %@", authResponse);
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [self.mObserver OnRoomLoadFailed:retCode.integerValue andDesc:authResponse];
    });
    return;
  }
  mVrcToken = [authRet objectForKey:@"data"];
  
  NSString *applyUrl = [NSString stringWithFormat:@"%@/rms/v1/room/%@/apply", mVrcUrl, mEventId];
  NSDictionary *applyHeader = @{@"Authorization" : mVrcToken};
  NSDictionary *applyParam = @{@"tenant_id" : mTenantId, @"custom" : mRoomInfo};
  
  [VSHttpClient sendRequestWithUrl:applyUrl andMethod:@"POST" andHeaders:applyHeader andPayload:applyParam andCallback:^(BOOL succeed, NSString *response, NSError *error) {
    if (!succeed) {
      RTCLogError(@"Received bad response: %@", response);
      dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self.mObserver OnRoomLoadFailed:error.code andDesc:error.localizedDescription];
      });
      return;
    }
    [self applyResponseParse:response];
  }];
}

- (void)applyResponseParse:(NSString*)applyResponse {
  NSDictionary *applyRet = [ToolFunc dictionaryMessage:applyResponse];
  NSNumber *retCode = [applyRet objectForKey:@"code"];
  if (retCode.integerValue != 200) {
    RTCLogError(@"Received bad response: %@", applyResponse);
    NSString *errMsg = [applyRet objectForKey:@"message"];
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [self.mObserver OnRoomLoadFailed:retCode.integerValue andDesc:errMsg];
    });
    return;
  }
  VSRoomParam *roomParam = [[VSRoomParam alloc] initWithToken:mVrcToken andApplyResult:applyRet];
  if ([roomParam parseParam]) {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [self.mObserver OnRoomLoadSuccess:roomParam];
    });
  } else {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [self.mObserver OnRoomLoadFailed:20001 andDesc:@"VRC apply response error"];
    });
  }
}

- (void)requestRoomEventInfo {
  NSString *getUrl = [NSString stringWithFormat:@"%@/rms/v1/room/%@?tenant_id=%@", mVrcUrl, mEventId, mTenantId];
  NSDictionary *getHeader = @{@"Authorization" : mVrcToken};
  
  [VSHttpClient sendRequestWithUrl:getUrl andMethod:@"GET" andHeaders:getHeader andPayload:nil andCallback:^(BOOL succeed, NSString *response, NSError *error) {
    if (!succeed) {
      RTCLogError(@"requestRoomEventInfo received bad response: %@", response);
      return;
    }
    dispatch_async(dispatch_get_main_queue(), ^(void) {
      [self.mObserver OnRoomEventInfoFetched:response];
    });
  }];
}

@end
