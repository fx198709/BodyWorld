//
//  SliderView.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/12.
//

#import <UIKit/UIKit.h>
#import "Room.h"
NS_ASSUME_NONNULL_BEGIN

@interface SliderView : UIView
{
    UIImageView *backview;//背景view
    UIImageView *circleview; //圆点
}
-(void)changeSliderWithData:(Room*)roomData;

@end

NS_ASSUME_NONNULL_END
