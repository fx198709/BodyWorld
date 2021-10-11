//
//  TrainingStartViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/8/6.
//

#import "TrainingStartViewController.h"
#import "UIDeps.h"
#import "TrainingInviteViewController.h"
#import "TrainingViewController.h"
#import "UIDeps.h"
#import "AFNetworking.h"
#import "FITAPI.h"
#import <math.h>

@interface TrainingStartViewController ()
@property(nonatomic,strong) NSString *courseId;
@end

@implementation TrainingStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];

    UIImageView *topFlowImg = [[UIImageView alloc] init];
    topFlowImg.image = [UIImage imageNamed:@"buddy_flow2"];
    [self.view addSubview:topFlowImg];
    [topFlowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(53);
    }];
        
    UIButton *startNowBtn = [[UIButton alloc] init];
    startNowBtn.backgroundColor = [UIColor colorWithRed:73.0/255.0 green:146.0/255.0 blue:96.0/255.0 alpha:1];
    [startNowBtn.layer setMasksToBounds:YES];
    [startNowBtn.layer setCornerRadius:10];
    [startNowBtn setTitle:@"Start now" forState:UIControlStateNormal];
    [self.view addSubview:startNowBtn];
    [startNowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topFlowImg.mas_bottom).offset(50);
        make.left.equalTo(topFlowImg);
        make.right.equalTo(topFlowImg);
        make.height.mas_equalTo(50);
    }];
    [startNowBtn addTarget:self action:@selector(startNow) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *start10MinBtn = [[UIButton alloc] init];
    start10MinBtn.backgroundColor = [UIColor colorWithRed:73.0/255.0 green:146.0/255.0 blue:96.0/255.0 alpha:1];
    [start10MinBtn.layer setMasksToBounds:YES];
    [start10MinBtn.layer setCornerRadius:10];
    [start10MinBtn setTitle:@"In 10 min" forState:UIControlStateNormal];
    [self.view addSubview:start10MinBtn];
    [start10MinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startNowBtn.mas_bottom).offset(30);
        make.left.equalTo(startNowBtn);
        make.right.equalTo(startNowBtn);
        make.height.mas_equalTo(50);
    }];
    [start10MinBtn addTarget:self action:@selector(startNow) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *start30MinBtn = [[UIButton alloc] init];
    start30MinBtn.backgroundColor = [UIColor colorWithRed:73.0/255.0 green:146.0/255.0 blue:96.0/255.0 alpha:1];
    [start30MinBtn.layer setMasksToBounds:YES];
    [start30MinBtn.layer setCornerRadius:10];
    [start30MinBtn setTitle:@"In 30 min" forState:UIControlStateNormal];
    [self.view addSubview:start30MinBtn];
    [start30MinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(start10MinBtn.mas_bottom).offset(30);
        make.left.equalTo(startNowBtn);
        make.right.equalTo(startNowBtn);
        make.height.mas_equalTo(50);
    }];
    [start30MinBtn addTarget:self action:@selector(startNow) forControlEvents:UIControlEventTouchUpInside];
        
    UIButton *start60MinBtn = [[UIButton alloc] init];
    start60MinBtn.backgroundColor = [UIColor colorWithRed:73.0/255.0 green:146.0/255.0 blue:96.0/255.0 alpha:1];
    [start60MinBtn.layer setMasksToBounds:YES];
    [start60MinBtn.layer setCornerRadius:10];
    [start60MinBtn setTitle:@"In 60 min" forState:UIControlStateNormal];
    [self.view addSubview:start60MinBtn];
    [start60MinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(start30MinBtn.mas_bottom).offset(30);
        make.left.equalTo(startNowBtn);
        make.right.equalTo(startNowBtn);
        make.height.mas_equalTo(50);
    }];
    [start60MinBtn addTarget:self action:@selector(startNow) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)startNow{
    NSLog(@"startNow ----");

    TrainingInviteViewController *vc = [[TrainingInviteViewController alloc] init];
    vc.selectCourse = self.selectCourse;
    [self.navigationController pushViewController:vc animated:YES];

}

@end
