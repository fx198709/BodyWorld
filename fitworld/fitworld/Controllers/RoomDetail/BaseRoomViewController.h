//
//  BaseRoomViewController.h
//  FFitWorld
//
//  Created by feixiang on 2022/1/23.
//

#import "BaseNavViewController.h"
#import "Room.h"
//#import <AVFoundation/AVFoundation.h>
#import "MainPanel.h"
#import "SidePanel.h"
#import "VConductorClient.h"
#import "ReportView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseRoomViewController : BaseNavViewController
//进入直播间的前一个vc
//进入直播间的前一个vc
@property(nonatomic, weak)UIViewController * invc;
@property(nonatomic, strong)Room * currentRoom;
@property (nonatomic, assign)BOOL needChangeOrientation;
@property (nonatomic, strong) NSDictionary* mCode;
@property (nonatomic, strong) NSDate *startliveingTime;//第一次获取到流的时间;
@property (nonatomic, strong) SidePanel *mSidePanel; //自己的view
@property (nonatomic, strong) MainPanel* mMainPanel; //教练的view
@property (nonatomic, strong) NSMutableArray* guestPanels;//其他人的

@property (nonatomic, strong) ReportView* reportView;//举报页面，弹出的时候，需要把其他的都关闭，放到视图的最上层


//改变屏幕方向
- (void)changeOrientation;

//离开房间，需要做的事情
- (void)leaveRoomwithCutsomer;

//跳转到下一个页面
- (void)jumpToTrainingvc;

- (void)removeAboveView;

- (int)reachCurrentMainMediaVoice;

- (int)reachGuestMediaVoice;

- (void)changeMainVoice:(int)value;
- (void)changeGuestVoice:(int)value;

- (void)showReportView;

//我的摄像头设置
- (void)myCameraSwitchChanged;
- (void)myMicSwicthChanged;

//baseRoom
//绑定数据
- (void)syncGuestpanelView;

//关闭举报view
- (void)closeReportView;

@end

NS_ASSUME_NONNULL_END
