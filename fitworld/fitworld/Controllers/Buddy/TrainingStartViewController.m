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
#import "ScreenModel.h"


#define LitterGrayColor UIRGBColor(69, 69, 69, 1)
@interface TrainingStartViewController (){
    NSArray *language_array;
    UIButton *languageBtn;
}
@property(nonatomic,strong) NSString *courseId;
@property(nonatomic,strong) NSString *languageID; //选中的语言id

@end

@implementation TrainingStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ChineseStringOrENFun(@"设置开始时间", @"Set your start time");
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
    UIImage *grayimage = [UIImage imageWithColor:LitterGrayColor];
    UIImage *selectimage = [UIImage imageWithColor:[UIColor colorWithRed:73.0/255.0  green:146.0/255.0 blue:96.0/255.0 alpha:1]];
    UIView *grayBackview = [[UIView alloc] init];
    [self.view addSubview:grayBackview];
    grayBackview.backgroundColor = BgGrayColor;
    [grayBackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableheadview.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view);
    }];
    int startx = 20;
    UILabel *titelLabel1 = [[UILabel alloc] init];
    [grayBackview addSubview:titelLabel1];
    titelLabel1.frame = CGRectMake(50, startx, 200, 24);
    titelLabel1.textColor = UIColor.whiteColor;
    titelLabel1.text = ChineseStringOrENFun(@"语言选择", @"Language Select");
    startx = startx+40;
    CGRect frame = CGRectMake(50, startx, ScreenWidth-100, 50);
    languageBtn = [[UIButton alloc] initWithFrame:frame];
    [languageBtn setBackgroundImage:grayimage forState:UIControlStateNormal];
    languageBtn.tag = 200;
    [languageBtn.layer setMasksToBounds:YES];
    [languageBtn.layer setCornerRadius:10];
    NSString * stringtitle = ChineseStringOrENFun(@"请选择语言", @"Please Select Language");
    [languageBtn setTitle:stringtitle forState:UIControlStateNormal];
    [languageBtn setTitle:stringtitle forState:UIControlStateHighlighted];

    [grayBackview addSubview:languageBtn];
    [languageBtn addTarget:self action:@selector(startNow:) forControlEvents:UIControlEventTouchUpInside];
    
//    icon_back
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_back"]];
    [languageBtn addSubview:imageview];
    imageview.frame = CGRectMake(ScreenWidth-100-30, 13, 24, 24);
    
    startx = startx+50+30;
    UILabel *titelLabel = [[UILabel alloc] init];
    [grayBackview addSubview:titelLabel];
    titelLabel.frame = CGRectMake(50, startx, 200, 24);
    titelLabel.textColor = UIColor.whiteColor;
    titelLabel.text = ChineseStringOrENFun(@"时间设置", @"Time Select");
        
    NSString * string1 = ChineseStringOrENFun(@"5分钟后", @"In 5 min");
    NSString * string2 = ChineseStringOrENFun(@"15分钟后", @"In 15 min");
    NSString * string3 = ChineseStringOrENFun(@"30分钟后", @"In 30 min");
    NSString * string4 = ChineseStringOrENFun(@"自定义时间", @"Custom");
    NSArray *stringArray = @[string1,string2,string3,string4];
    startx = startx+40;

    for (int index = 0; index < stringArray.count; index++) {
        CGRect frame = CGRectMake(50, startx, ScreenWidth-100, 50);
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
        startx = startx+70;
    }
    [self reachSearchOption];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    vc.languageType = _languageID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)checkHasSelectLanguage{
    if (_languageID && _languageID.length > 0) {
        return YES;
    }
    [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"请选择语言", @"Please Select Language") control:self];
    return  NO;
}

- (void)selectLanguage:(ScreenModel*)model{
    _languageID = model.id;
    [languageBtn setTitle:model.name forState:UIControlStateNormal];
    [languageBtn setTitle:model.name forState:UIControlStateHighlighted];
}

- (void)startNow:(UIButton*)sender{
    if (sender.tag == 103) {
//        先选择语言
        if (![self checkHasSelectLanguage]) {
            return;
        }
        OurDatePickerView *datepickerView = [[OurDatePickerView alloc] init];
        datepickerView.pickerDelegate = self;
        datepickerView.pickerType = YearMonDayAndHourMinute;
        datepickerView.minuteInterval = 1;
        
        datepickerView.miniDate = [NSDate dateWithTimeIntervalSinceNow:0];
        datepickerView.leftmaxDate = [NSDate dateWithTimeIntervalSinceNow:7*24*60*60];
        [datepickerView pickerViewWithView:self.view];
    }else if (sender.tag == 200) {
//        选择语言
        [self.view endEditing:YES];
//        从网络获取语言选项
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if (language_array.count <1) {
            ScreenModel *vmodel = [[ScreenModel alloc] init];
            vmodel.id =@"Chinese";
            vmodel.name = @"中文";
            language_array = [NSArray arrayWithObject:vmodel];
        }
        for (int index = 0; index<language_array.count; index++) {
            ScreenModel *vmodel = [language_array objectAtIndex:index];
            [ac addAction:[UIAlertAction actionWithTitle:vmodel.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self selectLanguage:vmodel];
            }]];
        }
        [ac addAction:[UIAlertAction actionWithTitle:ChineseStringOrENFun(@"取消", @"Cancel") style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:ac animated:YES completion:nil];
    }else{
//        先选择语言
        if (![self checkHasSelectLanguage]) {
            return;
        }
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
        vc.languageType = _languageID;
        [self.navigationController pushViewController:vc animated:YES];
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
            for (NSDictionary *dic in [dataDic objectForKey:@"course_language"]) {
                ScreenModel *vmodel = [[ScreenModel alloc] initWithJSON:dic];
                [tempArray addObject:vmodel];
            }
            self->language_array = tempArray;
             
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



@end
