//
//  MessageDetailViewController.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/6.
//

#import "MessageDetailViewController.h"
#import "MessageListModel.h"
@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ChineseStringOrENFun(@"消息", @"MESSAGE");
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
                self->_timelabel.text = messageModel.updated_atString;
                self->_contentTextView.text = messageModel.content;
                self->_titleLabel.text = messageModel.subject;
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
