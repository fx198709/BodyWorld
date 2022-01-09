//
//  SelectClassHeadview.m
//  FFitWorld
//
//  Created by feixiang on 2021/10/30.
//

#import "SelectClassHeadview.h"
#define LittlegreenColor UIRGBColor(52, 160, 89, 1);
@implementation SelectClassHeadview
-(void)awakeFromNib{
    [super awakeFromNib];
    NSString * step1String = ChineseStringOrENFun(@"选择课程", @"Select your training");
    NSString * step2String = ChineseStringOrENFun(@"设置时间", @"Set time");
    NSString * step3String = ChineseStringOrENFun(@"邀请好友", @"invite friends");
    _steplabel1.text = step1String;
    _steplabel2.text = step2String;
    _steplabel3.text = step3String;

}

- (void)changeStep:(int)step{
  

    if(step == 2){
        _linebackview2.backgroundColor = LittlegreenColor;
        _linebackview3.backgroundColor = LittlegreenColor;
        _image2view.image = [UIImage imageNamed:@"choose_course_foot_logo2_selected"];
    }
    if(step == 3){
        _linebackview2.backgroundColor = LittlegreenColor;
        _linebackview3.backgroundColor = LittlegreenColor;
        _linebackview4.backgroundColor = LittlegreenColor;
        _image2view.image = [UIImage imageNamed:@"choose_course_foot_logo2_selected"];
        _image3view.image = [UIImage imageNamed:@"choose_course_foot_logo3_selected"];

//        _linebackview4.backgroundColor = LittlegreenColor;
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
