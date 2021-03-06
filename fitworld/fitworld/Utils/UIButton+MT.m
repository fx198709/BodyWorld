//
//  UIButton+MT.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import "UIButton+MT.h"

@implementation UIButton (MT)

#pragma mark - button倒计时
- (void)countdownWithStartTime:(NSInteger)timeLine title:(NSString *)title countDownTitle:(NSString *)subTitle {
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL,0), 1.0 * NSEC_PER_SEC,0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut == 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:title forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:[NSString stringWithFormat:@"%@(%@)", subTitle, IntToString(timeOut)]
                      forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

- (void)stopCountDownTime {
    
}

@end
