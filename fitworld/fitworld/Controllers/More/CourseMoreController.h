//
//  YJDemo.h
//  YJPageController
//
//  Created by 于英杰 on 2019/4/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
//更多
@interface CourseMoreController : BaseNavViewController
@property(nonatomic,assign)int VCtype;
@property (nonatomic, strong)NSArray *curse_type_array;
@property (nonatomic, strong)NSArray *curse_time_array;
@property (nonatomic, assign)BOOL show_join;

//获取删选项
- (void)reachSeletedValue:(void(^)(NSString*typeSelected,NSString*timeSelected))selectedValue;
@end
