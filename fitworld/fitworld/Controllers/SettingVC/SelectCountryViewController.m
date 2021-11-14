//
//  SelectCountryViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/11.
//

#import "SelectCountryViewController.h"
#import "SelectCountryCell.h"

@interface SelectCountryViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray<Country *> *dataList;

@end

@implementation SelectCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self getNavTitle];
    [self initView];
    if (self.selectType == SelectCountryType_Country) {
        [self getCountryListFromServer];
    } else {
        [self getCityListFromServer:self.country];
    }
}


- (void)initView {
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    Class cellClass = [SelectCountryCell class];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (NSString *)getNavTitle {
    switch (self.selectType) {
        case SelectCountryType_Country:
            return ChineseStringOrENFun(@"选择国家", @"Select country");
        case SelectCountryType_City:
            return ChineseStringOrENFun(@"选择城市", @"Select city");
        default:
            break;
    }
    return @"";
}


- (void)loadData {
    [self.tableView reloadData];
}

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectCountryCell class])];
    Country *country = [self.dataList objectAtIndex:indexPath.row];
    cell.titleLabel.text = ChineseStringOrENFun(country.name, country.name_en);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Country *country = [self.dataList objectAtIndex:indexPath.row];
    switch (self.selectType) {
        case SelectCountryType_Country:
        {
            SelectCountryViewController *nextVC = VCBySBName(@"SelectCountryViewController");
            nextVC.selectType = SelectCountryType_City;
            nextVC.country = country;
            [self.navigationController pushViewController:nextVC animated:YES];
        }
            break;
        case SelectCountryType_City:
        {
            [self sendChangeToServer:country];
        }
            break;
        default:
            break;
    }
}

#pragma mark - server

//请求国家列表
- (void)getCountryListFromServer {
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] GET:@"country" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"====respong:%@", responseObject);
            NSArray *result = [responseObject objectForKey:@"recordset"];
            NSError *error;
            NSArray<Country *> *countryList = [Country arrayOfModelsFromDictionaries:result error:&error];
            if (error == nil) {
                self.dataList = countryList;
                [self loadData];
            } else {
                [MTHUD showDurationNoticeHUD:error.localizedDescription];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}


//请求国家列表
- (void)getCityListFromServer:(Country *)country {
    [MTHUD showLoadingHUD];
    NSDictionary *param = @{@"name_en": StringWithDefaultValue(country.name_en, @"")};
    [[AFAppNetAPIClient manager] GET:@"city" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"====respong:%@", responseObject);
            NSArray *result = [responseObject objectForKey:@"recordset"];
            NSError *error;
            NSArray<Country *> *countryList = [Country arrayOfModelsFromDictionaries:result error:&error];
            if (error == nil) {
                self.dataList = countryList;
                [self loadData];
            } else {
                [MTHUD showDurationNoticeHUD:error.localizedDescription];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

//修改城市
- (void)sendChangeToServer:(Country *)city {
    NSDictionary *param = @{
        @"country":ChineseStringOrENFun(self.country.name, self.country.name_en),
        @"city":ChineseStringOrENFun(city.name, city.name_en)
    };
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"user" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        if ([responseObject objectForKey:@"recordset"]) {
            UserInfo *userInfo = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"]];
            [APPObjOnce sharedAppOnce].currentUser = userInfo;
            [MTHUD showDurationNoticeHUD:ChangeSuccessMsg animated:YES completedBlock:^{
                [self popToViewControllerWithPreCount:2 animated:YES];
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showChangeFailedError:error];
    }];
}


@end
