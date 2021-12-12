//
//  SliderView.m
//  FFitWorld
//
//  Created by feixiang on 2021/12/12.
//

#import "SliderView.h"


@implementation SliderView

-(void)changeSliderWithData:(Room*)roomData{
    //    已经开始
    int difTime = [[NSDate date] timeIntervalSince1970] - roomData.start_time;
    if (difTime > 0 ) {
        int startx = 1;
        int with = self.frame.size.width-self.frame.size.height-startx*2;
        if (!backview) {
            backview = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.height/2+startx, self.frame.size.height/3, with, self.frame.size.height/3)];
            backview.layer.cornerRadius = backview.frame.size.height/2;
            backview.clipsToBounds = YES;
            backview.image = [UIImage imageNamed:@"activity_p2c_live_vedio_process"];
            backview.contentMode = UIViewContentModeScaleAspectFill;
            [self addSubview:backview];
            circleview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"activity_p2c_live_vedio_process_dot"]];
            circleview.frame = CGRectMake(startx, 0, self.frame.size.height, self.frame.size.height);
            circleview.layer.cornerRadius = circleview.frame.size.height/2;
            circleview.clipsToBounds = YES;
            [self addSubview:circleview];
        }
        if (difTime < roomData.duration*60) {
            int realStartx = startx+ difTime*with/roomData.duration/60;
            circleview.x = realStartx;
        }else{
            circleview.x =startx+with;
        }
    }
    
    
}

@end
