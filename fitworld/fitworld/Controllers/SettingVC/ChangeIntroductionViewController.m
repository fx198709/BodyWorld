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
    UserInfo *user = [APPObjOnce sharedAppOnce].currentUser;
    NSString *valueStr = self.inputField.text;
    if (![NSString isNullString:valueStr]) {
        //todo: send
        user.introduction = valueStr;
    }

    [self.view showTextNotice:ChineseStringOrENFun(@"修改成功", @"Success changed")];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
