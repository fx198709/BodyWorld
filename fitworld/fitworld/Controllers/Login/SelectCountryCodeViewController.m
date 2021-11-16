//
//  SelectCountryCodeViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/12.
//

#import "SelectCountryCodeViewController.h"
#import "SelectCountryCodeCell.h"

@interface SelectCountryCodeViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *closeBtn;

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray<CountryCode *> *> *codeDict;
@property (nonatomic, strong) NSArray *codeKeyList;

@end

@implementation SelectCountryCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromFile];
    [self initView];
}

- (void)initView {
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    Class cellClass = [SelectCountryCodeCell class];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(cellClass)];

    self.tableView.sectionIndexColor = [UIColor darkGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor blackColor];
}

- (void)loadDataFromFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    if (jsonData == nil) {
        NSLog(@"===读取code.json失败");
        return;
    }
    NSError *error;
    NSArray *jsonList = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (jsonList == nil || error) {
        NSLog(@"====解析code.json失败");
        return;
    }

    self.codeDict = [NSMutableDictionary dictionary];
    
    NSArray<CountryCode *> *allList = [CountryCode arrayOfModelsFromDictionaries:jsonList error:&error];
    //将城市列表分组
    for (CountryCode *code in allList) {
        NSString *key = @"";
        if (![NSString isNullString:code.en]) {
            key = [code.en substringToIndex:1];
        }
        NSMutableArray *valueList = [self.codeDict objectForKey:key];
        if (valueList == nil) {
            valueList = [NSMutableArray arrayWithObject:code];
            [self.codeDict setObject:valueList forKey:key];
        } else {
            [valueList addObject:code];
        }
    }
    self.codeKeyList = [self.codeDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
}

#pragma mark - action

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source


//显示每组标题索引

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.codeKeyList;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.codeKeyList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [self.codeKeyList objectAtIndex:section];
    NSMutableArray *valueList = [self.codeDict objectForKey:key];
    return valueList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.codeKeyList objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 28.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = UIRGBColor(28, 28, 28, 1);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 90, 28)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [self.codeKeyList objectAtIndex:section];
    [myView addSubview:titleLabel];
    return myView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.codeKeyList objectAtIndex:indexPath.section];
    NSMutableArray *valueList = [self.codeDict objectForKey:key];
    CountryCode *code = [valueList objectAtIndex:indexPath.row];
    
    SelectCountryCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SelectCountryCodeCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = code.en;
    cell.codeLabel.text = [NSString stringWithFormat:@"+%d", code.code];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [self.codeKeyList objectAtIndex:indexPath.section];
    NSMutableArray *valueList = [self.codeDict objectForKey:key];
    CountryCode *code = [valueList objectAtIndex:indexPath.row];
    if (self.callback) {
        self.callback(code);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
