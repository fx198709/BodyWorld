//
//  UILabel+ChangeLineSpaceAndWordSpace.h
//  Ework
//
//  Created by feixiang on 2017/12/6.
//  Copyright © 2017年 crm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILabel(ChangeLineSpaceAndWordSpace)

/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


/**
 label的高宽属性设置为high

 @param label <#label description#>
 */
+ (void)labelWithandHeightPriority:(UILabel *)label;


@end
