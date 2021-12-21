//
//  PBTextWithPlaceHoldViewDelegate.h
//  BitAutoCRM
//
//  Created by feixiang on 15/11/19.
//  Copyright © 2015年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PBTextWithPlaceHoldView.h"
@interface PBTextWithPlaceHoldViewDelegate : NSObject<UITextViewDelegate>

@property (nonatomic, assign) float maxnumber; //最大的字数
@property (nonatomic, assign) BOOL needChangeSize;//是否需要改变frame

@property (nonatomic, assign) BOOL isOnlyEnglish;//是否需要改变frame


//委托给外面判断，不需要做太多的处理
@property (nonatomic, copy)BOOL(^shouldChangeTextInRange)(PBTextWithPlaceHoldView *placeHoldTextView,NSRange range,NSString *text);

//中间的判断，如果为否，就不继续往下判断，如果是yes，就继续往下判断
@property (nonatomic, copy)BOOL(^middleChangeTextInRange)(PBTextWithPlaceHoldView *placeHoldTextView,NSRange range,NSString *text);


@property (nonatomic, copy)void(^ChangeHeight)(int height,PBTextWithPlaceHoldView *placeHoldTextView);

//占位label隐藏
@property (nonatomic, copy) void(^placeHoldLabelHiddenBlock)(BOOL hide);

//textview 结束编辑
@property (nonatomic, copy) void(^textViewDidEndEditing)(PBTextWithPlaceHoldView *textView);

//textview 结束编辑
@property (nonatomic, copy) void(^textViewDidChange)(PBTextWithPlaceHoldView *textView);
//文字太长的回调
@property (nonatomic, copy) void(^textIstoolong)(PBTextWithPlaceHoldView *textView);


@end
