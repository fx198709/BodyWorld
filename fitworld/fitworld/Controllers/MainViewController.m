//
//  MainViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/7/4.
//

#import "MainViewController.h"
#import "UIDeps.h"
#import "AFNetworking.h"
#import "FITAPI.h"
#import "TableCollectionViewCell.h"
#import "Course.h"
#import "Room.h"
#import "UserInfo.h"
#import "CourseMoreController.h"
#import "TrainingViewController.h"
#import "UserCenterViewController.h"

@interface MainViewController ()
@property (nonatomic, strong) UserInfo *userInfo;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUserinfo];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TableCollectionViewCell class]) bundle:nil] forCellReuseIdentifier:@"liveCell"];
    
    UIRefreshControl *control = [[UIRefreshControl alloc]init];
    control.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [control addTarget:self action:@selector(handleRefresh) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = control;

}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 创建标识词，随意设置，但不能和其它 tableView 的相同
    static NSString *indentifier = @"mainIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (indexPath.row == 0 && indexPath.section == 0){
        // 复用队列中没有时再创建
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: indentifier];
        
        [cell.contentView addSubview: ({
            UILabel *titleLable =  [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 300, 50)];
            titleLable.font = [UIFont systemFontOfSize: 16];
            titleLable.text = self.userInfo.username;
            titleLable.textColor = [UIColor whiteColor];
            [titleLable sizeToFit];
            titleLable;
        })];
        
        [cell.contentView addSubview: ({
            UILabel *sourceLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 300, 20)];
            sourceLable.font = [UIFont systemFontOfSize: 12];
            sourceLable.text = @"发布人呢";
            sourceLable.textColor = [UIColor whiteColor];
            [sourceLable sizeToFit];
            sourceLable;
        })];
        
        [cell.contentView addSubview: ({
            UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
            [leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", FITAPI_HTTPS_ROOT, self.userInfo.avatar]]];
            leftImageView.contentMode = UIViewContentModeScaleAspectFill;
            leftImageView.layer.masksToBounds = YES;
            leftImageView.layer.cornerRadius = 20;
            [leftImageView.layer setBorderWidth:2];
            [leftImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            leftImageView.userInteractionEnabled=YES;
            UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUserCenter)];
            [leftImageView addGestureRecognizer:singleTap];
            leftImageView;
        })];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor blackColor];
    }

    if (indexPath.row == 1 && indexPath.section == 0){
        _liveIndexPath = indexPath;
        // 复用队列中没有时再创建
        if (cell == nil) {
            // 创建新的 cell，默认为主标题模式
            TableCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveCell" forIndexPath:indexPath];
            [cell.logoImage setImage:[UIImage imageNamed:@"index_live"]];
            NSString *main_liveTitleStr = NSLocalizedString(@"main_liveTitleStr", nil);
            cell.subTitleLabel.text = main_liveTitleStr;
            
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            [cell.attentionBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:(UIControlEventTouchDown)];
            [self refreshData:cell :@""];
            cell.backgroundColor = UIColor.blackColor;
            return cell;
        }
    }
    if (indexPath.row == 2 && indexPath.section == 0){
        _groupIndexPath = indexPath;
        // 复用队列中没有时再创建
        if (cell == nil) {
            // 创建新的 cell，默认为主标题模式
            TableCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            [cell.logoImage setImage:[UIImage imageNamed:@"index_group"]];
            cell.subTitleLabel.text = @"GROUP CLASS";
            
            [cell.attentionBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchDown];
//            [self refreshData:cell :@"团课"];
//            [self refreshData:cell :@"对练课"];
            cell.backgroundColor = UIColor.blackColor;
            return cell;
        }
    }
    if (indexPath.row == 3 && indexPath.section == 0){
        _buddyIndexPath = indexPath;
        if (cell == nil) {
            // 创建新的 cell，默认为主标题模式
            TableCollectionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveCell" forIndexPath:indexPath];
            [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
            [cell.attentionBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.logoImage setImage:[UIImage imageNamed:@"index_buddy"]];
            cell.subTitleLabel.text = @"BUDDY TRAINING";
            
            UIButton *createSessionBtn = [[UIButton alloc] init];
            [createSessionBtn setTitle:@"Create a session" forState:UIControlStateNormal];
            createSessionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [createSessionBtn.layer setBorderWidth:5];
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){0,0,0,0.1});
            [createSessionBtn.layer setBorderColor:color];
            [cell addSubview:createSessionBtn];
            [createSessionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(30);
                make.centerY.equalTo(cell.subTitleLabel);
                make.left.equalTo(cell.subTitleLabel.mas_right).offset(20);
            }];
            [createSessionBtn addTarget:self action:@selector(clickCreateSessionTraining) forControlEvents:UIControlEventTouchUpInside];
//            [self refreshData:cell :@"对练课"];
            cell.backgroundColor = UIColor.blackColor;
            return cell;
        }
    }else{
        if (cell == nil) {
            // 创建新的 cell，默认为主标题模式
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.textLabel.text = @"aaaa";
        }
    }
    
    return cell;
}


// 设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return 80;
    }
    return 200;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)moreBtnClick
{
    NSLog(@"more btn click");
    CourseMoreController *courseMoreVC = [[CourseMoreController alloc]init];
    courseMoreVC.VCtype = [NSString stringWithFormat:@"%zd",0];
    courseMoreVC.navigationItem.title = @"Course";
    [self.navigationController pushViewController:courseMoreVC animated:YES];
}

// 初始化用户信息
- (void) initUserinfo
{
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSString *strUrl = [NSString stringWithFormat:@"%@user_info", FITAPI_HTTPS_PREFIX];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"X-Requested-With" forHTTPHeaderField:@"X-Requested-With"];

    [manager GET:strUrl parameters:nil headers:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success ---- %@", responseObject);
        self.userInfo = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"]];
        NSLog(@"success username ---- %@", self.userInfo.username);

        [self.tableView reloadData];
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"failure ---- %@", error);
    }];
}

#pragma mark - 刷新房间数据
- (void) refreshData: (TableCollectionViewCell *) collectionCell: (NSString *) type
{
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSLog(@"initroom userToken ---- %@", userToken);

    NSString *strUrl = [NSString stringWithFormat:@"%@room", FITAPI_HTTPS_PREFIX];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSDictionary *baddyParams = @{
                           @"type": type,
                           @"page": @"1",
                           @"row": @"5"
                       };
    [manager GET:strUrl parameters:baddyParams headers:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject ---- %@", responseObject);
        long total =  [responseObject[@"recordset"][@"total"] longValue];
        if(total > 0){
            Room *room = [[Room alloc] initWithJSON: responseObject[@"recordset"][@"rows"][0]];
            NSMutableArray *dataArr = [[NSMutableArray alloc] init];
            [dataArr addObject: room];
            collectionCell.dataArr = dataArr;
            [collectionCell.myCollectionView reloadData];
        }
        if ([self.tableView.refreshControl isRefreshing]) {
            [self.tableView.refreshControl endRefreshing];
        }

       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"failure ---- %@", error);
    }];
}

- (void)handleRefresh {
    
    TableCollectionViewCell *liveCell = [self.tableView dequeueReusableCellWithIdentifier:@"liveCell" forIndexPath:_liveIndexPath];
    NSString *userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    NSLog(@"initroom userToken ---- %@", userToken);

    NSString *strUrl = [NSString stringWithFormat:@"%@room", FITAPI_HTTPS_PREFIX];
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:userToken forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSDictionary *baddyParams = @{
                           @"type": @"",
                           @"page": @"1",
                           @"row": @"5"
                       };
    [manager GET:strUrl parameters:baddyParams headers:nil progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject ---- %@", responseObject);
        long total =  [responseObject[@"recordset"][@"total"] longValue];
        NSMutableArray *dataArr = [[NSMutableArray alloc] init];
        
        if(total > 0){
            Room *room = [[Room alloc] initWithJSON: responseObject[@"recordset"][@"rows"][0]];
            [dataArr addObject: room];
            liveCell.dataArr = dataArr;
            [self.tableView reloadData];
        }else{
            liveCell.dataArr = dataArr;
            [self.tableView reloadData];
        }
        if ([self.tableView.refreshControl isRefreshing]) {
            [self.tableView.refreshControl endRefreshing];
        }

       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSLog(@"failure ---- %@", error);
    }];
    
//    TableCollectionViewCell *groupCell = [self.tableView dequeueReusableCellWithIdentifier:@"liveCell" forIndexPath:_groupIndexPath];
//    [self refreshData:groupCell :@"团课"];
//
//    TableCollectionViewCell *buddyCell = [self.tableView dequeueReusableCellWithIdentifier:@"liveCell" forIndexPath:_buddyIndexPath];
//    [self refreshData:buddyCell :@"对练课"];
}

- (void)onClickUserCenter {
    NSLog(@"onClickUserCenter ----  ");

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //这里的id填刚刚设置的值,vc设置属性就可以给下个页面传参数了
    UserCenterViewController *vc = (UserCenterViewController *)[storyboard instantiateViewControllerWithIdentifier:@"userCenterVC"];
    vc.userInfo = self.userInfo;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)clickCreateSessionTraining{
    NSLog(@"createSessionTraining ----  ");
    
    TrainingViewController *vc = [[TrainingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear %@",self.class);
}
@end
