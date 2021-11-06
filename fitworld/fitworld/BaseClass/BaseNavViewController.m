//
//  BaseNavViewController.m
//  FFitWorld
//
//  Created by syswin on 2021/10/10.
//

#import "BaseNavViewController.h"
#import "SDImageCache.h"
#import "UIImage+Extension.h"

@interface BaseNavViewController ()

@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    self.view.backgroundColor = UIColor.blackColor;
//    self.navigationController.hidesNavigationBarWhenPush = NO;
    // Do any additional setup after loading the view.
}

//- (UIViewController *)childViewControllerForStatusBarStyle {
//    return self.topViewController;
//}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    清除右侧的导航
    self.navigationItem.rightBarButtonItem = nil;
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    //开启ios右滑返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@ didReceiveMemoryWarning",[self class]);
//    [[SDImageCache sharedImageCache] clearMemory];
//    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear %@",NSStringFromClass(self.class));
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    这个页面消失的时候，所有的键盘都消失
    [self.view endEditing:YES];
}


//设置导航栏左边按钮
- (UIBarButtonItem *)leftMenuBarButtonItem {
    return [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_white" renderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backPopViewcontroller:)];
}

- (void)backPopViewcontroller:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
