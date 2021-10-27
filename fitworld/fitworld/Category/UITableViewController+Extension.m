//
//  UITableViewController+Extension.m
//  BitAutoCRM
//
//  Created by C.K.Lian on 16/3/11.
//  Copyright © 2016年 crm. All rights reserved.
//

#import "UITableViewController+Extension.h"

@implementation UITableViewController (Extension)
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CRMLog(@"beginLogTableView %@",NSStringFromClass([self class]));

}
@end
