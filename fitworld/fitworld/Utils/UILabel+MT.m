//
//  UILabel+MT.m
//  FFitWorld
//
//  Created by xiejc on 2021/12/2.
//

#import "UILabel+MT.h"

@implementation UILabel (MT)


- (float)widthForText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:self.font}
                                     context:nil];
    return rect.size.width;
}

- (float)heightForText:(NSString *)text {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:self.font}
                                     context:nil];
    
    return rect.size.height;
}

@end
