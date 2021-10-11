#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSRoomParam : NSObject
@property (readonly, strong) NSString* mVrcToken;
@property (readonly, strong) NSDictionary* mApplyRet;

@property (readonly, assign) NSInteger mErrCode;
@property (readonly, strong) NSString* mErrMsg;

@property (readonly, strong) NSString* mVrsUrl;
@property (readonly, strong) NSString* mVrxUrl;
@property (readonly, strong) NSString* mVrfUrl;
@property (readonly, strong) NSString* mStatsUrl;
@property (readonly, assign) NSInteger mRoom;
@property (readonly, assign) NSInteger mRoomStatus;
@property (readonly, strong) NSDictionary* mRoomInfo;
@property (readonly, strong) NSDictionary* mSfuData;
@property (readonly, assign) NSInteger mViewerStatus;
@property (readonly, strong) NSString* mViewerUrl;
@property (readonly, strong) NSString* mViewerInternalUrl;

@property (readonly, strong) NSNumber* mTxImAppId;
@property (readonly, strong) NSString* mTxImSecId;
@property (readonly, strong) NSString* mTxImUserSig;
@property (readonly, strong) NSString* mTxTid;
@property (readonly, strong) NSString* mTxAid;

- (id)initWithToken:(NSString*)vrcToken andApplyResult:(NSDictionary*)applyRet;
- (BOOL)parseParam;
@end

NS_ASSUME_NONNULL_END
