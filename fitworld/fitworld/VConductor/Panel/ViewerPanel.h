//
//  ViewerPanel.h
//
//  Created by pliu on 20210202.
//  Copyright © 2021 VSVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewerPanel : UIView

- (id)init;

- (void)startPlay:(NSString*)url;
- (void)stopPlay;

@end
