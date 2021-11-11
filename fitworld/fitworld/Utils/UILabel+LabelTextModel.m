//
//  UILabel+GeneralTypeModel.m
//  BitAutoCRM
//
//  Created by 费翔 on 15/4/24.
//  Copyright (c) 2015年 crm. All rights reserved.
//

#import "UILabel+LabelTextModel.h"

@implementation UILabel(LabelTextModel)

- (void)changeLabelWithModel:(LabelTextModel*)model
{
    self.text = model.labelString;
    if ([model.labelString isEqualToString:@""] || model.labelString == nil) {
        self.text = @" ";
    }
    if ([model.stringColor isKindOfClass:[NSString class]]) {
        if (model.stringColor.length >2) {
            self.textColor = [CommonTools colorWithHexString:model.stringColor];
        }
    }
    
    if ([model.stringFont isKindOfClass:[NSString class]]) {
        //一般字的大小不会超过15
        if (model.stringFont.length >0 && model.stringFont.length <=3) {
            if (model.stringFont.integerValue > 100) {
                self.font = [UIFont boldSystemFontOfSize:model.stringFont.integerValue - 100];
            }
            else
            {
                if (![model.stringFont isEqualToString:@" "]) {
                    self.font = [UIFont systemFontOfSize:model.stringFont.integerValue];
                }
            }
            
        }
    }

    self.textAlignment = model.alignmentType;
    
}

- (CGSize)sizeForLineHeight
{
    if (self.text.length < 1) {
        return CGSizeZero;
    }
//    @{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0] }
    CGSize size =  [self.text sizeWithAttributes:@{ NSFontAttributeName : self.font}];
    return size;
}


@end
