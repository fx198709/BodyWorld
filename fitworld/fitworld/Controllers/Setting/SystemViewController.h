//
//  SystemViewController.h
//  fitworld
//
//  Created by 王巍 on 2021/7/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *logoffBtn;

- (IBAction)logoffbtnClicked:(id)sender;

@end

NS_ASSUME_NONNULL_END
