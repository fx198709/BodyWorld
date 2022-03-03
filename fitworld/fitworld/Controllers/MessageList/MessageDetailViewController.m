//
//  MessageDetailViewController.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/6.
//

#import "MessageDetailViewController.h"
#import "MessageListModel.h"
#import "GroupRoomPrepareViewController.h"
@interface MessageDetailViewController (){
    MessageListModel *messageDetail;
}

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ChineseStringOrENFun(@"消息", @"Notification");
    _contentTextView.text = @"";
    _contentTextView.backgroundColor = UIColor.clearColor;
    self.titleLabel.text = ChineseStringOrENFun(@"课程提醒", @"Course Reminder");
    self.contentTextView.textColor = [UIColor whiteColor];
    self.contentTextView.font = SystemFontOfSize(14);
    _contentTextView.userInteractionEnabled = NO;
    // Do any additional setup after loading the view from its nib.
//    http://1.117.70.210:8091/api/user_msg/detail?id=44804551223609860
    [self getMessageDetailInfo];
}

- (void)createsubBtn{
    NSString *submitString = nil;
    if ([messageDetail.type isEqualToString:@"invite_sub_room"]) {
        submitString = ChineseStringOrENFun(@"去团课", @"OK");
    }
    if ([messageDetail.type isEqualToString:@"friend_require"]) {
        submitString = ChineseStringOrENFun(@"添加好友", @"OK");
    }
    
    if (submitString.length < 1 ) {
        return;
    }
    UIButton *sumbitBtn = [[UIButton alloc] init];
    [self.view addSubview:sumbitBtn];
    [sumbitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentTextView.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(200);
        make.centerX.equalTo(self.view);
    }];
    UIImage *backImage = [UIImage imageNamed:@"action_button_bg_green1"];
    [sumbitBtn setTitle:submitString forState:UIControlStateHighlighted];
    [sumbitBtn setTitle:submitString forState:UIControlStateNormal];
    [sumbitBtn setBackgroundImage:backImage forState:UIControlStateHighlighted];
    [sumbitBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [sumbitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [sumbitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    [sumbitBtn addTarget:self action:@selector(submittedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)submittedBtnClicked{
    if ([messageDetail.type isEqualToString:@"friend_require"]) {
        NSString *user_id = [messageDetail.extended_data objectForKey:@"user_id"];
        if (user_id.length >1) {
            NSDictionary *param = @{@"friend_id": user_id};
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[AFAppNetAPIClient manager] POST:@"friend/agree" parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (CheckResponseObject(responseObject)) {
                    
                    [CommonTools showAlertDismissWithContent:ActionSuccssString control:self];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"] control:self];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [CommonTools showNETErrorcontrol:self];
            }];
        }
        
    }
    if ([messageDetail.type isEqualToString:@"invite_sub_room"]) {
        GroupRoomPrepareViewController *vc =[[GroupRoomPrepareViewController alloc] initWithNibName:@"GroupRoomPrepareViewController" bundle:nil];
        vc.event_id = [messageDetail.extended_data objectForKey:@"event_id"];
        vc.extended_data = messageDetail.extended_data;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)getMessageDetailInfo
{
  
       
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];

        NSDictionary *baddyParams = @{
                               @"id": self.messageID,
                           };
        
        [manager GET:@"user_msg/detail" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (responseObject && responseObject[@"recordset"] ) {
                MessageListModel *messageModel = [[MessageListModel alloc] initWithJSON: responseObject[@"recordset"]];
                self->messageDetail = messageModel;
                self->_timelabel.text = messageModel.updated_atString;
                self->_contentTextView.text = messageModel.content;
                self->_titleLabel.text = messageModel.subject;
                [self createsubBtn];
            }
          
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    
 
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
