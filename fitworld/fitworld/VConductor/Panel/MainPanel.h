//
//  MainPanel.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPanel : UIView

- (id)init;

- (void)attachLocalView;
- (void)detachLocalView;

- (void)setLectureLayout:(BOOL)isLecture;
- (void)syncRemoteView;

@property (copy) void(^viewDoubleTapped)(void);

@end
