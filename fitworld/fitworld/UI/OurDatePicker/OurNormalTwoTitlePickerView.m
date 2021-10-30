//
//  OurNormalTwoTitlePickerView.m
//  Ework
//
//  Created by feixiang on 2018/1/29.
//  Copyright © 2018年 crm. All rights reserved.
//

#import "OurNormalTwoTitlePickerView.h"

@interface OurNormalTwoTitlePickerView ()

@end

@implementation OurNormalTwoTitlePickerView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)createDefaultArray
{
    _leftSelectedIndex = 0;
    _rightSelectedIndex = 0;
//    如果数组里面没有值，就是-1
    if (_leftArray.count >0) {
        BaseScreenModel *firstLevelModel = [_leftArray objectAtIndex:0];
        _realrightArray = [NSMutableArray arrayWithArray:firstLevelModel.secondArray];
//        if (_realrightArray.count <1) {
//            _rightSelectedIndex = -1;
//        }
    }
    
}

- (void)creatSubviews
{
    
}

- (void)pickerViewWithView:(UIView*)view
{
    [self createDefaultArray];
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
    self.tag = 1000+[@"OurNormalTwoTitlePickerView" hash];
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
        BaseScreenModel *model = [_leftArray objectAtIndex:row];
        return model.showTitle;
    }
    if ( row < _realrightArray.count) {
        BaseScreenModel *model = [_realrightArray objectAtIndex:row];
        return model.showTitle;        
    }
    return @" ";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selectedRow %ld",row);
    
    if (component == 0) {
        
        //这个地方来处理右边的数组
        if (_leftSelectedIndex != row) {
            BaseScreenModel *leftmodel = [_leftArray objectAtIndex:row];
            _realrightArray = [NSMutableArray arrayWithArray:leftmodel.secondArray];
            _leftSelectedIndex = (int)row;
            [pickerView reloadAllComponents];
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
    if (_leftSelectedIndex < _leftArray.count && _leftSelectedIndex >= 0) {
       BaseScreenModel *leftmodel = [_leftArray objectAtIndex:_leftSelectedIndex];
        if (_rightSelectedIndex < leftmodel.secondArray.count && _rightSelectedIndex >= 0) {
            BaseScreenModel *rightmodel = [leftmodel.secondArray objectAtIndex:_rightSelectedIndex];
            if ([_pickerDelegate respondsToSelector:@selector(seletedNormalLeftVlaue:rightVlaue:)]) {
                [_pickerDelegate seletedNormalLeftVlaue:leftmodel rightVlaue:rightmodel];
            }
        }
    }
    [self removeFromSuperview];
    
}
- (void)dealloc{
    [self removeFromSuperview];
}

@end
