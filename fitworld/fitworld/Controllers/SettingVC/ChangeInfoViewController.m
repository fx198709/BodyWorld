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
    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    NSString *valueStr = self.inputField.text;
    if (![NSString isNullString:valueStr] &&  [NSString isNumberString:valueStr]) {
        int h = [valueStr intValue];
        //todo: send
        user.height = h;
        
    }
    
    [self.view showTextNotice:ChineseStringOrENFun(@"修改成功", @"Success changed")];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveNickName {
    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    NSString *valueStr = self.inputField.text;
    if (![NSString isNullString:valueStr]) {
        //todo: send
        user.nickname = valueStr;
    }

    [self.view showTextNotice:ChineseStringOrENFun(@"修改成功", @"Success changed")];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveWeight {
    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    NSString *valueStr = self.inputField.text;
    if (![NSString isNullString:valueStr] &&  [NSString isNumberString:valueStr]) {
        int w = [valueStr intValue];
        //todo: send
        user.weight = w;
    }
    
    [self.view showTextNotice:ChineseStringOrENFun(@"修改成功", @"Success changed")];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
