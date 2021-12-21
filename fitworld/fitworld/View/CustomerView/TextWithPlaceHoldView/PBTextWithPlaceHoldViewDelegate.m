//
//  PBTextWithPlaceHoldViewDelegate.m
//  BitAutoCRM
//
//  Created by feixiang on 15/11/19.
//  Copyright © 2015年 crm. All rights reserved.
//

#import "PBTextWithPlaceHoldViewDelegate.h"

@implementation PBTextWithPlaceHoldViewDelegate

#pragma mark-UITextViewDelegate

- (id)init{
    self = [super init];
    if (self) {
        _maxnumber = INT16_MAX;
    }
    return self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidEndEditing:(PBTextWithPlaceHoldView *)textView{
    if (textView.defaultAttributes.allKeys>0) {
        textView.typingAttributes = textView.defaultAttributes;
    }
    
    if (self.textViewDidEndEditing) {
        self.textViewDidEndEditing(textView);
    }
    
}




- (void)textViewDidChange:(PBTextWithPlaceHoldView *)textView
{
    if (textView.defaultAttributes.allKeys>0) {
        textView.typingAttributes = textView.defaultAttributes;
    }
    if (textView.text.length > 0) {
        textView.placeHoldLabel.hidden = YES;
        if (self.placeHoldLabelHiddenBlock) {
            self.placeHoldLabelHiddenBlock(YES);
        }
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (!(selectedRange && pos)) {
        [self stringByString:textView.text success:^(bool isTooLong, NSString *resultString) {
            if (isTooLong) {
                //                UIView *window = [CommonTools mainWindow];
                //                UIView *redview = [[UIView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, 30)];
                //                [window addSubview:redview];
                //                redview.backgroundColor = [UIColor redColor];
                //                NSString *errorStirng = [NSString stringWithFormat:@"输入限制%ld个汉字或%ld个字符",(long)_maxnumber,(long)(_maxnumber*2)];
                
                textView.text = resultString;
                //                [CommonTools showAlertDismissWithContent:errorStirng];
                //                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                    NSInteger location =resultString.length+2;
                //                    textView.selectedRange = NSMakeRange(location, 0);
                //                });
                
                //                [textView resignFirstResponder];
            }
        } ];
    }
    
    if (self.textViewDidChange) {
        self.textViewDidChange(textView);
    }
    
}

- (BOOL)textView:(PBTextWithPlaceHoldView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (_maxnumber< 0.3) {
        _maxnumber = INT16_MAX;
    }
//    完全由外面决定是否能输入
    if (_shouldChangeTextInRange) {
        BOOL canChange = _shouldChangeTextInRange(textView,range,text);
        return canChange;
    }
    
//   外面加一层判断，比如说，只让输入英文， 或者只输入中文， 字数限制，后面继续判断
    if (_middleChangeTextInRange) {
        BOOL canChange = _middleChangeTextInRange(textView,range,text);
        if (canChange == NO) {
            return NO;
        }
    }
    if (textView.defaultAttributes.allKeys>0) {
        textView.typingAttributes = textView.defaultAttributes;
    }
    
    
    
    if (textView.text.length > 0) {
        textView.placeHoldLabel.hidden = YES;
        if (textView.text.length == 1)
        {
            if ([text isEqualToString:@""] || text == nil)
            {
                //当前有一个数字，按空格数字会消失 placeHoldLabel显示
                textView.placeHoldLabel.hidden = NO;
            }
            else
            {
                textView.placeHoldLabel.hidden = YES;

            }
        }
        
    }else{
        if ([text isEqualToString:@""] || text == nil)
        {
            //当前有一个数字，按空格数字会消失 placeHoldLabel显示
            textView.placeHoldLabel.hidden = NO;
        }
        else
        {
            textView.placeHoldLabel.hidden = YES;
            
        }
    }
    //                这个地方检察输入的字符字数
    if ([text isEqualToString:@""] || text == nil)
    {
        
    }
    else{
//        字数超出了限制的长度
        //        字数超出了限制的长度
        //        if (self.maxnumber > 1 && textView.text.length >self.maxnumber) {
        if (self.maxnumber > 1 ) {
            NSString *tempString = [NSString stringWithFormat:@"%@%@",textView.text,text];
            NSInteger totallength = [CommonTools convertToInt:tempString];
            UITextRange *selectedRange = [textView markedTextRange];
            //获取高亮部分
            UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];

            //如果在变化中是高亮部分在变，就不要计算字符了
            if (selectedRange && pos) {
                return YES;
            }
//            if (totallength> self.maxnumber*2) {
//                if (_textIstoolong) {
//                    _textIstoolong(textView);
//                }
//                return NO;
//            }
            if (self.isOnlyEnglish) {
                if (totallength> self.maxnumber*2) {
                    if (_textIstoolong) {
                        _textIstoolong(textView);
                    }
                    return NO;
                }
            }else
            {
                if (tempString.length > self.maxnumber) {
                    if (_textIstoolong) {
                        _textIstoolong(textView);
                    }
                    return NO;
                }
            }
           
        }
    }
    
    if (self.placeHoldLabelHiddenBlock) {
        self.placeHoldLabelHiddenBlock(textView.placeHoldLabel.hidden);
    }
    return YES;
}


//字符串超长的话，进行截取
- (void)stringByString:(NSString*)textString success:(void(^)(bool isTooLong, NSString *resultString))success
{
    int strlength = 0;
    BOOL isLong = NO;//是否太长了
    int  tooLongIndex = 0; // 太长的位置
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    char *p = (char *)[textString cStringUsingEncoding:encoding];
    if (!p) {
        p = (char *)[textString cStringUsingEncoding:NSUnicodeStringEncoding];
    }
    NSUInteger lengthOfBytes = [textString lengthOfBytesUsingEncoding:encoding];
    for (int i=0 ; i<lengthOfBytes ;i++) {
        if (*p) {
            p++;
            strlength++;
            //            字符超长了，记录位置
            if (strlength >_maxnumber*2) {
                isLong = YES;
                tooLongIndex= i;
                break;
            }
        }
        else {
            p++;
        }
    }
    if (isLong) {
        int realLongIndex = tooLongIndex/2;
        if (textString.length >realLongIndex) {
            //            这个是从1开始的
            NSString *realText = [self subStringByByteWithIndex:tooLongIndex textStr:textString];//[textString substringToIndex:realLongIndex];
            success(YES, realText);
        }
        else{
            success(NO, textString);
        }
        
        
    }
    else{
        success(NO, textString);
    }
    
}
- (NSString *)subStringByByteWithIndex:(NSInteger)index textStr:(NSString *)textStr{
    
    NSInteger sum = 0;
    
    NSString *subStr = [[NSString alloc] init];
    
    for(int i = 0; i<[textStr length]; i++){
        
        unichar strChar = [textStr characterAtIndex:i];
        if(strChar < 256){
            sum += 1;
        }
        else {
            sum += 2;
        }
        if (sum >= index) {
            
            subStr = [textStr substringToIndex:i+1];
            return subStr;
        }
        subStr = [textStr substringToIndex:i+1];
    }
    
    return subStr;
}


- (void)changeSize:(PBTextWithPlaceHoldView *)textView{
    NSDictionary *dict = @{NSFontAttributeName : textView.font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [textView.text boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    if (_needChangeSize) {
        if (_ChangeHeight) {
            _ChangeHeight(size.height + 1,textView);
        }
    }

}

@end
