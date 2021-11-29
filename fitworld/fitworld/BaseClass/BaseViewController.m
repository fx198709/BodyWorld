//
//  BaseViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
        
    self.view.backgroundColor = UIColor.blackColor;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 弹窗提示

- (void)showChangeFailedError:(NSError *)error {
    NSString *msg = error == nil ? ChangeErrorMsg : error.localizedDescription;
    [MTHUD showDurationNoticeHUD:msg];
}

- (void)showSuccessNoticeAndPopVC {
    [MTHUD showDurationNoticeHUD:ChangeSuccessMsg animated:YES completedBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}


@end
