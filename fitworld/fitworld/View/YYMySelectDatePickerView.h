//
//  YYMySelectDatePickerView.h
//  BAIHC
//
//  Created by xiejc on 2019/4/29.
//  Copyright © 2019 YYCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YYDateFormatter_Day @"yyyy-MM-dd"
#define YYDateFormatter_Second @"yyyy-MM-dd HH:mm:ss"

NS_ASSUME_NONNULL_BEGIN

@protocol YYMySelectDatePickerViewDelegate <NSObject>

- (void)selectDatePickerDidSelectDate:(NSDate *)date;

- (void)selectDatePickerDidClickCancel;

@end

@interface YYMySelectDatePickerView : UIView

@property (nonatomic, weak) id<YYMySelectDatePickerViewDelegate> delegate;

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSDate *beginDate;
@property (nonatomic, strong, nullable) NSDate *endData;


- (void)showWithAnimated:(BOOL)animated completedBlock:(nullable void(^)(void))completedBlock;

@end

NS_ASSUME_NONNULL_END
