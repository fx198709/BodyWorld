//
//  BaseNavViewController.m
//  FFitWorld
//
//  Created by syswin on 2021/10/10.
//

#import "BaseNavViewController.h"
#import "SDImageCache.h"
#import "UIImage+Extension.h"
#import "AppDelegate.h"

@interface BaseNavViewController ()<UIGestureRecognizerDelegate>
@end

@implementation BaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [self leftMenuBarButtonItem];
    self.view.backgroundColor = UIColor.blackColor;
    self.isTapBack = YES;
//    self.navigationController.hidesNavigationBarWhenPush = NO;
    // Do any additional setup after loading the view.
    
    //开启ios右滑返回
    __weak typeof(self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
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
//    默认每个屏 都是竖屏的
    [self forceOrientationPortrait];
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
    self.isTapBack = YES;
    
        
        
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
 
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return self.isTapBack; //YES：允许右滑返回  NO：禁止右滑返回
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

//强制横屏
- (void)forceOrientationLandscape {

    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=YES;
    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //强制翻转屏幕，Home键在右边。
    [[UIDevice currentDevice] setValue:@(UIInterfaceOrientationLandscapeRight) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}

//强制竖屏
- (void)forceOrientationPortrait {

    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isForceLandscape=NO;
     [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
    //设置屏幕的转向为竖屏
    [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
}
@end
