//
//  MTHUD.m
//  ZhongCaiHuaXiaCRM_iOS
//
//  Created by xiejc on 2019/2/12.
//  Copyright © 2019 xiejc. All rights reserved.
//

#import "MTHUD.h"
#import "UIView+MT.h"
#import "UIColor+MT.h"


#define MTHUDShowDuration 0.25
#define MTHUDHideDuration 0.2
#define MTHUDDisplayDuration 1.2

@interface MTHUD ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation MTHUD

+ (instancetype)instance {
    static MTHUD *hudView = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        hudView = [[MTHUD alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    });
    return hudView;
}

+ (void)showDurationNoticeHUD:(NSString *)message {
    [self showDurationNoticeHUD:message animated:YES completedBlock:nil];
}

+ (void)showDurationNoticeHUD:(NSString *)message animated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock {
    [self hideHUD];
    MTHUD *hudView = [MTHUD instance];
    [hudView refreshUpDownView:message];
    [hudView showWithAnimated:animated completedBlock:completedBlock];
}

+ (void)showLoadingHUD {
    MTHUD *hudView = [MTHUD instance];
    [hudView refreshLoadingCenterView];
    [hudView showWithAnimated:NO completedBlock:nil];
}

+ (void)hideHUD {
    [self hideHUD:NO completedBlock:nil];
}

+ (void)hideHUD:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock {
    MTHUD *hudView = [MTHUD instance];
    [hudView hideAnimated:animated completedBlock:completedBlock];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.containerView = [[UIView alloc] init];
        self.containerView.backgroundColor = [[UIColor darkGrayColor] colorWithAlpha:0.9];
        [self.containerView cornerWithRadius:3.0 borderColor:nil];
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(186);
            make.height.mas_equalTo(96);
            make.center.mas_equalTo(self);
        }];
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.font = SystemFontOfSize(14.0);
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 0;
        [self.containerView addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.backgroundColor = [UIColor clearColor];
        [self.containerView addSubview:self.activityIndicator];
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.containerView);
        }];
    }
    return self;
}

- (void)showWithAnimated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock {
    self.alpha = 0.0;
    [self removeFromSuperview];
    [self.currentWindow addSubview:self];
    if (animated) {
        [UIView animateWithDuration:MTHUDShowDuration animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self hideAnimated:animated completedBlock:completedBlock];
        }];
    } else {
        self.alpha = 1.0;
    }
}

- (void)hideAnimated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock {
    if (animated) {
        [UIView animateWithDuration:MTHUDHideDuration delay:MTHUDDisplayDuration options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self hideAnimated:NO completedBlock:completedBlock];
        }];
    } else {
        [self removeFromSuperview];
        [self resetView];
        if (completedBlock) {
            completedBlock();
        }
    }
}


/**
 重置页面
 */
- (void)resetView {
    [self removeFromSuperview];
    self.messageLabel.text = nil;
    [self.activityIndicator stopAnimating];
}

/**
加载中结构
 */
- (void)refreshLoadingCenterView {
    self.activityIndicator.hidden = NO;
    self.messageLabel.hidden = YES;
    [self.activityIndicator startAnimating];
}


/**
 上图下文结构的弹出窗口

 @param message 信息
 */
- (void)refreshUpDownView:(NSString *)message {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;

    self.messageLabel.hidden = NO;
    self.messageLabel.text = message;
}

/**
 *  获取window
 */
- (UIWindow *)currentWindow {
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows)
        if (window.windowLevel == UIWindowLevelNormal) {
            return window;
            break;
        }
    return nil;
}


- (CGFloat)getMessageWidth:(NSString *)text {
    NSDictionary *attrs = @{NSFontAttributeName: self.messageLabel.font};
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
    return width;
}

@end
