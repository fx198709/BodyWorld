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
    
    UIImageView *topFlowImg = [[UIImageView alloc] init];
    topFlowImg.image = [UIImage imageNamed:@"buddy_flow1"];
    [self.view addSubview:topFlowImg];
    [topFlowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.mas_equalTo(53);
    }];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor whiteColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..." attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = UIColor.blackColor;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self refreshData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

-(UITableView*)tableView{
    
    if (_tableView==nil) {
        CGRect frame =CGRectMake(0, 120, kScreenWidth, self.view.bounds.size.height - 100);
        _tableView=[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}
#pragma mark TableViewDelegate&DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
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
    
    UIView *cellView = [[UIView alloc] init];
    [cell.contentView addSubview:cellView];
    [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cell);
        make.top.equalTo(cell).offset(20);
        make.bottom.equalTo(cell.mas_bottom).offset(-20);
    }];
    
    cell.backgroundColor = UIColor.greenColor;
    
    UIView *cellBgView = [[UIView alloc] init];
    [cellBgView.layer setMasksToBounds:YES];
    [cellBgView.layer setCornerRadius:12];
    cellBgView.backgroundColor = UIColor.darkGrayColor;
    [cellView addSubview:cellBgView];
    [cellBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(10);
        make.right.equalTo(cellView.mas_right).offset(-10);
        make.top.equalTo(cellView).offset(15);
        make.bottom.equalTo(cellView);
    }];

    Course *course = dataArr[indexPath.row];
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 100, 80)];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, course.pic]] placeholderImage:[UIImage imageNamed:@"coursedetail_top"]];
    [cellView addSubview:leftImageView];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = course.name;
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = UIColor.whiteColor;
    [cellBgView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cellBgView).offset(10);
        make.left.equalTo(leftImageView.mas_right).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(120);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = course.coach_name;
    label2.font = [UIFont systemFontOfSize:10];
    label2.textColor = UIColor.whiteColor;
    [cellBgView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1).offset(20);
        make.left.equalTo(leftImageView.mas_right).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(120);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = [NSString stringWithFormat:@"%@", course.updated_at];
    label3.font = [UIFont systemFontOfSize:10];
    label3.textColor = UIColor.whiteColor;
    [cellBgView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label2).offset(20);
        make.left.equalTo(leftImageView.mas_right).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(120);
    }];
    
    UIButton *selectBtn = [[UIButton alloc] init];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [selectBtn setTitle:@"Select" forState:UIControlStateNormal];
    selectBtn.backgroundColor = UIColor.greenColor;
    [selectBtn addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    selectBtn.tag = indexPath.row;
    [cell addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cellBgView).offset(-10);
        make.centerY.equalTo(cellBgView);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(60);
    }];
    cell.backgroundColor = UIColor.blackColor;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
        if(total > 0){
            self->dataArr = [[NSMutableArray alloc] init];
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
