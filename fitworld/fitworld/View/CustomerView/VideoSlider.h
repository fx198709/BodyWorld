//
//  VideoSlider.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoSlider : UIView
@property (nonatomic, strong)UISlider *slider;
@property (nonatomic, copy) AnyBtnBlock sliderValueChanged;

-(void)createSubview;

@end

NS_ASSUME_NONNULL_END
