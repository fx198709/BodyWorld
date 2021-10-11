//
//  RemoteView.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteView : UIView
- (id)initWithUserId:(NSString*)uId forMainVideo:(BOOL)main;
- (NSString*)userId;
- (void)bindMedia;
- (void)unbindMedia;
@end
