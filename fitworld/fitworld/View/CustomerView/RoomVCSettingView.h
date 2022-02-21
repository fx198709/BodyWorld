//
//  RoomVCSettingView.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/26.
//

#import <UIKit/UIKit.h>
#import "VideoSlider.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomVCSettingView : UIView
@property (weak, nonatomic) IBOutlet UILabel *mainVoiceLabel;
@property (weak, nonatomic) IBOutlet VideoSlider *mainVoiceSlider;
@property (weak, nonatomic) IBOutlet UILabel *otherVoiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *mycamare;
@property (weak, nonatomic) IBOutlet UISwitch *myCameraSwitch;
@property (weak, nonatomic) IBOutlet UILabel *myMicLabel;
@property (weak, nonatomic) IBOutlet UISwitch *myMicSwicth;
@property (weak, nonatomic) IBOutlet UILabel *notDisturbLabel;
@property (weak, nonatomic) IBOutlet UISwitch *notdisturbSwitch;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet VideoSlider *othervoiceSlider;

@property (nonatomic, copy) AnyBtnBlock myCameraSwitchChanged;
@property (nonatomic, copy) AnyBtnBlock myMicSwicthChanged;
@property (nonatomic, copy) AnyBtnBlock notdisturbSwitchChanged;
@property (nonatomic, copy) AnyBtnBlock cancelBtnClickedBlock;
@property (nonatomic, copy) AnyBtnBlock orientationClickedBlock; //强制横竖屏

@property (nonatomic, assign)id parentDelegate;//父vc，获取视频音量的


@property (weak, nonatomic) IBOutlet UIButton *changeOrientationBtn;//强制横竖屏

//设置父视图的代理
- (void)changeDeleagte:(id)deleagte;

@end

NS_ASSUME_NONNULL_END
