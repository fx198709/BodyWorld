//
//  SendMessageObj.m
//  FFitWorld
//
//  Created by feixiang on 2021/12/13.
//

#import "SendMessageObj.h"

@implementation SendMessageObj
//- (void)sendMessage{
//    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
//    if (messageClass != nil) {
//        // Check whether the current device is configured for sending SMS messages
//        if ([messageClass canSendText]) {
//            [self displaySMSComposerSheet];
//        }
//        else {
//            [UIAlertView quickAlertWithTitle:@"设备没有短信功能" messageTitle:nil dismissTitle:@"关闭"];
//        }
//    }
//    else {
//        [UIAlertView quickAlertWithTitle:@"iOS版本过低,iOS4.0以上才支持程序内发送短信" messageTitle:nil dismissTitle:@"关闭"];
//    }
//}
//
//- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
//                didFinishWithResult:(MessageComposeResult)result {
//
//   switch (result)
//   {
//       case MessageComposeResultCancelled:
//           LOG_EXPR(@”Result: SMS sending canceled”);
//           break;
//       case MessageComposeResultSent:
//           LOG_EXPR(@”Result: SMS sent”);
//           break;
//       case MessageComposeResultFailed:
//           [UIAlertView quickAlertWithTitle:@"短信发送失败" messageTitle:nil dismissTitle:@"关闭"];
//           break;
//       default:
//           LOG_EXPR(@”Result: SMS not sent”);
//           break;
//   }
//   [self dismissModalViewControllerAnimated:YES];
//}

@end
