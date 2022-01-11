//
//  MainPanel.h
//
//  Created by pliu on 20210129.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPanel : UIView

- (id)init;

//创建一个占位图
- (void)createPlaceImageView;

//修改背景图
- (void)changePlaceImage:(UIInterfaceOrientation)orientation;


- (void)attachLocalView;
- (void)detachLocalView;

- (void)setLectureLayout:(BOOL)isLecture;
- (void)syncRemoteView;

@property (copy) void(^viewDoubleTapped)(void);

@end
