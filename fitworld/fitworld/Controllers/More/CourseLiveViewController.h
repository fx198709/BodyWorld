//
//  YJListViewController.h
//  YJPageController
//
//  Created by 于英杰 on 2019/4/13.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import <UIKit/UIKit.h>
//更多的列表
@interface CourseLiveViewController : BaseNavViewController
@property(nonatomic,assign)NSInteger pageVCindex;
@property(nonatomic,assign) CGFloat viewheight;
@property(nonatomic,assign) id parentVC;;

//重新获取数据
- (void)reReahSearchData;
@end
