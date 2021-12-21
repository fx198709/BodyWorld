//
//  PBTextWithPlaceHoldView.m
//  PurchaseCarBussiness
//
//  Created by lirihuang on 14-5-26.
//  Copyright (c) 2014年 bitcar . All rights reserved.
//

#import "PBTextWithPlaceHoldView.h"
#import "Masonry.h"
@implementation PBTextWithPlaceHoldView


- (void)setDefaultAttributes:(NSDictionary *)defaultAttributes
{
    self.typingAttributes = defaultAttributes;
    _defaultAttributes = defaultAttributes;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createPlaceHoldLabel];
//        _placeHoldLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, -2, 286, 40)];
//        [_placeHoldLabel setBackgroundColor:[UIColor clearColor]];
//        _placeHoldLabel.numberOfLines = 0;
//        _placeHoldLabel.textColor = UIColorFromRGB(0x98add9);
//        [self addSubview:_placeHoldLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self createPlaceHoldLabel];
}

//
- (void)createAlertLabel{
    if (_alertLabel == nil) {
        //        int startX = self.frame.origin.x;
        //        _placeHoldLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 7, ScreenWidth - 4*2-2*startX, 20)];
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        [self addSubview:_alertLabel];
        _alertLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(4);
            make.top.equalTo(self.mas_top).offset(7);
            make.right.equalTo(self.mas_right).offset(4);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
    }
}



- (void)createPlaceHoldLabel
{
    if (_placeHoldLabel == nil) {
//        int startX = self.frame.origin.x;
//        _placeHoldLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 7, ScreenWidth - 4*2-2*startX, 20)];
        _placeHoldLabel = [[UILabel alloc] initWithFrame:CGRectZero];

        [self addSubview:_placeHoldLabel];
        _placeHoldLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_placeHoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(4);
            make.top.equalTo(self.mas_top).offset(7);
            make.right.equalTo(self.mas_right).offset(4);
            make.centerX.equalTo(self.mas_centerX);
        }];
        [_placeHoldLabel setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_placeHoldLabel setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
        [_placeHoldLabel setBackgroundColor:[UIColor clearColor]];
        _placeHoldLabel.numberOfLines = 0;
        _placeHoldLabel.textColor = LittleBgGrayColor;
        _placeHoldLabel.font = SystemFontOfSize(16);
        self.font = SystemFontOfSize(16);
    }
    [self addSubview:_placeHoldLabel];


}

- (void)setPlaceHoldTextColor:(UIColor *)placeHoldTextColor{
    [self createPlaceHoldLabel];

    _placeHoldLabel.textColor = placeHoldTextColor;
}

- (void)setplaceHoldLabelTextFont:(UIFont *)textFont{
    [self createPlaceHoldLabel];
    _placeHoldLabel.font = textFont;
}

- (void)setPlaceHoldString:(NSString *)placeHoldString{
    [self createPlaceHoldLabel];
//    [self layoutIfNeeded];
//    if (self.frame.size.width < ScreenWidth/2) {
//    }
//    else{
//        _placeHoldLabel.frame = CGRectMake(4, 7, self.frame.size.width - 4*2, 20);
//
//    }
    _placeHoldLabel.text = placeHoldString;
    
//    NSDictionary *dict = @{NSFontAttributeName : _placeHoldLabel.font};
//    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
//    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
//    CGSize size =  [placeHoldString boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
//    if (size.width > _placeHoldLabel.frame.size.width) {
//        CGRect oldframe = _placeHoldLabel.frame;
//        _placeHoldLabel.frame = CGRectMake(oldframe.origin.x, oldframe.origin.y, oldframe.size.width, 40);
//    }
}


- (NSString*)reachContentText
{
    
    return nil;
}

- (void)changeTextViewText:(NSString*)text{
    if (text.length >0) {
        self.text = text;
        self.placeHoldLabel.hidden = YES;
    }
}

- (void)changeAttrTextViewText:(NSAttributedString*)attrtext{
    if (attrtext.string.length >0) {
        self.attributedText = attrtext;
        self.placeHoldLabel.hidden = YES;
    }
}


@end
