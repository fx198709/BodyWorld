//
//  OurNormalMoreTitlePickerView.m
//  Ework
//
//  Created by feixiang on 2017/11/9.
//  Copyright © 2017年 crm. All rights reserved.
//

#import "OurNormalMoreTitlePickerView.h"

@implementation OurNormalMoreTitlePickerView

- (void)changDateWithPickerModel:(NormalTitlePickerModel*)pickermodel{
    self.currentModel = pickermodel;
    self.currnetArray = pickermodel.currnetArray;
    selectedDic = [NSMutableDictionary dictionaryWithDictionary:pickermodel.selectedDic];
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
    self.frame = CGRectMake(0, 0, width, height);
    self.tag = 1000+[@"OurNormalMoreTitlePickerView" hash];
    self.backgroundColor = [UIColor clearColor];
    CGRect backButtonframe = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, height -ScreenEndHeight);
    UIButton *backButton = [[UIButton alloc] initWithFrame:backButtonframe];
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

    _currentModel.selectedDic = selectedDic;
    if (self.ConfirmButtonClicked) {
        self.ConfirmButtonClicked(_currentModel);
    }
    
}

#pragma mark -pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
//    外部设置的数量
    return _currentModel.componentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
      return  self.currnetArray.count;
    }
    else{
        NSArray *tempArray = self.currnetArray;
//        一级一级下去找
        for (int i = 0; i < component ; i++) {
            NSString *selectedIndexString = [selectedDic objectForKey:[NSString stringWithFormat:@"%d",i]];
            int selectedIndex = selectedIndexString.intValue;
            if (tempArray.count >0 && selectedIndex>= 0 && selectedIndex< tempArray.count) {
                BaseScreenModel *screenModel = [tempArray objectAtIndex:selectedIndex];
                tempArray = screenModel.secondArray;
            }
            else{
                return 0;
            }
            if (i == component-1) {
                return tempArray.count;
            }
            
        }
    }
    return 0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    //设置分割线的颜色
//    for(UIView *singleLine in pickerView.subviews)
//    {
//        if (singleLine.frame.size.height < 1)
//        {
//            singleLine.backgroundColor = [UIColor grayColor];
//        }
//    }
    
    /*重新定义row 的UILabel*/
    UILabel *pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        [pickerLabel setTextColor:[UIColor darkGrayColor]];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
        // [pickerLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    }
    pickerLabel.attributedText
            = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
            
    
    return pickerLabel;
}


- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *titleString = @" ";
    if (component == 0) {
        BaseScreenModel *rowModel = [self.currnetArray objectAtIndex:row];
        titleString = rowModel.showTitle;
//        return rowModel.showTitle;
    }
    else{
        NSArray *tempArray = self.currnetArray;
        //        一级一级下去找
        for (int i = 0; i < component ; i++) {
            NSString *selectedIndexString = [selectedDic objectForKey:[NSString stringWithFormat:@"%d",i]];
            int selectedIndex = selectedIndexString.intValue;
            if (tempArray.count >0 && selectedIndex>= 0 && selectedIndex< tempArray.count) {
                BaseScreenModel *screenModel = [tempArray objectAtIndex:selectedIndex];
                tempArray = screenModel.secondArray;
            }
            else{

            }
            if (i == component-1) {
//                这个地方找到了，当前component 的数组
                if (tempArray.count >0 && row>= 0 && row< tempArray.count) {
                    BaseScreenModel *screenModel = [tempArray objectAtIndex:row];
                    titleString = screenModel.showTitle;
                }
            }

        }
    }
    UIFont *font = _textFont;
    if (font == nil) {
        int seize = 16;
        if (_currentModel.componentCount >= 3) {
            seize = 14;
        }
        font = SystemFontOfSize(seize);
    }
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:titleString];
    [attrString addAttribute:NSFontAttributeName
                       value:font
                       range:NSMakeRange(0, titleString.length)];
    
    return attrString;
}
//选中pickerView的第component列，第row行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [selectedDic setObject:[NSString stringWithFormat:@"%ld",(long)row] forKey:[NSString stringWithFormat:@"%d",(int)component]];
    if (component < _currentModel.componentCount) {
        for (NSInteger i = component+1; i < _currentModel.componentCount; i++) {
            [selectedDic setObject:@"0" forKey:[NSString stringWithFormat:@"%ld",(long)i]];
            [pickerView reloadComponent:i];
            [pickerView selectRow:0 inComponent:i animated:YES];
            
        }
    }
    
   
}
- (void)dealloc{
    [self removeFromSuperview];
}

@end
