#import <Foundation/Foundation.h>

#import "VSRoomParam.h"
#import "ToolFunc.h"

@interface VSRoomParam() {
  
}
@end

@implementation VSRoomParam

@synthesize mVrcToken;
@synthesize mApplyRet;
@synthesize mErrCode;
@synthesize mErrMsg;
@synthesize mVrsUrl;
@synthesize mVrxUrl;
@synthesize mVrfUrl;
@synthesize mStatsUrl;
@synthesize mRoom;
@synthesize mRoomStatus;
@synthesize mRoomInfo;
@synthesize mSfuData;
@synthesize mViewerStatus;
@synthesize mViewerUrl;
@synthesize mViewerInternalUrl;

@synthesize mTxImAppId;
@synthesize mTxImSecId;
@synthesize mTxImUserSig;
@synthesize mTxTid;
@synthesize mTxAid;

- (id)initWithToken:(NSString*)vrcToken andApplyResult:(NSDictionary*)applyRet {
  self = [super init];
  
  mVrcToken = vrcToken;
  mApplyRet = applyRet;
  
  mErrCode = 0;
  mErrMsg = @"";
  
  return self;
}

- (BOOL)parseParam {
  NSInteger retCode = 0;
  NSNumber *tmpNumber = [mApplyRet objectForKey:@"code"];
  retCode = tmpNumber.integerValue;
  if (retCode != 200) {
    mErrMsg = [NSString stringWithFormat:@"Room Apply fail code = %ld", (long)retCode];
    mErrCode = retCode;
    return false;
  }
  NSDictionary *retData = [mApplyRet objectForKey:@"data"];
  if (retData == nil) {
    mErrMsg = @"Room Apply return no data";
    mErrCode = 20011;
    return false;
  }
  
  // additional
  NSDictionary *additionalData = [retData objectForKey:@"additional"];
  if (additionalData == nil) {
    mErrMsg = @"Room Apply return no room additional data";
    mErrCode = 20012;
    return false;
  }
  
  NSDictionary *scheduleConfig = [additionalData objectForKey:@"scheduleConfig"];
  if (scheduleConfig != nil) {
    mVrsUrl = [scheduleConfig objectForKey:@"rtc_vrs_address"];
    mVrxUrl = [scheduleConfig objectForKey:@"rtc_vrx_address"];
    mVrfUrl = [scheduleConfig objectForKey:@"rtc_vsf_address"];
    mStatsUrl = [scheduleConfig objectForKey:@"rtc_stats_address"];
  } else {
    // use default config
  }
  
  // TXIM
  if ([additionalData objectForKey:@"tx_chat_room_aid"] != nil &&
    [additionalData objectForKey:@"tx_chat_room_sid"] != nil &&
    [additionalData objectForKey:@"tx_chat_room_u"] != nil &&
    [additionalData objectForKey:@"tx_chat_room_a2"] != nil &&
    [additionalData objectForKey:@"tx_chat_room_tid"] != nil) {
    mTxImAppId = [additionalData objectForKey:@"tx_chat_room_aid"];
    mTxImSecId = [additionalData objectForKey:@"tx_chat_room_sid"];
    mTxImUserSig = [additionalData objectForKey:@"tx_chat_room_u"];
    mTxTid = [additionalData objectForKey:@"tx_chat_room_aid"];
    mTxAid = [additionalData objectForKey:@"tx_chat_room_a2"];
  }
  
  // custom
  NSString *customData = [retData objectForKey:@"custom"];
  if (customData == nil || customData.length == 0) {
    mErrMsg = @"Room Apply return no room custom data";
    mErrCode = 20013;
    return false;
  }
  mRoomInfo = [ToolFunc dictionaryMessage:customData];
  
  // room
  tmpNumber = [retData objectForKey:@"room"];
  mRoom = tmpNumber.integerValue;
  if (mRoom == 0) {
    mErrMsg = @"Room Apply return room 0";
    mErrCode = 20014;
    return false;
  }
  tmpNumber = [retData objectForKey:@"room_status"];
  mRoomStatus = tmpNumber.integerValue;
  
  // sfuData
  mSfuData = [retData objectForKey:@"sfuData"];
  if (mSfuData == nil) {
    mErrMsg = @"Room Apply return no sfu data";
    mErrCode = 20015;
    return false;
  }
  
  // viewer
  tmpNumber = [retData objectForKey:@"viewer_status"];
  mViewerStatus = tmpNumber.integerValue;
  mViewerUrl = [retData objectForKey:@"viewer_url"];
  mViewerInternalUrl = [retData objectForKey:@"viewer_internal_url"];
  return TRUE;
}

@end
