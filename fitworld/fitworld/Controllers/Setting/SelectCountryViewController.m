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

//返回Section总数

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _firstStringArray.count;
}

//返回每个Section的行数

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    NSString *firstWord = [_firstStringArray objectAtIndex:section];
    NSArray *tempArray =[self.allLocationDic objectForKey:firstWord];
    return [tempArray count];

}

//返回每个Section的title

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//
//{
//    NSString *firstWord = [_firstStringArray objectAtIndex:section];
//    return firstWord;
//
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
    UILabel *vlabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 200, 20)];
    [view addSubview:vlabel];
    NSString *firstWord = [_firstStringArray objectAtIndex:section];

    vlabel.text = firstWord;
    vlabel.font = SystemFontOfSize(20);
    vlabel.textColor = UIColor.whiteColor;
    view.backgroundColor = LittleBgGrayColor;//UIColor.grayColor;
    return view;
}


- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _firstStringArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.selectType == SelectCountryType_City || self.selectType == SelectCountryType_SubCity) {
        return 0;
    }
    return 30;;
}



- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    
    return index;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectCountryCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *firstWord = [_firstStringArray objectAtIndex:indexPath.section];
    NSArray *tempArray =[self.allLocationDic objectForKey:firstWord];
    Country *country = [tempArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = ChineseStringOrENFun(country.name, country.name_en);
    WeakSelf
    cell.selectedCourntyBlock = ^(id clickModel) {
        [wSelf clickedCountry:country];
    };
    return cell;
}

- (void)clickedCountry:(Country*)country{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSString *firstWord = [_firstStringArray objectAtIndex:indexPath.section];
//    NSArray *tempArray =[self.allLocationDic objectForKey:firstWord];
//    Country *country = [tempArray objectAtIndex:indexPath.row];
//    switch (self.selectType) {
//        case SelectCountryType_Country:
//        {
//            [self goToNextView:country type:SelectCountryType_City];
//        }
//            break;
//        case SelectCountryType_City:
//        {
//            if (country.level == 4) {
//                [self sendChangeToServer:country];
//            } else {
//                [self goToNextView:country type:SelectCountryType_SubCity];
//            }
//        }
//            break;
//        case SelectCountryType_SubCity:
//        {
//            [self sendChangeToServer:country];
//        }
//            break;
//
//        default:
//            break;
//    }
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
- (void)changeResultArray:(NSArray*)resultArray{
    //                开始组装数据
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in  resultArray) {
        Country * country = [[Country alloc] initWithDictionary:dic error:nil];
        [country changeOrderString]; //获取排序字母
        [tempArray addObject:country];
    }
//                对temparray进行排序
    NSArray *sortedArray = [tempArray sortedArrayUsingComparator:^(Country *obj1,Country *obj2){
        return [obj1.orderString compare:obj2.orderString];
    }];
    _firstStringArray = [NSMutableArray array];
    _allLocationDic = [NSMutableDictionary dictionary];
    for (Country *orderCountry in sortedArray) {
//
        if (![_firstStringArray containsObject:orderCountry.firstWord]) {
//                        没有找到对应的值，加入进去
            [_firstStringArray addObject:orderCountry.firstWord];
        }
        NSMutableArray *dicarray = [_allLocationDic objectForKey:orderCountry.firstWord];
        if (dicarray ==nil) {
            dicarray = [NSMutableArray array];
        }
        [dicarray addObject:orderCountry];
        [_allLocationDic setObject:dicarray forKey:orderCountry.firstWord];
    }
    [self loadData];
}
//请求国家列表
- (void)getCountryListFromServer {
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] GET:@"country" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *result = [responseObject objectForKey:@"recordset"];
            if ([result isKindOfClass:[NSArray class]]) {
                [self changeResultArray:result];
               
            }else{
                [MTHUD showDurationNoticeHUD:[responseObject objectForKey:@"msg"]];
            }
//            NSArray<Country *> *countryList = [Country arrayOfModelsFromDictionaries:result error:&error];
//            if (error == nil) {
//                self.dataList = countryList;
//                [self loadData];
//            } else {
//                [MTHUD showDurationNoticeHUD:error.localizedDescription];
//            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD showDurationNoticeHUD:error.localizedDescription];
    }];
}

+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}


//请求城市列表
- (void)getCityListFromServer {
    [MTHUD showLoadingHUD];
    Country *city = self.countryList.lastObject;
    NSDictionary *param = @{@"name_en": StringWithDefaultValue(city.name_en, @"")};
    [[AFAppNetAPIClient manager] GET:@"city" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            NSArray *result = [[responseObject objectForKey:@"recordset"] objectForKey:@"rows"];
//            NSError *error;
//            NSArray<Country *> *countryList = [Country arrayOfModelsFromDictionaries:result error:&error];
//            if (error == nil) {
//                self.dataList = countryList;
//                [self loadData];
//            } else {
//                [MTHUD showDurationNoticeHUD:error.localizedDescription];
//            }
            
            NSArray *result = [[responseObject objectForKey:@"recordset"] objectForKey:@"rows"];
            if ([result isKindOfClass:[NSArray class]]) {
                [self changeResultArray:result];
               
            }else{
                [MTHUD showDurationNoticeHUD:[responseObject objectForKey:@"msg"]];
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
            [MTHUD showDurationNoticeHUD:SaveSuccessMsg animated:YES completedBlock:^{
                int count = self.selectType == SelectCountryType_City ? 2 : 3;
                [self popToViewControllerWithPreCount:count animated:YES];
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showChangeFailedError:error];
    }];
}


@end
