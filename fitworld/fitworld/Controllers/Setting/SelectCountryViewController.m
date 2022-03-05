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
    [self initView];
    NSString *title = nil;
    switch (self.selectType) {
        case SelectCountryType_Country:
        {
            
                title = ChineseStringOrENFun(@"选择国家", @"Country / Region");
                [self getCountryListFromServer];
        }
            break;
        case SelectCountryType_City:
        {
            title = ChineseStringOrENFun(@"选择省份", @"Province / Region");
            [self getCityListFromServer];
        }
            break;
        case SelectCountryType_SubCity:
        {
            title = ChineseStringOrENFun(@"选择城市", @"City / Region");
            [self getCityListFromServer];
        }
            break;
        default:
            break;
    }
    
    self.navigationItem.title = title;
}


- (void)initView {
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    Class cellClass = [SelectCountryCell class];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            [self goToNextView:country type:SelectCountryType_City];
        }
            break;
        case SelectCountryType_City:
        {
            if (country.level == 4) {
                [self sendChangeToServer:country];
            } else {
                [self goToNextView:country type:SelectCountryType_SubCity];
            }
        }
            break;
        case SelectCountryType_SubCity:
        {
            [self sendChangeToServer:country];
        }
            break;
            
        default:
            break;
    }
}

- (void)goToNextView:(Country *)country type:(SelectCountryType)type {
    SelectCountryViewController *nextVC = VCBySBName(@"SelectCountryViewController");
    nextVC.selectType = type;
    NSMutableArray *nextCountryList = [NSMutableArray array];
    if (self.countryList != nil && self.countryList.count > 0) {
        [nextCountryList addObjectsFromArray:self.countryList];
    }
    [nextCountryList addObject:country];
    nextVC.countryList = nextCountryList;
    [self.navigationController pushViewController:nextVC animated:YES];
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


//请求城市列表
- (void)getCityListFromServer {
    [MTHUD showLoadingHUD];
    Country *city = self.countryList.lastObject;
    NSDictionary *param = @{@"name_en": StringWithDefaultValue(city.name_en, @"")};
    [[AFAppNetAPIClient manager] GET:@"city" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"====respong:%@", responseObject);
            NSArray *result = [[responseObject objectForKey:@"recordset"] objectForKey:@"rows"];
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
    Country *country = self.countryList.firstObject;

    NSDictionary *param = @{
        @"country": country.name_en,
        @"city":city.name_en
    };
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"user" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        if ([responseObject objectForKey:@"recordset"]) {
            UserInfo *userInfo = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"]];
            [APPObjOnce sharedAppOnce].currentUser = userInfo;
            [MTHUD showDurationNoticeHUD:ChangeSuccessMsg animated:YES completedBlock:^{
                int count = self.selectType == SelectCountryType_City ? 2 : 3;
                [self popToViewControllerWithPreCount:count animated:YES];
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showChangeFailedError:error];
    }];
}


@end
