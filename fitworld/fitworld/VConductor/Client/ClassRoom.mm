#import <Foundation/Foundation.h>

#import "ClassRoom.h"
#import "VConductorClient.h"
#import "ToolFunc.h"

@interface ClassRoom() {
  
}
@property (nonatomic, strong) NSDictionary* mEventInfo;
@property (nonatomic, strong) NSDictionary* mRoomInfo;
@property (nonatomic, strong) NSDictionary* mRoomAddition;

@property (nonatomic, assign) NSInteger mBaseSec;
@property (nonatomic, assign) NSInteger mBaseTm;
@end

@implementation ClassRoom

@synthesize mEventInfo;
@synthesize mRoomInfo;
@synthesize mRoomAddition;
@synthesize mBaseSec;
@synthesize mBaseTm;

- (id)initWith:(NSDictionary*)info andAddition:(NSDictionary*)addition {
  self = [super init];
  mRoomInfo = info;
  mRoomAddition = addition;
  
  NSNumber *startTime = [mRoomAddition objectForKey:@"startTime"];
  mBaseSec = startTime.integerValue;
  mBaseTm = [[NSDate date] timeIntervalSince1970];
  
  return self;
}

- (void)fillEventInfo:(NSString*)data {
  mEventInfo = [[ToolFunc dictionaryMessage:data] objectForKey:@"data"];
}

- (void)syncInfo:(NSDictionary*)info {
  mRoomInfo = info;
}

- (PlayoutLayoutMode)playoutLayout {
  if (mRoomInfo == nil || [mRoomInfo objectForKey:@"playout_layout_type"] == nil) {
    return PLAYOUT_LAYOUT_GRID;
  }
  NSString *playoutTemplate = [mRoomInfo objectForKey:@"playout_layout_type"];
  if ([playoutTemplate isEqualToString:@"grid"]) {
    return PLAYOUT_LAYOUT_GRID;
  } else if ([playoutTemplate isEqualToString:@"lecture"]) {
    return PLAYOUT_LAYOUT_LECTURE;
  }
  return PLAYOUT_LAYOUT_GRID;
}

- (BOOL)isMemeberAllowShare:(NSString*)userId {
  if (mRoomInfo == nil || [mRoomInfo objectForKey:@"lecture_user"] == nil) {
    return NO;
  }
  
  BOOL allowShare = NO;
  NSDictionary *lecUsers = [mRoomInfo objectForKey:@"lecture_user"];
  for (NSString *uId in lecUsers.allKeys) {
    if ([uId isEqualToString:userId]) {
      allowShare = YES;
      break;
    }
  }
  
  return allowShare;
}

- (BOOL)supportLive {
  if (mRoomAddition == nil) {
    return NO;
  }
  NSNumber *hasLive = [mRoomAddition objectForKey:@"viewer_status"];
  return (hasLive != nil) ? (hasLive.intValue == 1) : NO;
}

- (NSString*)roomTitle {
  if (mEventInfo == nil || [mEventInfo objectForKey:@"title"] == nil) {
    return @"";
  }
  NSString* roomTitle = [mEventInfo objectForKey:@"title"];
  return roomTitle;
}

- (NSString*)liveUrl {
  if (![self supportLive]) {
    return @"";
  }
  NSString *liveUrl = [mRoomAddition objectForKey:@"viewer_url"];
  return (liveUrl != nil) ? liveUrl : @"";
}

- (NSInteger)elapsedSeconds {
  double secondsAfterBase = [[NSDate date] timeIntervalSince1970] - mBaseTm;
  double elapsedTm = mBaseSec + secondsAfterBase;
  return elapsedTm;
}

@end
