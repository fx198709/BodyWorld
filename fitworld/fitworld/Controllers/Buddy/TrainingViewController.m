//
//  TrainingViewController.m
//  TrainingViewController
//
//

#import "TrainingViewController.h"
#import "UIDeps.h"
#import "AFNetworking.h"
#import "FITAPI.h"
#import "Room.h"
#import <math.h>
#import "TrainingStartViewController.h"
#import "SelectClassHeadview.h"
#import "TableHeadview.h"
@interface TrainingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) Course *selectCourse;
@end

@implementation TrainingViewController{
    NSMutableArray *dataArr;
    UICollectionView *collectionView;
    NSMutableArray *dayArrs;
    NSString *selectDay;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.tableView];
    
    SelectClassHeadview *topFlowImg = (SelectClassHeadview *)[[[NSBundle mainBundle] loadNibNamed:@"SelectClassHeadview" owner:self options:nil] lastObject];
    [self.view addSubview:topFlowImg];
    [topFlowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(80);
    }];
    
    TableHeadview *tableheadview = (TableHeadview *)[[[NSBundle mainBundle] loadNibNamed:@"TableHeadview" owner:self options:nil] lastObject];
    [self.view addSubview:tableheadview];
    [tableheadview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topFlowImg.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
    }];
    tableheadview.clipsToBounds = YES;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..." attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = UIRGBColor(37, 37, 37, 1);
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorColor = UIColor.clearColor;
    [self refreshData];
    
    self.title = ChineseStringOrENFun(@"选择课程", @"CHOOSE COURSE");
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(UITableView*)tableView{
    
    if (_tableView==nil) {
        CGRect frame =CGRectMake(0, 160, kScreenWidth, self.view.bounds.size.height - 160);
        _tableView=[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIRGBColor(37, 37, 37, 1);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}
#pragma mark TableViewDelegate&DataSource
 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    RemoveSubviews(cell.contentView, @[]);
    UIView *cellView = cell.contentView;
    UIView *cellBgView = [[UIView alloc] init];
    [cellBgView.layer setMasksToBounds:YES];
    [cellBgView.layer setCornerRadius:12];
    [cellView addSubview:cellBgView];
    [cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left);
        make.right.equalTo(cellView.mas_right);
        make.top.equalTo(cellView).offset(7);
        make.bottom.equalTo(cellView);
    }];

    Course *course = dataArr[indexPath.row];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 19, 56, 56)];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, course.pic]] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    [cellView addSubview:leftImageView];
    leftImageView.layer.cornerRadius = 28;
    leftImageView.clipsToBounds = YES;
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = course.name;
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = UIColor.whiteColor;
    [cellBgView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellBgView).offset(17);
        make.left.equalTo(leftImageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.equalTo(cellBgView).offset(-90);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = [NSString stringWithFormat:@"%@•%@",course.coach_name,course.course_type_name];
    label2.font = [UIFont systemFontOfSize:13];
    label2.textColor = UIColorFromRGB(207, 207, 207);
    [cellBgView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom).offset(5);
        make.left.equalTo(leftImageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.equalTo(cellBgView).offset(-90);
    }];
    
//    UILabel *label3 = [[UILabel alloc] init];
//    label3.text = course.updated_at_weekDay;
//    label3.font = [UIFont systemFontOfSize:11];
//    label3.textColor = UIColorFromRGB(227, 227, 227);
//    [cellBgView addSubview:label3];
//    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(label2).offset(15);
//        make.left.equalTo(leftImageView.mas_right).offset(10);
//        make.height.mas_equalTo(20);
//        make.right.equalTo(cellBgView).offset(-90);
//    }];
    
    UIButton *selectBtn = [[UIButton alloc] init];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnImage = [UIImage imageNamed:@"greenbtn"];
    [selectBtn setBackgroundImage:btnImage forState:UIControlStateNormal];
    [selectBtn setBackgroundImage:btnImage forState:UIControlStateHighlighted];
    NSString *btnTitle = ChineseStringOrENFun(@"选择", @"Choose");
    [selectBtn setTitle:btnTitle forState:UIControlStateNormal];
    [selectBtn setTitle:btnTitle forState:UIControlStateHighlighted];

    selectBtn.tag = indexPath.row;
    [cell.contentView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.contentView).offset(-10);
        make.centerY.equalTo(cell.contentView);
        make.height.mas_equalTo(26);
        make.width.mas_equalTo(70);
    }];
    selectBtn.layer.cornerRadius = 13;
    selectBtn.clipsToBounds = YES;
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(20, 89.5, ScreenWidth-20, 0.5)];
    lineview.backgroundColor = UIRGBColor(225, 225, 225, 0.5);
    [cell.contentView addSubview:lineview];
    cell.contentView.backgroundColor = UIRGBColor(37, 37, 37, 1);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Course *course = dataArr[indexPath.row];
    self.selectCourse = course;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)selectBtn:(UIButton *) btn{
    NSLog(@"select");
    Course *course = dataArr[btn.tag];
    self.selectCourse = course;
    TrainingStartViewController *vc = [[TrainingStartViewController alloc] init];
    vc.selectCourse = self.selectCourse;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 刷新房间数据
- (void) refreshData
{
    [dataArr removeAllObjects];
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSLog(@"initroom userToken ---- %@", userToken);

    NSString *strUrl = [NSString stringWithFormat:@"%@course", FITAPI_HTTPS_PREFIX];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSDictionary *baddyParams = @{
                           @"type": @"对练课",
                           @"page": @"1",
                           @"row": @"5"                       };
  
    [manager GET:strUrl parameters:baddyParams headers:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject ---- %@", responseObject);
        long total =  [responseObject[@"recordset"][@"total"] longValue];
        self->dataArr = [[NSMutableArray alloc] init];
        if(total > 0){
            NSArray *array = responseObject[@"recordset"][@"rows"];
            for (int i = 0; i < [array count]; i++) {
                Course *course = [[Course alloc] initWithJSON: array[i]];
                [self->dataArr addObject: course];
            }
        }
        [self.tableView reloadData];
        if ([self.tableView.refreshControl isRefreshing]) {
            [self.tableView.refreshControl endRefreshing];
        }
        
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"failure ---- %@", error);
    }];
}

@end
