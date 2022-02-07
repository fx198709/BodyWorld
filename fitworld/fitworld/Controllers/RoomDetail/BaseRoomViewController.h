//
//  BaseRoomViewController.h
//  FFitWorld
//
//  Created by feixiang on 2022/1/23.
//

#import "BaseNavViewController.h"
#import "Room.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseRoomViewController : BaseNavViewController
//进入直播间的前一个vc
//进入直播间的前一个vc
@property(nonatomic, weak)UIViewController * invc;
@property(nonatomic, strong)Room * currentRoom;
@property (nonatomic, assign)BOOL needChangeOrientation;
@property (nonatomic, strong) NSDictionary* mCode;
@property (nonatomic, strong) NSDate *startliveingTime;//第一次获取到流的时间;




//改变屏幕方向
- (void)changeOrientation;

//离开房间，需要做的事情
- (void)leaveRoomwithCutsomer;

//跳转到下一个页面
- (void)jumpToTrainingvc;

- (void)removeAboveView;
@end

NS_ASSUME_NONNULL_END
