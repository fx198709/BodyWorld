//
//  UILabel+MTCalender.m
//  MTCalender
//
//  Created by Tina on 2019/3/24.
//  Copyright © 2019年 Tina. All rights reserved.
//

#import "UILabel+MTCalender.h"

@implementation UILabel (MTCalender)

- (void)mt_setWithCornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

- (void)mt_resetCornerRadius {
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = 0;
}
@end
