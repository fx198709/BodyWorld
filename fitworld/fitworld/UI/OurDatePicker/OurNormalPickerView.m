//
//  OurNormalPickerView.m
//  Ework
//
//  Created by feixiang on 2016/12/2.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "OurNormalPickerView.h"

@implementation OurNormalPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createDefaultArray];
    }
    return self;
}


- (void)createDefaultArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *array2 = [NSMutableArray arrayWithCapacity:0];

    for (int i = 9; i < 18; i++) {
        NSString *sting1 = [NSString stringWithFormat:@"%02d时00分",i];
        NSString *sting2 = [NSString stringWithFormat:@"%02d时30分",i];
        NSString *sting3 = [NSString stringWithFormat:@"%02d时00分",i+1];

        [array addObject:sting1];
        [array addObject:sting2];
        
        [array2 addObject:sting2];
        [array2 addObject:sting3];
    }
    self.leftArray =  array;
    self.rightArray = array2;
    _realrightArray = [NSMutableArray arrayWithArray:_rightArray];
    _leftSelectedIndex = 0;
    _rightSelectedIndex = 0;

}

- (void)creatSubviews
{
    
}

- (void)pickerViewWithView:(UIView*)view
{
    UIView *inview = [CommonTools mainWindow];
    if (view) {
        inview = view;
    }
    int width = inview.frame.size.width;
    int height = inview.frame.size.height;
    
    //添加蒙板
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    self.tag = 1000+[@"OurNormalPickerView" hash];
    self.frame = CGRectMake(0, 0, width, height);
    self.backgroundColor = [UIColor clearColor];
    UIButton *backButton = [[UIButton alloc] initWithFrame:self.bounds];
    backButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [backButton addTarget:self action:@selector(cancelPicker) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
    self.userInteractionEnabled = YES;
    //添加pickerView  现在底部有按钮了 需要修改一下
    CGFloat pickerH = 216.0f;
    int BottomButtonHeight = 49; //底部按钮的高度
    
    //Y开始的地方
    int startY = height - pickerH- BottomButtonHeight -ScreenEndHeight;
    
    //底部加一个白色的view
    UIView *bottomBackview = [[UIView alloc] initWithFrame:CGRectMake(0,startY,width,pickerH)];
    bottomBackview.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomBackview];
    
    self.leftPicker = [ [ UIPickerView alloc] initWithFrame:CGRectMake(0,startY,width,pickerH)];
    self.leftPicker.delegate = self;
    self.leftPicker.dataSource = self;
    [self addSubview:self.leftPicker];

    UILabel *vlabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2- 60/2, startY+pickerH/2-50/2, 60, 50)];
    vlabel.text = @"-";
    vlabel.font = SystemFontOfSize(30);
    vlabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:vlabel];
    
    //底部按钮视图
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,height - BottomButtonHeight- ScreenEndHeight,width,BottomButtonHeight)];
    bottomView.userInteractionEnabled = YES;
    [self addSubview:bottomView];
    [self bringSubviewToFront:bottomView];
    UIButton * leftButton = [self createbuttonisLeft:YES];
    [bottomView addSubview:leftButton];
    
    UIButton * rightButton = [self createbuttonisLeft:NO];
    [bottomView addSubview:rightButton];
    [inview addSubview:self];
    
    //处理传入的值
    if (self.indate) {
        NSString *indateString = self.indate;
//        NSArray *dateArray = [indateString componentsSeparatedByString:@"~"];
//        if (dateArray.count == 2) {
            NSString *leftString = indateString;
            leftString = [leftString stringByReplacingOccurrencesOfString:@":" withString:@"时"];
            leftString = [leftString stringByAppendingString:@"分"];
        
            NSString *rightString = self.rightIndate;
            rightString = [rightString stringByReplacingOccurrencesOfString:@":" withString:@"时"];
            rightString = [rightString stringByAppendingString:@"分"];
            for (int i = 0; i < _leftArray.count; i ++ ) {
                NSString * timeString  = [_leftArray objectAtIndex:i];
                if ([timeString isEqualToString:leftString] ) {
                    _leftSelectedIndex = i;
                    break;
                }
            }
            //如果有拿到初始值
//            if (_leftSelectedIndex >0) {
                _realrightArray = [NSMutableArray arrayWithArray:_rightArray];
                for (int i = (int)_realrightArray.count -1; i >= 0; i --) {
                    if (i < _leftSelectedIndex) {
                        NSLog(@"deleteIndex %d",i);
                        [_realrightArray removeObjectAtIndex:i];
                    }
                }
                //找到右边的点
                for (int j = 0; j < _realrightArray.count; j ++ ) {
                    NSString * timeString  = [_realrightArray objectAtIndex:j];
                    if ([timeString isEqualToString:rightString] ) {
                        _rightSelectedIndex = j;
                        break;

                    }
                }
                
            
                [_leftPicker reloadAllComponents];
            if (_leftSelectedIndex >0) {
                [_leftPicker selectRow:_leftSelectedIndex inComponent:0 animated:NO];

            }

                if (_rightSelectedIndex >0) {
                    [_leftPicker selectRow:_rightSelectedIndex inComponent:1 animated:NO];
   
                }
            
//            }

        }
//    }

}


#pragma mark - 点击取消的方法
- (void)cancelPicker {
    //不麻烦了，把自己删除了
    [self removeFromSuperview];
//    if ([_pickerDelegate respondsToSelector:@selector(dateViewCancelButtonClicked)]) {
//        [_pickerDelegate dateViewCancelButtonClicked];
//    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return _leftArray.count;
    }
    return _realrightArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_leftArray objectAtIndex:row];
    }
    if ( row < _realrightArray.count) {
        return [_realrightArray objectAtIndex:row];
   
    }
    return @" ";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selectedRow %ld",row);

    if (component == 0) {
        
        //这个地方来处理右边的数组
        if (_leftSelectedIndex != row) {
            _realrightArray = [NSMutableArray arrayWithArray:_rightArray];
            for (int i = (int)_realrightArray.count -1; i >= 0; i --) {
                if (i < row) {
                    NSLog(@"deleteIndex %d",i);
                    [_realrightArray removeObjectAtIndex:i];
                }
            }
            
            _rightSelectedIndex = (int)(_rightSelectedIndex + _leftSelectedIndex - row);
            if (_rightSelectedIndex < 1) {
                _rightSelectedIndex = 0;
            }
            
            if (_rightSelectedIndex > _realrightArray.count) {
                _rightSelectedIndex = (int)_realrightArray.count -1;
            }
            [_leftPicker reloadComponent:1];
            [_leftPicker selectRow:_rightSelectedIndex inComponent:1 animated:NO];
            
            _leftSelectedIndex = (int)row;
        }
        
    }
    else
    {
        if (_rightSelectedIndex != row) {
            
            _rightSelectedIndex = (int)row;
        }
    }
}



#pragma mark - 点击确认的方法
- (void)oKPicker
{
    NSString *leftString = @"";

    if (_leftSelectedIndex < _leftArray.count) {
        leftString = [_leftArray objectAtIndex:_leftSelectedIndex];
        leftString = [leftString stringByReplacingOccurrencesOfString:@"时" withString:@":"];
        leftString = [leftString stringByReplacingOccurrencesOfString:@"分" withString:@""];

    }
    NSString *rightString = @"";
    if (_rightSelectedIndex < _realrightArray.count) {
        rightString = [_realrightArray objectAtIndex:_rightSelectedIndex];
        rightString = [rightString stringByReplacingOccurrencesOfString:@"时" withString:@":"];
        rightString = [rightString stringByReplacingOccurrencesOfString:@"分" withString:@""];
    }
    NSString *dateString = [NSString stringWithFormat:@"%@-%@",leftString,rightString];
    if ([_pickerDelegate respondsToSelector:@selector(seletedNormalTwoHourAndMinuteDate:)]) {
        [_pickerDelegate seletedNormalTwoHourAndMinuteDate:dateString];
    }
    [self removeFromSuperview];

}
- (void)dealloc{
    [self removeFromSuperview];
}

@end
