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

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation SelectCountryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self getNavTitle];
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

#pragma mark - table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectCountryCell class])];
    //todo set data
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (self.selectType) {
        case SelectCountryType_Country:
        {
            SelectCountryViewController *nextVC = VCBySBName(@"SelectCountryViewController");
            nextVC.selectType = SelectCountryType_City;
            [self.navigationController pushViewController:nextVC animated:YES];
        }
            break;
        case SelectCountryType_City:
        {
            //todo
            
        }
            break;
        default:
            break;
    }
}


@end
