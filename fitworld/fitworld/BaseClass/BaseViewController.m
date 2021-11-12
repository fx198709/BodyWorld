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

- (void)showChangeFailedError:(NSError *)error {
    NSString *msg = error == nil ? ChangeErrorMsg : error.localizedDescription;
    [MTHUD showDurationNoticeHUD:msg];
}

- (void)showSuccessNoticeAndPopVC {
    [MTHUD showDurationNoticeHUD:ChangeSuccessMsg animated:YES completedBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
