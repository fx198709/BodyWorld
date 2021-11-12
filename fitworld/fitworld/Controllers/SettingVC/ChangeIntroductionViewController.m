//
//  ChangeIntroductionViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/11.
//

#import "ChangeIntroductionViewController.h"

@interface ChangeIntroductionViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *inputField;


@end

@implementation ChangeIntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.inputField becomeFirstResponder];
    
    self.navigationItem.title = ChineseStringOrENFun(@"修改介绍", @"Change Introduction");
    self.titleLabel.text = ChineseStringOrENFun(@"介绍", @"Introduction");
    
    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    self.inputField.text = user.introduction;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:ChineseStringOrENFun(@"保存", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(clickSave)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
}

//点击保存
- (void)clickSave {
    [self.inputField resignFirstResponder];

    NSString *valueStr = self.inputField.text;
    if (![NSString isNullString:valueStr]) {
        NSDictionary *param = @{@"introduction": valueStr};
        [self changeUserInfoFromServer:param];
    }
}


//发送修改信息到服务器
- (void)changeUserInfoFromServer:(NSDictionary *)param {
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] PUT:@"user" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        if ([responseObject objectForKey:@"recordset"]) {
            [APPObjOnce sharedAppOnce].currentUser = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"]];
            [self showSuccessNoticeAndPopVC];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showChangeFailedError:error];
    }];
}




@end
