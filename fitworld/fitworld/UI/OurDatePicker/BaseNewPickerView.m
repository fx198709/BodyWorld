//
//  BasePickerView.m
//  Ework
//
//  Created by Yiche on 2019/9/18.
//  Copyright © 2019 crm. All rights reserved.
//

#import "BaseNewPickerView.h"

@implementation BaseNewPickerView

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
        [vbutton setTitle:@"取消" forState:UIControlStateNormal];
        [vbutton setTitle:@"取消" forState:UIControlStateHighlighted];
    }
    else
    {
        vbutton.frame = CGRectMake(width/2, 0, width/2, 49);
        vbutton.backgroundColor = UIColorFromRGB(0x0084FF);
        [vbutton addTarget:self action:@selector(oKPicker) forControlEvents:UIControlEventTouchUpInside];
        [vbutton setTitle:@"确定" forState:UIControlStateNormal];
        [vbutton setTitle:@"确定" forState:UIControlStateHighlighted];
    }
    return vbutton;
}

//用来处理警告的
- (void)cancelPicker{
    
}

- (void)oKPicker{
    
}

@end
