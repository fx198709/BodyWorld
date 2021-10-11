//
//  UserCenterViewController.m
//  fitworld
//
//  Created by 王巍 on 2021/7/20.
//

#import "SystemViewController.h"
#import "ResetPwdController.h"
#import "LoginController.h"

@interface SystemViewController ()

@property (nonatomic, strong) NSArray *titles;

@end

@implementation SystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    _titles = @[@"更新个人信息", @"修改密码", @"清除缓存", @"退出登录"];
    self.navigationItem.title = @"设置";
    self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.separatorColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [UITableViewCell new];
    cell.textLabel.text = _titles[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
           
            break;
        }
        case 1:
        {
            ResetPwdController *restPwdVC = [[ResetPwdController alloc] init];
            [self.navigationController pushViewController:restPwdVC animated:YES];

//            FeedBackViewController *feedBackViewController = [FeedBackViewController new];
//            [self.navigationController pushViewController:feedBackViewController animated:YES];
            break;
        }
        case 2:
        {
            // 目前暂无缓存需要清理
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定清除缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"清除", nil];
            [alertView show];
//            AboutViewController *aboutViewController = [AboutViewController new];
//            [self.navigationController pushViewController:aboutViewController animated:YES];
            break;
        }
            
        case 3:
        {
            UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"确定退出？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
                LoginController *loginVC = [[LoginController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }];
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alter addAction:sure];
            [alter addAction:cancle];
            
            [self presentViewController:alter animated:YES completion:^{
                
            }];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
//        [[CacheProjectsUtil shareInstance] removeCache];
    }
}

@end
