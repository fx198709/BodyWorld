//
//  CreateCourseSuccessViewController.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/7.
//

#import "CreateCourseSuccessViewController.h"
#import "UserHeadPicView.h"
#import "TableHeadview.h"
#import "UIImage+Extension.h"
#import "CourseDetailSmallview.h"
#import "CourseDetailViewController.h"
@interface CreateCourseSuccessViewController (){
    UIScrollView * _bottomScrollview;
    UIScrollView *userlistView;
    Room *currentRoom;
    NSArray *currentUserList;
}

@end

@implementation CreateCourseSuccessViewController

- (UIView*)userView{
    
    return nil;
}

- (void)changeUserList{
    
}

- (void)addsubviews{
    self.view.hidden = NO;
    _headview.backgroundColor = [UIColor clearColor];
    TableHeadview *tableheadview = (TableHeadview *)[[[NSBundle mainBundle] loadNibNamed:@"TableHeadview" owner:self options:nil] lastObject];
    [_headview addSubview:tableheadview];
    _headview.clipsToBounds = YES;
    [tableheadview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headview);
        make.left.right.bottom.equalTo(_headview);
    }];
    self.title = ChineseStringOrENFun(@"创建完成,等待开始", @"PREPARED COURSE");
    self.headTitle.text = ChineseStringOrENFun(@"对练课程创建完成", @"Congratulations! Finish creating!");
    self.headTitle.font = SystemFontOfSize(20);
    self.timeLabel.text = ReachYearAndWeekTime(currentRoom.start_time);
    
    self.actionbackview.backgroundColor = BuddyTableBackColor;
    NSString *startNowString = ChineseStringOrENFun(@"提前开始", @"Start Now");
    self.startNowBtn.layer.cornerRadius =5;
    self.startNowBtn.clipsToBounds =YES;

    [self.startNowBtn setTitle:startNowString forState:UIControlStateNormal];
    [self.startNowBtn setTitle:startNowString forState:UIControlStateHighlighted];
    UIImage * image1 = [UIImage imageWithColor:SelectGreenColor];
    [self.startNowBtn setBackgroundImage:image1 forState:UIControlStateNormal];
    [self.startNowBtn setBackgroundImage:image1 forState:UIControlStateHighlighted];
    [self.startNowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.startNowBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [self.startNowBtn addTarget:self action:@selector(startNowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tillBtn.backgroundColor = UIRGBColor(79, 79, 79, 1);
    [self.tillBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.tillBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    self.tillBtn.layer.cornerRadius =5;
    self.tillBtn.clipsToBounds =YES;
    // Do any additional setup after loading the view from its nib.
    
    _bottomScrollview = [[UIScrollView alloc] init];
    [self.view addSubview:_bottomScrollview];
    
    [_bottomScrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_actionbackview.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
   
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [_bottomScrollview addSubview:titleLabel];
    titleLabel.text = ChineseStringOrENFun(@"修改成员", @"Change teammates");
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = SystemFontOfSize(20);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomScrollview);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(25);
    }];

    userlistView = [[UIScrollView alloc] init];
    [_bottomScrollview addSubview:userlistView];
    _bottomScrollview.backgroundColor = BuddyTableBackColor;
    int listwidth = ScreenWidth - 30;
    [userlistView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(130);
        make.width.mas_equalTo(listwidth);
    }];
    [self changeUserList];
//    for ( ; ; ) {
//        <#statements#>
//    }
    
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = UIRGBColor(225, 225, 225, 0.5);
    [_bottomScrollview addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userlistView.mas_bottom).offset(15);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *titleLabel1 = [[UILabel alloc] init];
    [_bottomScrollview addSubview:titleLabel1];
    titleLabel1.text = ChineseStringOrENFun(@"课程介绍", @"Course introduction");
    titleLabel1.textColor = UIColor.whiteColor;
    titleLabel1.font = SystemFontOfSize(20);
    [titleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview.mas_bottom).offset(5);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(25);
    }];
    
    UIView *courseDetailView = [[UIView alloc] init];
    [_bottomScrollview addSubview:courseDetailView];
    [courseDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel1.mas_bottom).offset(15);
        make.left.equalTo(_bottomScrollview).offset(15);
        make.right.equalTo(_bottomScrollview).offset(-15);
        make.height.mas_equalTo(300);
        make.bottom.equalTo(_bottomScrollview).offset(-15);
    }];
    courseDetailView.backgroundColor = UIRGBColor(59, 59, 59, 1);
    courseDetailView.layer.cornerRadius = 10;
    courseDetailView.clipsToBounds = YES;
    
    UIImageView *mainImageview = [[UIImageView alloc] init];
    [courseDetailView addSubview:mainImageview];
    [mainImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(courseDetailView);
        make.left.right.equalTo(courseDetailView);
        make.height.mas_equalTo(210);
    }];
    NSString *picUrl = [NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, currentRoom.pic];
    [mainImageview sd_setImageWithURL: [NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    CourseDetailSmallview *detailsmall = (CourseDetailSmallview *)[[[NSBundle mainBundle] loadNibNamed:@"CourseDetailSmallview" owner:self options:nil] lastObject];
    [courseDetailView addSubview:detailsmall];
    [detailsmall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainImageview.mas_bottom);
        make.left.right.equalTo(courseDetailView);
        make.height.mas_equalTo(90);
    }];
    [detailsmall changeDatawithRoom:currentRoom];
    [detailsmall.detailBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)detailBtnClick{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CourseDetailViewController *vc = (CourseDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"courseDetailVC"];
    vc.selectRoom = currentRoom;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hidden = YES;
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self reachData];

    
}

- (void)reachData{
    [self reachRoomDetailInfo];
    NSDictionary *baddyParams = @{
                           @"event_id": self.event_id,
                       };
    [[AFAppNetAPIClient manager] GET:@"room/user" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
        if (CheckResponseObject(responseObject)) {
            NSArray *userlist = responseObject[@"recordset"];
            if ([userlist isKindOfClass:[NSArray class]]) {
                NSMutableArray *list = [NSMutableArray array];
                for (NSDictionary *dic in userlist) {
                    UserInfo * user = [[UserInfo alloc] initWithJSON:dic];
                    [list addObject:user];
                    
                }
                self->currentUserList = list;
                [self changeUserList];
            }
            
        }
       
      
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}

- (void)reachRoomDetailInfo
{
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
        NSString *eventid = self.event_id;
        NSDictionary *baddyParams = @{
                               @"event_id": eventid,
                           };
        [manager GET:@"room/detail" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSDictionary *roomJson = responseObject[@"recordset"];
            self->currentRoom = [[Room alloc] initWithJSON:roomJson];
            self->currentRoom.event_id = eventid;
//            没有创建过视图，处理一下
            if (!self->_bottomScrollview) {
                [self addsubviews];
            }else{
//                只改变状态
            }
            
          
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
        if (CheckResponseObject(responseObject)) {
            NSDictionary *roomJson = responseObject[@"recordset"];

        }
       
      
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
