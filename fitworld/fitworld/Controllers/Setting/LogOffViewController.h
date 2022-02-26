//
//  LogOffViewController.h
//  FFitWorld
//
//  Created by feixiang on 2022/2/26.
// 注销

#import "BaseNavViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogOffViewController : BaseNavViewController{
    BOOL hasSelected;
}
@property (weak, nonatomic) IBOutlet UILabel *contentlabel;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel1;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel1;
@property (weak, nonatomic) IBOutlet UIView *lineview1;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel2;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel2;
@property (weak, nonatomic) IBOutlet UIView *lineview2;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel3;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel3;
@property (weak, nonatomic) IBOutlet UIView *lineview3;
@property (weak, nonatomic) IBOutlet UILabel *titlelabel4;

@property (weak, nonatomic) IBOutlet UIButton *logoffBtn;
- (IBAction)logoutBtnClciked:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *agreenBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreenLabel;
@property (weak, nonatomic) IBOutlet UIButton *jumpUrlBtn;

@end

NS_ASSUME_NONNULL_END
