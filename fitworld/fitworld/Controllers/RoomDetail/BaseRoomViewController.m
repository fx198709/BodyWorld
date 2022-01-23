//
//  BaseRoomViewController.m
//  FFitWorld
//
//  Created by feixiang on 2022/1/23.
//

#import "BaseRoomViewController.h"

@interface BaseRoomViewController ()

@end

@implementation BaseRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.needChangeOrientation) {
        [self performSelector:@selector(changeOrientation) withObject:nil afterDelay:0.5];
    }
}

- (void)changeOrientation{
    
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
