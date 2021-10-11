//
//  ClassRoom.h
//  VConductor
//
//  Created by pliu on 20210129.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

#import "ClassMember.h"

typedef NS_ENUM(NSInteger, PlayoutLayoutMode) {
  PLAYOUT_LAYOUT_GRID,
  PLAYOUT_LAYOUT_LECTURE,
};

@interface ClassRoom : NSObject

- (id)initWith:(NSDictionary*)info andAddition:(NSDictionary*)addition;
- (void)fillEventInfo:(NSString*)data;
- (void)syncInfo:(NSDictionary*)info;
- (PlayoutLayoutMode)playoutLayout;
- (BOOL)isMemeberAllowShare:(NSString*)userId;
- (BOOL)supportLive;
- (NSString*)roomTitle;
- (NSString*)liveUrl;
- (NSInteger)elapsedSeconds;
@end

