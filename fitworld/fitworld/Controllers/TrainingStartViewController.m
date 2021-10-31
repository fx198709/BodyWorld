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
#import "SelectClassHeadview.h"
#import "TableHeadview.h"
#import "UIImage+Extension.h"


#define LitterGrayColor UIRGBColor(69, 69, 69, 1)
@interface TrainingStartViewController ()
@property(nonatomic,strong) NSString *courseId;
@end

@implementation TrainingStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ChineseStringOrENFun(@"设置开始时间", @"SET THE START TIME OF SPARRING");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];

    SelectClassHeadview *topFlowImg = (SelectClassHeadview *)[[[NSBundle mainBundle] loadNibNamed:@"SelectClassHeadview" owner:self options:nil] lastObject];
    [self.view addSubview:topFlowImg];
    [topFlowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(80);
    }];
    [topFlowImg changeStep:2];
    TableHeadview *tableheadview = (TableHeadview *)[[[NSBundle mainBundle] loadNibNamed:@"TableHeadview" owner:self options:nil] lastObject];
    [self.view addSubview:tableheadview];
    [tableheadview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topFlowImg.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
    }];
    tableheadview.clipsToBounds = YES;
    
    UIView *grayBackview = [[UIView alloc] init];
    [self.view addSubview:grayBackview];
    grayBackview.backgroundColor = UIRGBColor(37, 37, 37, 1);
    [grayBackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableheadview.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view);
    }];
    
    NSString * string1 = ChineseStringOrENFun(@"5分钟后", @"After 5 min");
    NSString * string2 = ChineseStringOrENFun(@"15分钟后", @"After 15 min");
    NSString * string3 = ChineseStringOrENFun(@"30分钟后", @"After 30 min");
    NSString * string4 = ChineseStringOrENFun(@"自定义时间", @"Customer Time");
    NSArray *stringArray = @[string1,string2,string3,string4];
    UIImage *grayimage = [UIImage imageWithColor:LitterGrayColor];
    UIImage *selectimage = [UIImage imageWithColor:[UIColor colorWithRed:73.0/255.0 green:146.0/255.0 blue:96.0/255.0 alpha:1]];
    for (int index = 0; index < stringArray.count; index++) {
        CGRect frame = CGRectMake(50, 40+70*index, ScreenWidth-100, 50);
        UIButton *timeBtn = [[UIButton alloc] initWithFrame:frame];
        [timeBtn setBackgroundImage:grayimage forState:UIControlStateNormal];
        [timeBtn setBackgroundImage:selectimage forState:UIControlStateHighlighted];
        timeBtn.tag = 100+ index;
        [timeBtn.layer setMasksToBounds:YES];
        [timeBtn.layer setCornerRadius:10];
        NSString * stringtitle = [stringArray objectAtIndex:index];
        [timeBtn setTitle:stringtitle forState:UIControlStateNormal];
        [timeBtn setTitle:stringtitle forState:UIControlStateHighlighted];

        [grayBackview addSubview:timeBtn];
        [timeBtn addTarget:self action:@selector(startNow:) forControlEvents:UIControlEventTouchUpInside];
    }
        

    
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

- (void)seletedDate:(NSDate*)selectedDate andview:(OurDatePickerView*)pickerView{
    TrainingInviteViewController *vc = [[TrainingInviteViewController alloc] init];
    vc.selectCourse = self.selectCourse;
    vc.inselectDate = selectedDate;
    vc.afterminute = 0;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)startNow:(UIButton*)sender{
    if (sender.tag == 103) {
        OurDatePickerView *datepickerView = [[OurDatePickerView alloc] init];
        datepickerView.pickerDelegate = self;
        datepickerView.pickerType = YearMonDayAndHourMinute;
        datepickerView.minuteInterval = 1;
//        datepickerView.miniDate = [NSDate date];
        [datepickerView pickerViewWithView:self.view];
    }else{
        
        TrainingInviteViewController *vc = [[TrainingInviteViewController alloc] init];
        vc.selectCourse = self.selectCourse;
        NSInteger aftermin = 5;
        if (sender.tag == 101) {
            aftermin = 15;
        }
        if (sender.tag == 102) {
            aftermin = 30;
        }
        vc.afterminute = aftermin;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

}

@end
