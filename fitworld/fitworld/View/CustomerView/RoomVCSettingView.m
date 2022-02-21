//
//  RoomVCSettingView.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/26.
//

#import "RoomVCSettingView.h"
#import "BaseRoomViewController.h"
@implementation RoomVCSettingView

-(void)awakeFromNib{
    [super awakeFromNib];
    _mainVoiceLabel.text = ChineseStringOrENFun(@"视频音量", @"Video volume");
    _otherVoiceLabel.text = ChineseStringOrENFun(@"他人语音音量", @"Video volume");
    _mycamare.text = ChineseStringOrENFun(@"我的摄像头", @"My Camera");
    _myMicLabel.text  = ChineseStringOrENFun(@"我的麦克", @"My Mic");
    _notDisturbLabel.text = ChineseStringOrENFun(@"免打扰", @"Do Not Disturb");
    NSString *btnTitle = ChineseStringOrENFun(@"确认", @"OK");
    [_cancelBtn setTitle:btnTitle forState:UIControlStateNormal];
    [_cancelBtn setTitle:btnTitle forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *orientationTitle = ChineseStringOrENFun(@"横竖屏切换", @"Screen change");
    [_changeOrientationBtn setTitle:orientationTitle forState:UIControlStateNormal];
    [_changeOrientationBtn setTitle:orientationTitle forState:UIControlStateHighlighted];
    [_changeOrientationBtn addTarget:self action:@selector(orientationBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _changeOrientationBtn.layer.cornerRadius = 20;
    _changeOrientationBtn.clipsToBounds = YES;
    _cancelBtn.layer.cornerRadius = 20;
    _cancelBtn.clipsToBounds = YES;
    _mainVoiceSlider.backgroundColor = UIColor.clearColor;
    [_mainVoiceSlider createSubview];
    BaseRoomViewController *baseRoom = (BaseRoomViewController *)self.parentDelegate;
    _mainVoiceSlider.sliderValueChanged = ^(id clickModel) {
        if (baseRoom) {
            [baseRoom changeMainVoice:[clickModel intValue]];
        };
    };
    
    _othervoiceSlider.backgroundColor = UIColor.clearColor;
    [_othervoiceSlider createSubview];
    _othervoiceSlider.sliderValueChanged = ^(id clickModel) {
        if (baseRoom) {
            [baseRoom changeGuestVoice:[clickModel intValue]];
        };
    };
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

- (void)orientationBtnClicked{
    if (self.orientationClickedBlock) {
        self.orientationClickedBlock(NULL);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//每次进入的时候，设置一下基础信息
- (void)changeDeleagte:(id)deleagte{
    self.parentDelegate = deleagte;
    BaseRoomViewController *baseRoom = (BaseRoomViewController *)deleagte;
    int mainVoiceSlidervalue = [baseRoom reachCurrentMainMediaVoice];//mainVoiceSlider
    int gustVoiceSlidervalue = [baseRoom reachGuestMediaVoice];//mainVoiceSlider
//    [self.mainVoiceSlider chan ]
    self.mainVoiceSlider.slider.value =mainVoiceSlidervalue;
    self.othervoiceSlider.slider.value =gustVoiceSlidervalue;

}


@end
