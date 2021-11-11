//
//  ChangeInfoViewController.m
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import "ChangeInfoViewController.h"

@interface ChangeInfoViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@end

@implementation ChangeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.inputField becomeFirstResponder];

    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;

    NSString *changeTitle = @"";
    switch (self.changeType) {
        case ChangeTypeEnum_Height:
            self.inputField.keyboardType = UIKeyboardTypeNumberPad;
            self.inputField.text = IntToString(user.height);
            changeTitle = ChineseStringOrENFun(@"身高", @"Height");
            break;
        case ChangeTypeEnum_Weight:
            self.inputField.keyboardType = UIKeyboardTypeNumberPad;
            self.inputField.text = IntToString(user.weight);
            changeTitle = ChineseStringOrENFun(@"体重", @"Weight");
            break;
        case ChangeTypeEnum_NickName:
            changeTitle = ChineseStringOrENFun(@"昵称", @"Nickname");
            self.inputField.text = user.nickname;
            self.inputField.keyboardType = UIKeyboardTypeDefault;
            break;
        default:
            break;
    }
    
    NSString *navTitle = ChineseStringOrENFun(@"修改", @"Change");
    self.navigationItem.title = [[navTitle stringByAppendingString:changeTitle] capitalizedString];
    self.titleLabel.text = changeTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:ChineseStringOrENFun(@"保存", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(clickSave)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
}


//点击保存
- (void)clickSave {
    [self.inputField resignFirstResponder];
    switch (self.changeType) {
        case ChangeTypeEnum_Height:
            [self saveHeight];
            break;
        case ChangeTypeEnum_Weight:
            [self saveWeight];
            break;
        case ChangeTypeEnum_NickName:
            [self saveNickName];
            break;
        default:
            break;
    }
}

- (void)saveHeight {
    NSString *valueStr = self.inputField.text;
    if (![NSString isNullString:valueStr] &&  [NSString isNumberString:valueStr]) {
        NSDictionary *param = @{@"height" : valueStr};
        [self changeUserInfoFromServer:param];
        
    }
}

- (void)saveNickName {
    NSString *valueStr = self.inputField.text;
    if (![NSString isNullString:valueStr]) {
        NSDictionary *param = @{@"nickname" : valueStr};
        [self changeUserInfoFromServer:param];
    }
}

- (void)saveWeight {
    NSString *valueStr = self.inputField.text;
    if (![NSString isNullString:valueStr] &&  [NSString isNumberString:valueStr]) {
        NSDictionary *param = @{@"weight" : valueStr};
        [self changeUserInfoFromServer:param];
    }
}



//发送修改信息到服务器
- (void)changeUserInfoFromServer:(NSDictionary *)param {
    AFAppNetAPIClient *manager = [AFAppNetAPIClient manager];
    [MTHUD showLoadingHUD];
    [manager PUT:@"user" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        NSLog(@"====respong:%@", responseObject);
        if ([responseObject objectForKey:@"recordset"]) {
            [APPObjOnce sharedAppOnce].currentUser = [[UserInfo alloc] initWithJSON:responseObject[@"recordset"]];
            [self showSuccessNotice];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MTHUD hideHUD:YES completedBlock:^{
            [self showChangeFailedError:error];
        }];
    }];
}

- (void)showSuccessNotice {
    NSString *msg = ChineseStringOrENFun(@"修改成功", @"Success changed");
    [MTHUD showDurationNoticeHUD:msg animated:YES completedBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)showChangeFailedError:(NSError *)error {
    NSString *msg = error == nil ? ChineseStringOrENFun(@"修改失败", @"Change failed") : error.localizedDescription;
    [MTHUD showDurationNoticeHUD:msg];
}

@end
