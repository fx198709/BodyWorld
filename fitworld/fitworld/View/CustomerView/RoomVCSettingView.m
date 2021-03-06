//
//  RoomVCSettingView.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/26.
//

#import "RoomVCSettingView.h"

@implementation RoomVCSettingView

-(void)awakeFromNib{
    [super awakeFromNib];
    _mainVoiceLabel.text = ChineseStringOrENFun(@"视频音量", @"Video volume");
    _otherVoiceLabel.text = ChineseStringOrENFun(@"他人语音音量", @"Video volume");
    _mycamare.text = ChineseStringOrENFun(@"我的摄像头", @"My Camera");
    _myMicLabel.text  = ChineseStringOrENFun(@"我的麦克", @"My Mic");
    _notDisturbLabel.text = ChineseStringOrENFun(@"免打扰", @"Do Not Disturb");
    NSString *btnTitle = ChineseStringOrENFun(@"退出", @"OK");
    [_cancelBtn setTitle:btnTitle forState:UIControlStateNormal];
    [_cancelBtn setTitle:btnTitle forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.layer.cornerRadius = 20;
    _cancelBtn.clipsToBounds = YES;
    _mainVoiceSlider.backgroundColor = UIColor.clearColor;
    [_mainVoiceSlider createSubview];
    
    _othervoiceSlider.backgroundColor = UIColor.clearColor;
    [_othervoiceSlider createSubview];
    
    _myCameraSwitch.on = YES;
    [_myCameraSwitch addTarget:self action:@selector(myCameraSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    _myMicSwicth.on = YES;
    [_myMicSwicth addTarget:self action:@selector(myMicSwicthValueChanged:) forControlEvents:UIControlEventValueChanged];

    _notdisturbSwitch.on = NO;
    [_notdisturbSwitch addTarget:self action:@selector(notdisturbSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.backgroundColor = UIRGBColor(52, 52, 52, 0.7);

}

- (void)myCameraSwitchValueChanged:(UISwitch*)switchControl{
    if (self.myCameraSwitchChanged) {
        self.myCameraSwitchChanged([NSNumber numberWithBool:switchControl.on]);
    }
}

- (void)myMicSwicthValueChanged:(UISwitch*)switchControl{
    if (self.myMicSwicthChanged) {
        self.myMicSwicthChanged([NSNumber numberWithBool:switchControl.on]);
    }
}
- (void)notdisturbSwitchValueChanged:(UISwitch*)switchControl{
    if (self.notdisturbSwitchChanged) {
        self.notdisturbSwitchChanged([NSNumber numberWithBool:switchControl.on]);
    }
}

- (void)cancelBtnClicked{
    if (self.cancelBtnClickedBlock) {
        self.cancelBtnClickedBlock(NULL);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
