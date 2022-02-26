//
//  LogOffViewController.m
//  FFitWorld
//
//  Created by feixiang on 2022/2/26.
//

#import "LogOffViewController.h"

@interface LogOffViewController ()

@end

@implementation LogOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ChineseStringOrENFun(@"申请注销账号", @"Application to Remove Account");
    self.view.backgroundColor = BgGrayColor;
    _contentlabel.numberOfLines = 0;
    _contentlabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentlabel.text = ChineseStringOrENFun(@"为保证你的账号安全，在你提交的注销申请生效前，需同时满足以下条件：", @"For your account safety, the following conditions are to fulfilled at the same time before you submit your application to remove your account.");
    _contentlabel.font = SystemFontOfSize(18);
    _contentlabel.textColor = UIColor.whiteColor;
    
    _titlelabel1.numberOfLines = 0;
    _titlelabel1.lineBreakMode = NSLineBreakByWordWrapping;
    _titlelabel1.text = ChineseStringOrENFun(@"1、账号财产已结清：", @"1、The account assets are well settled.");
    _titlelabel1.font = SystemFontOfSize(16);
    _titlelabel1.textColor = UIColor.whiteColor;
    
    _subTitleLabel1.numberOfLines = 0;
    _subTitleLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    _subTitleLabel1.text = ChineseStringOrENFun(@"没有资产、欠款、未结清的资金和虚拟权益。本账号及通过本账号接入的第三方中，没有未完成活存在争议的服务。", @"No assets, debts, open payables or virtual interest.No open or disputable issues in the account or any third parties connected through the account.");
    _subTitleLabel1.font = SystemFontOfSize(14);
    _subTitleLabel1.textColor = LightGaryTextColor;
    _lineview1.backgroundColor = LineColor;
    
    _titlelabel2.numberOfLines = 0;
    _titlelabel2.lineBreakMode = NSLineBreakByWordWrapping;
    _titlelabel2.text = ChineseStringOrENFun(@"2、账号处于安全状态：", @"2、The account is safe");
    _titlelabel2.font = SystemFontOfSize(16);
    _titlelabel2.textColor = UIColor.whiteColor;
    
    _subTitleLabel2.numberOfLines = 0;
    _subTitleLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    _subTitleLabel2.text = ChineseStringOrENFun(@"账号处于正常使用状态，无被盗风险。", @"The account is normal in use without risk of theft.");
    _subTitleLabel2.font = SystemFontOfSize(14);
    _subTitleLabel2.textColor = LightGaryTextColor;
    _lineview2.backgroundColor = LineColor;
    
    _titlelabel3.numberOfLines = 0;
    _titlelabel3.lineBreakMode = NSLineBreakByWordWrapping;
    _titlelabel3.text = ChineseStringOrENFun(@"3、账号权限解除：", @"3、The account access and permission are canceled");
    _titlelabel3.font = SystemFontOfSize(16);
    _titlelabel3.textColor = UIColor.whiteColor;
    
    _subTitleLabel3.numberOfLines = 0;
    _subTitleLabel3.lineBreakMode = NSLineBreakByWordWrapping;
    _subTitleLabel3.text = ChineseStringOrENFun(@"账号解除与其他产品的授权登陆或绑定关系。", @"The account has canceled authorized access or binding relationship with other products.");
    _subTitleLabel3.font = SystemFontOfSize(14);
    _subTitleLabel3.textColor = LightGaryTextColor;
    _lineview3.backgroundColor = LineColor;
    
    _titlelabel4.numberOfLines = 0;
    _titlelabel4.lineBreakMode = NSLineBreakByWordWrapping;
    _titlelabel4.text = ChineseStringOrENFun(@"4、账号无任何纠纷，包括投诉举报", @"4、The account has not disputes, nor complaints or reports");
    _titlelabel4.font = SystemFontOfSize(16);
    _titlelabel4.textColor = UIColor.whiteColor;
    
    
    [_agreenBtn addTarget:self action:@selector(changeState) forControlEvents:UIControlEventTouchUpInside];
    
    
    _agreenLabel.numberOfLines = 0;
    _agreenLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _agreenLabel.text = ChineseStringOrENFun(@"我已阅读并同意", @"I have read and agree on the");
    _agreenLabel.font = SystemFontOfSize(14);
    _agreenLabel.textColor = UIColor.whiteColor;
    
    NSString *logoffBtnTitle = ChineseStringOrENFun(@"申请注销", @"Submit");
    [_logoffBtn setTitle:logoffBtnTitle forState:UIControlStateNormal];
    [_logoffBtn setTitle:logoffBtnTitle forState:UIControlStateHighlighted];
    _logoffBtn.layer.cornerRadius = 5;
    _logoffBtn.clipsToBounds = YES;
    [self changeviewState];
    
    NSString *jumpTitle = ChineseStringOrENFun(@"注销协议", @"Removal Agreement");
    [_jumpUrlBtn setTitle:jumpTitle forState:UIControlStateNormal];
    [_jumpUrlBtn setTitle:jumpTitle forState:UIControlStateHighlighted];
    [_jumpUrlBtn setTitleColor:UIRGBColor(70, 104, 213, 1) forState:UIControlStateNormal];
    [_jumpUrlBtn setTitleColor:UIRGBColor(70, 104, 213, 1) forState:UIControlStateHighlighted];
    // Do any additional setup after loading the view from its nib.
}

- (void)changeState{
    hasSelected = !hasSelected;
    [self changeviewState];
}

- (void)changeviewState{
    UIImage *image = [UIImage imageNamed:@"white-unselect"];
    _logoffBtn.backgroundColor = UIColor.grayColor;
    if (hasSelected) {
        image = [UIImage imageNamed:@"invite_friends_user_list_item_selected"];
        _logoffBtn.backgroundColor = BgGreenColor;
    }
    [_agreenBtn setTitle:@"" forState:UIControlStateNormal];
    [_agreenBtn setTitle:@"" forState:UIControlStateHighlighted];
    [_agreenBtn setImage:image forState:UIControlStateNormal];
    [_agreenBtn setImage:image forState:UIControlStateHighlighted];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutBtnClciked:(id)sender {
    
//    agreenBtn
    if (!hasSelected) {
        return;
    }
    NSTimeInterval recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *time = [[NSString alloc] initWithFormat:@"%f", recordTime];
    NSDictionary *param =@{@"time":time};
    [MTHUD showLoadingHUD];
    [[AFAppNetAPIClient manager] POST:@"user/cancel" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        [MTHUD hideHUD];
        [MTHUD showDurationNoticeHUD:ActionSuccssString];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self showChangeFailedError:error];
        NSString *msg = error == nil ? ChangeErrorMsg : error.localizedDescription;
        [MTHUD showDurationNoticeHUD:msg];
    }];
}
@end
