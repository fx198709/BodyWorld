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
#import "RightTopSearchView.h"
#import "ScreenModel.h"
#import "ScreenAboveView.h"

#define KStatushight [[UIApplication sharedApplication] statusBarFrame].size.height
#define KNavhight self.navigationController.navigationBar.frame.size.height
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define KSystemHeight  [UIScreen mainScreen].bounds.size.height

@interface CourseMoreController ()
{
    YJPageControlView * pageControlView;
    RightTopSearchView *searchView;
    UIButton *screenBackbutton;
    ScreenAboveView *aboveView;
    NSTimer *timeLimitTimer;
}
@property(nonatomic,strong) NSMutableArray *viewControllers;
@end

@implementation CourseMoreController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    self.viewControllers = [NSMutableArray array];
    NSString *livingString = ChineseStringOrENFun(@"正在进行", @"LIVE");
    NSString *GroupString = ChineseStringOrENFun(@"团课", @"GROUP");
    NSString *BuddyString = ChineseStringOrENFun(@"对练课", @"BUDDY");
    NSString *personString = ChineseStringOrENFun(@"私教", @"PERSON");

    NSArray *titles = @[livingString, GroupString, BuddyString,personString];
    CGRect frame =CGRectMake(0, 0, kScreenWidth, self.view.bounds.size.height-KNavhight-KStatushight);

    for (int i = 0 ; i<titles.count; i++) {
        CourseLiveViewController *vc = [self viewControllerIndex:i];
        vc.viewheight = frame.size.height;
        vc.parentVC = self;
        vc.pageVCindex = i;
        [self.viewControllers addObject:vc];
    }
    
    pageControlView = [[YJPageControlView alloc] initWithFrame:frame Titles:titles viewControllers:self.viewControllers Selectindex:_VCtype];
    [pageControlView showInViewController:self];
    [self reachSearchOption];
    
}
- (void)createRightBtn{
    if (_curse_type_array.count || _curse_time_array.count || _course_language_array.count) {
//        UINavigationBar
        searchView = (RightTopSearchView *)[[[NSBundle mainBundle] loadNibNamed:@"RightTopSearchView" owner:self options:nil] lastObject];
        searchView.frame = CGRectMake(0, 0, 100, 44);
        searchView.backgroundColor = UIColor.clearColor;
        BOOL hasSelected = NO;
        for (ScreenModel *vmodel in _curse_time_array) {
            if (vmodel.hasSelected) {
                hasSelected = YES;
            }
        }
        for (ScreenModel *vmodel in _curse_type_array) {
            if (vmodel.hasSelected) {
                hasSelected = YES;
            }
        }
        for (ScreenModel *vmodel in _course_language_array) {
            if (vmodel.hasSelected) {
                hasSelected = YES;
            }
        }
        if (self.show_join) {
            hasSelected = YES;
        }
        searchView.redView.hidden = !hasSelected;
        [searchView.bottomBtn addTarget:self action:@selector(screenBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:searchView];
        item.width=100;
        item.target = self;
        item.action = @selector(screenBtnClicked);
        self.navigationItem.rightBarButtonItem = item;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

//NSDictionary *dict = @{NSFontAttributeName : SystemFontOfSize(15)};
//// 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
//// 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
//CGSize size =  [inString boundingRectWithSize:CGSizeMake(ScreenWidth *3, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;

- (void)screenBtnClicked{
    screenBackbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    aboveView = [[[NSBundle mainBundle] loadNibNamed:@"ScreenAboveView" owner:self options:nil] lastObject];
    aboveView.frame = CGRectMake(10, (ScreenHeight-520)/2, ScreenWidth-20, 520);
    [screenBackbutton addSubview:aboveView];
    aboveView.backgroundColor = UIColor.whiteColor;
    [aboveView changeData:_curse_time_array andType:_curse_type_array andLanguage:_course_language_array isjoin:self.show_join];
    aboveView.layer.cornerRadius = 10;
    aboveView.clipsToBounds = YES;
    WeakSelf
    aboveView.screenOKClick = ^(NSArray * _Nonnull timeArray, NSArray * _Nonnull typeArray, NSArray * _Nonnull languageArray, BOOL showjoin) {
        StrongSelf(wSelf);
        strongSelf->_show_join = showjoin;
        strongSelf.curse_time_array = timeArray;
        strongSelf.curse_type_array = typeArray;
        strongSelf.course_language_array = languageArray;

        [strongSelf createRightBtn];
        [strongSelf getVCScreenData];
        [strongSelf->screenBackbutton removeFromSuperview];
        strongSelf->screenBackbutton= nil;
        
    };
    UIWindow *keywindow = [CommonTools mainWindow];
    [keywindow addSubview:screenBackbutton];
    [screenBackbutton addTarget:self action:@selector(screenBackbuttonClicked) forControlEvents:UIControlEventTouchUpInside];
}

//重新加载页面
- (void)reloadControlsCell{
//    判断当前哪个页面在最上面，重新加载
    if (self.viewControllers && self.viewControllers.count > pageControlView.selectedIndex) {
        CourseLiveViewController *vc = [self.viewControllers objectAtIndex:pageControlView.selectedIndex];
        [vc reloadTabelviewCell];
    }
    
}

- (void)getVCScreenData{
    if (self.viewControllers && self.viewControllers.count > pageControlView.selectedIndex) {
        CourseLiveViewController *vc = [self.viewControllers objectAtIndex:pageControlView.selectedIndex];
        [vc reReahSearchData];
    }
}

//弹层背景消失
- (void)screenBackbuttonClicked{
//    恢复默认值
    NSArray *defaultIds = aboveView.lastSelectedIds;
    for (ScreenModel *vmodel in _curse_type_array) {
        if ([defaultIds containsObject:vmodel.id]) {
            vmodel.hasSelected = YES;
        }else{
            vmodel.hasSelected = NO;
        }
    }
    
    for (ScreenModel *vmodel in _curse_time_array) {
        if ([defaultIds containsObject:vmodel.id]) {
            vmodel.hasSelected = YES;
        }else{
            vmodel.hasSelected = NO;
        }
    }
    for (ScreenModel *vmodel in _course_language_array) {
        if ([defaultIds containsObject:vmodel.id]) {
            vmodel.hasSelected = YES;
        }else{
            vmodel.hasSelected = NO;
        }
    }
    [self createRightBtn];
    [screenBackbutton removeFromSuperview];
    screenBackbutton= nil;
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
            self->_curse_type_array = tempArray;
            tempArray = [NSMutableArray array];
            for (NSDictionary *dic in [dataDic objectForKey:@"course_language"]) {
                ScreenModel *vmodel = [[ScreenModel alloc] initWithJSON:dic];
                [tempArray addObject:vmodel];
            }
            self->_course_language_array = tempArray;
            
            tempArray = [NSMutableArray array];
            for (NSDictionary *dic in [dataDic objectForKey:@"curse_time"]) {
                ScreenModel *vmodel = [[ScreenModel alloc] initWithJSON:dic];
                [tempArray addObject:vmodel];
            }
            self->_curse_time_array = tempArray;
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
    timeLimitTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadControlsCell) userInfo:nil repeats:YES];
}

 

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [timeLimitTimer invalidate];
    timeLimitTimer = nil;
    
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

- (void)reachSeletedValue:(void(^)(NSString*typeSelected,NSString*timeSelected,NSString*languageString))selectedValue{
    NSString *timeString = @"";
    NSString *typeString = @"";
    NSString *languageString = @"";

    if (_curse_time_array) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (ScreenModel *vmodel in _curse_time_array) {
            if (vmodel.hasSelected) {
                [tempArray addObject:vmodel.id];
            }
        }
        timeString = [tempArray componentsJoinedByString:@","];
    }
    if (_curse_type_array) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (ScreenModel *vmodel in _curse_type_array) {
            if (vmodel.hasSelected) {
                [tempArray addObject:vmodel.id];
            }
        }
        typeString = [tempArray componentsJoinedByString:@","];
    }
    if (_course_language_array) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (ScreenModel *vmodel in _course_language_array) {
            if (vmodel.hasSelected) {
                [tempArray addObject:vmodel.id];
            }
        }
        languageString = [tempArray componentsJoinedByString:@","];
    }
    selectedValue(typeString,timeString,languageString);
}


@end
