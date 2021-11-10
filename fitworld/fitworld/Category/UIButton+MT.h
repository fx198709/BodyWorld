//
//  UIButton+MT.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (MT)

//button倒计时
- (void)countdownWithStartTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle;

@end

NS_ASSUME_NONNULL_END
