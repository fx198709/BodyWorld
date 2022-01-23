//
//  BaseRoomViewController.h
//  FFitWorld
//
//  Created by feixiang on 2022/1/23.
//

#import "BaseNavViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseRoomViewController : BaseNavViewController

@property (nonatomic, assign)BOOL needChangeOrientation;
//改变屏幕方向
- (void)changeOrientation;
@end

NS_ASSUME_NONNULL_END
