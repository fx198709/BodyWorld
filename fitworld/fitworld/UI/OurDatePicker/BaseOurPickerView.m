//
//  BasePickerView.m
//  Ework
//
//  Created by feixiang on 2018/1/29.
//  Copyright © 2018年 crm. All rights reserved.
//

#import "BaseOurPickerView.h"

@implementation BaseOurPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//- (void)addbottomview{
//    //底部按钮视图 对iPhone X 适配
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,height - BottomButtonHeight,width,BottomButtonHeight)];
//    bottomView.userInteractionEnabled = YES;
//    [self addSubview:bottomView];
//    [self bringSubviewToFront:bottomView];
//    UIButton * leftButton = [self createbuttonisLeft:YES];
//    [bottomView addSubview:leftButton];
//    
//    UIButton * rightButton = [self createbuttonisLeft:NO];
//    [bottomView addSubview:rightButton];
//    
//}


- (UIButton *)createbuttonisLeft:(BOOL)isLeft
{
    int width =self.frame.size.width;
    UIButton *vbutton = [[UIButton alloc] init];
    [vbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [vbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    if (isLeft) {
        vbutton.frame = CGRectMake(0, 0, width/2, 49);
        vbutton.backgroundColor = [UIColor colorWithRed:196.0f/255.0f green:196.0f/255.0f blue:206.0f/255.0f alpha:1];
        [vbutton addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = ChineseStringOrENFun(@"取消", @"Cancel");
        [vbutton setTitle:title forState:UIControlStateNormal];
        [vbutton setTitle:title forState:UIControlStateHighlighted];
    }
    else
    {
        vbutton.frame = CGRectMake(width/2, 0, width/2, 49);
        vbutton.backgroundColor = UIColorFromRGB(0x0084FF);
        [vbutton addTarget:self action:@selector(oKPicker) forControlEvents:UIControlEventTouchUpInside];
        NSString *title = ChineseStringOrENFun(@"确定", @"Yes");
        [vbutton setTitle:title forState:UIControlStateNormal];
        [vbutton setTitle:title forState:UIControlStateHighlighted];
    }
    return vbutton;
}

//用来处理警告的
- (void)cancelPicker{
    
}

- (void)oKPicker{
    
}

@end
