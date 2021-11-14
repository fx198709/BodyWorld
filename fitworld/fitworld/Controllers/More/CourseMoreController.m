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
#import "BaseJSONModel.h"


#define KStatushight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavhight self.navigationController.navigationBar.frame.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KSystemHeight  [UIScreen mainScreen].bounds.size.height

@interface ScreenModel:BaseJSONModel
 
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) BOOL    hasSelected;


@end

@implementation ScreenModel
- (instancetype)initWithJSON:(NSDictionary *)json
{
    NSError *error;

    if (self = [[ScreenModel alloc] initWithDictionary:json error:&error]) {
        _hasSelected = NO;
    }
    return self;
}

@end

@interface CourseMoreController ()
{
    YJPageControlView * PageControlView;
    NSArray *curse_type_array;
    NSArray *curse_time_array;

}
@property(nonatomic,strong) NSMutableArray *viewControllers;
@end

@implementation CourseMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    self.viewControllers = [NSMutableArray array];
    NSString *livingString = ChineseStringOrENFun(@"正在进行", @"Live");
    NSString *GroupString = ChineseStringOrENFun(@"团课", @"Group");
    NSString *BuddyString = ChineseStringOrENFun(@"对练课", @"Buddy");

    NSArray *titles = @[livingString, GroupString, BuddyString];
    CGRect frame =CGRectMake(0, 0, kScreenWidth, self.view.bounds.size.height-KNavhight-KStatushight);

    for (int i = 0 ; i<titles.count; i++) {
        CourseLiveViewController *vc = [self viewControllerIndex:i];
        vc.viewheight = frame.size.height;
        [self.viewControllers addObject:vc];
    }
    
    PageControlView = [[YJPageControlView alloc] initWithFrame:frame Titles:titles viewControllers:self.viewControllers Selectindex:0];
    [PageControlView showInViewController:self];
    
}
- (void)createRightBtn{
    if (curse_type_array.count || curse_time_array.count) {
//        UINavigationBar
        NSString *searchString = ChineseStringOrENFun(@"搜索", @"Search");
        UIButton *searchView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        UIImageView *searchImage = [[UIImageView alloc] ]
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchView];
        
        self.navigationItem.rightBarButtonItem = item;
        
    }
}


- (void)reachSearchOption{
//    room/search_opt
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *baddyParams = @{};
    [[AFAppNetAPIClient manager] GET:@"room/search_opt" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (CheckResponseObject(responseObject)) {
            NSDictionary *dataDic = responseObject[@"recordset"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dic in [dataDic objectForKey:@"curse_type"]) {
                ScreenModel *vmodel = [[ScreenModel alloc] initWithJSON:dic];
                [tempArray addObject:vmodel];
            }
            self->curse_type_array = tempArray;
            tempArray = [NSMutableArray array];
            for (NSDictionary *dic in [dataDic objectForKey:@"curse_time"]) {
                ScreenModel *vmodel = [[ScreenModel alloc] initWithJSON:dic];
                [tempArray addObject:vmodel];
            }
            self->curse_time_array = tempArray;
            [self createRightBtn];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
//    创建一个右上角的searchBtn
    [self createRightBtn];
    
   
    
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
