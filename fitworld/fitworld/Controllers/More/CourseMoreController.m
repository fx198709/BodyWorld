//
//  YJDemo.m
//  YJPageController
//
//  Created by 于英杰 on 2019/4/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "CourseMoreController.h"
#import "YJPageControlView.h"
#import "CourseLiveViewController.h"

#define KStatushight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavhight self.navigationController.navigationBar.frame.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KSystemHeight  [UIScreen mainScreen].bounds.size.height

@interface CourseMoreController ()
{
    YJPageControlView * PageControlView;
}
@property(nonatomic,strong) NSMutableArray *viewControllers;
@end

@implementation CourseMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    self.viewControllers = [NSMutableArray array];
    
    NSArray *titles = @[@"Live", @"Group", @"Buddy"];
    CGRect frame =CGRectMake(0, 0, kScreenWidth, self.view.bounds.size.height-KNavhight-KStatushight);

    for (int i = 0 ; i<titles.count; i++) {
        CourseLiveViewController *vc = [self viewControllerIndex:i];
        vc.viewheight = frame.size.height;
        [self.viewControllers addObject:vc];
    }
    
    PageControlView = [[YJPageControlView alloc] initWithFrame:frame Titles:titles viewControllers:self.viewControllers Selectindex:0];
    [PageControlView showInViewController:self];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (CourseLiveViewController *)viewControllerIndex:(NSInteger)index {
    CourseLiveViewController *vc = [[CourseLiveViewController alloc] init];
    vc.pageVCindex = index;
    return vc;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
