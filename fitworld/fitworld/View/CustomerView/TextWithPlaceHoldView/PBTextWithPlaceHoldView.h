//
//  PBTextWithPlaceHoldView.h
//  PurchaseCarBussiness
//
//  Created by lirihuang on 14-5-26.
//  Copyright (c) 2014年 bitcar . All rights reserved.
//

#import <UIKit/UIKit.h>
#define Heightfor14OneLine 33  //14号字，一行的时候，textview显示的高度
@interface PBTextWithPlaceHoldView : UITextView
@property (nonatomic,strong)UILabel *placeHoldLabel;
@property (nonatomic,copy)NSString *placeHoldString;
@property (nonatomic,strong)UILabel *alertLabel; //警告用的label
@property (nonatomic, assign) BOOL showAlertLabel;//


@property(nonatomic,strong)UIFont *textFont;
@property(nonatomic,strong)UIColor *placeHoldTextColor;
@property(nonatomic,strong)NSDictionary *defaultAttributes;

@property(nonatomic,assign)BOOL useAttributedText; //这个view输入的时候 会使用AttributedText

- (void)changeTextViewText:(NSString*)text;

- (void)changeAttrTextViewText:(NSAttributedString*)attrtext;

- (NSString*)reachContentText;
@end
