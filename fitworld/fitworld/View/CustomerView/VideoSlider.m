//
//  VideoSlider.m
//  FFitWorld
//
//  Created by feixiang on 2021/11/25.
//

#import "VideoSlider.h"

@implementation VideoSlider

- (void)createSubview{
    int with = ScreenWidth - 60;//self.frame.size.width;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,10, with,10)];
    imageview.image = [UIImage imageNamed:@"activity_p2c_live_vedio_process"];
    [self addSubview:imageview];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, with, 30)];
    _slider.maximumValue = 10 ;
    _slider.value  = 0 ;
    _slider.continuous = YES;// 设置可连续变化
    //设置已经滑过一端滑动条颜色
    _slider.minimumTrackTintColor= [UIColor clearColor] ;
    //设置未滑过一端滑动条颜色
    _slider.maximumTrackTintColor=[UIColor clearColor];
//        _slider.thumbTintColor = UIColor.greenColor;
    //设置滑块图片背景
    [_slider setThumbImage:[UIImage imageNamed:@"activity_p2c_live_vedio_process_dot"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"activity_p2c_live_vedio_process_dot"] forState:UIControlStateHighlighted];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    [_slider addTarget:self action:@selector(sliderClicked:) forControlEvents:UIControlEventTouchUpInside];// 针对值变化添加响应方法
    [self addSubview:_slider];
    _slider.backgroundColor = UIColor.clearColor;
}
// slider变动时改变label值
- (void)sliderClicked:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int with = self.frame.size.width;
    int dif = slider.value;
     
}


// slider变动时改变label值
- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    int with = self.frame.size.width;
    int dif = slider.value;
    if (self.sliderValueChanged) {
        self.sliderValueChanged([NSNumber numberWithInt:dif]);
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
