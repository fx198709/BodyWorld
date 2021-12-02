//
//  StarView.m
//  FFitWorld
//
//  Created by xiejc on 2021/12/2.
//

#import "StarView.h"

@interface StarView ()

@end

@implementation StarView

- (void)setScore:(NSInteger)score {
    NSArray *subView = self.subviews;
    if (subView.count == 0) {
        return;
    }
    
    UIImage *normalImage = [UIImage imageNamed:@"btn-start-normal"];
    UIImage *hImage = [UIImage imageNamed:@"btn-start-selected"];
    
    int hNum = score % subView.count;
    for (int i=0; i<subView.count; i++) {
        UIView *aView = [subView objectAtIndex:i];
        if ([aView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)aView;
            UIImage *img = i < hNum ? hImage : normalImage;
            [btn setImage:img forState:UIControlStateNormal];
        }
    }
}

@end
