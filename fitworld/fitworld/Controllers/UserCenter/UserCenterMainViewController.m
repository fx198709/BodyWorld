//
//  UserCenterMainViewController.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/6.
//

#import "UserCenterMainViewController.h"

@interface UserCenterMainViewController ()

@end

@implementation UserCenterMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _headimagebackview.layer.cornerRadius = 50;
    _headimagebackview.clipsToBounds = YES;
    _userimageview.layer.cornerRadius = 47;
    _userimageview.clipsToBounds = YES;
    // Do any additional setup after loading the view from its nib.
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
