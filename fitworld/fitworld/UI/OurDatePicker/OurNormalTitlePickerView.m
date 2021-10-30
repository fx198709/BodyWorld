//
//  OurNormalTitlePickerView.m
//  Ework
//
//  Created by feixiang on 2017/11/9.
//  Copyright © 2017年 crm. All rights reserved.
//

#import "OurNormalTitlePickerView.h"

@implementation OurNormalTitlePickerView

- (void)changDateWithPickerModel:(NormalTitlePickerModel*)pickermodel{
    self.currentModel = pickermodel;
    self.currnetArray = pickermodel.currnetArray;
    self.selectIndex = pickermodel.selectIndex;
    [self pickerViewWithView:nil];
}

#pragma mark - 添加pickerView方法

- (void)pickerViewWithView:(UIView*)view
{
//    [self createDefaultArray];
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
    self.tag = 1000+[@"OurNormalTitlePickerView" hash];
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
//    如果有viewTitle 加一个viewTitle
//    NSString *viewTitle = _currentModel.viewTitle;
//    if (viewTitle.length > 1) {
//        UIView *headTitleBackview = [[UIView alloc] initWithFrame:CGRectMake(0,startY-25,width,25)];
//        headTitleBackview.backgroundColor = [UIColor whiteColor];
//        [self addSubview:headTitleBackview];
//        
//        UILabel  *headTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,width,25)];
//        [headTitleBackview addSubview:headTitleLabel];
//        headTitleLabel.text = viewTitle;
//        headTitleLabel.textColor = [UIColor blackColor];
//        headTitleLabel.font = SystemFontOfSize(20);
//        headTitleLabel.textAlignment = NSTextAlignmentCenter;
//    }
    //底部加一个白色的view
    UIView *bottomBackview = [[UIView alloc] initWithFrame:CGRectMake(0,startY,width,pickerH)];
    bottomBackview.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomBackview];
    
    self.leftPicker = [ [ UIPickerView alloc] initWithFrame:CGRectMake(0,startY,width,pickerH)];
    self.leftPicker.delegate = self;
    self.leftPicker.dataSource = self;
    [self addSubview:self.leftPicker];
    if (_currentModel.selectIndex >0 && _currentModel.selectIndex < _currentModel.currnetArray.count) {
        [self.leftPicker selectRow:_currentModel.selectIndex inComponent:0 animated:YES];
    }
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
- (void)cancelPicker
{
     [self removeFromSuperview];
}


- (void)oKPicker
{
     [self removeFromSuperview];
    _currentModel.selectIndex = self.selectIndex;
    BaseScreenModel *screenModel = [_currentModel.currnetArray objectAtIndex:_currentModel.selectIndex];
    _currentModel.pickerTitle = screenModel.showTitle;
    
    if (self.ConfirmButtonClicked) {
        self.ConfirmButtonClicked(_currentModel);
    }
    
}

#pragma mark -pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  self.currnetArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BaseScreenModel *rowModel = [self.currnetArray objectAtIndex:row];
    return rowModel.showTitle;
}
//选中pickerView的第component列，第row行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectIndex = (int)row;
    
}
- (void)dealloc{
    [self removeFromSuperview];
}

@end
