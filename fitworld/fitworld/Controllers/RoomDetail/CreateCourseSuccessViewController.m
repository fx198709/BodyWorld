//
//  CreateCourseSuccessViewController.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/7.
//

#import "CreateCourseSuccessViewController.h"
 

@interface CreateCourseSuccessViewController (){
    UIScrollView * _bottomScrollview;
    
}

@end

@implementation CreateCourseSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ChineseStringOrENFun(@"对练课程创建完成", @"PREPARED COURSE");
    self.actionbackview.backgroundColor = UIColor.clearColor;
    self.actionbackview.backgroundColor = UIColor.clearColor;
    NSString *startNowString = ChineseStringOrENFun(@"提前开始", @"Start Now");
    [self.startNowBtn setTitle:startNowString forState:UIControlStateNormal];
    [self.startNowBtn setTitle:startNowString forState:UIControlStateHighlighted];
    UIImage * image1 = [UIImage imageNamed:@"greenbtn"];
    [self.startNowBtn setImage:image1 forState:UIControlStateNormal];
    [self.startNowBtn setImage:image1 forState:UIControlStateHighlighted];
    [self.startNowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.startNowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [self.startNowBtn addTarget:self action:@selector(startNowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tillBtn.backgroundColor = UIRGBColor(79, 79, 79, 1);
    [self.tillBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.tillBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
    
    _bottomScrollview = [[UIScrollView alloc] init];
    [self.view addSubview:_bottomScrollview];
    
    [_bottomScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_actionbackview.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    UIView *userlistView = [[UIScrollView alloc] init];
    [_bottomScrollview addSubview:userlistView];
    [userlistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomScrollview);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(130);
    }];
    
//    for ( ; ; ) {
//        <#statements#>
//    }
    
    
    UIView *courseDetailView = [[UIView alloc] init];
    [_bottomScrollview addSubview:courseDetailView];
    [userlistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userlistView.mas_bottom);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(300);
        make.bottom.equalTo(_bottomScrollview);
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self reachData];

    
}

- (void)reachData{
    NSDictionary *baddyParams = @{
                           @"event_id": self.event_id,
                       };
    [[AFAppNetAPIClient manager] GET:@"room/user" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *roomJson = responseObject[@"recordset"];
       
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//http://1.117.70.210:8091/api/room/user?event_id=380559132387707396


- (void)startNowBtnClicked:(UIButton *)startNowBtn{
//http://1.117.70.210:8091/api/room/start_in_advance
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];

    NSDictionary *baddyParams = @{
                           @"event_id": self.event_id,
                       };
    [manager POST:@"room/start_in_advance" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *roomJson = responseObject[@"recordset"];
       
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
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
