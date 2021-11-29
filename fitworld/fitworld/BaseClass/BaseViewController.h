//
//  BaseViewController.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import <UIKit/UIKit.h>

typedef void (^BaseCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : BaseNavViewController

#pragma mark - 弹窗提示

- (void)showChangeFailedError:(NSError *)error;

- (void)showSuccessNoticeAndPopVC;




@end

NS_ASSUME_NONNULL_END
