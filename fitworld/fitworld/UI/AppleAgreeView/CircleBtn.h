//
//  CircleBtn.h
//  FFitWorld
//
//  Created by feixiang on 2022/2/22.
//

#import <UIKit/UIKit.h>
#import "ReportReaseonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CircleBtn : UIView

@property(nonatomic, retain) UIImageView *showImageView;
@property(nonatomic, retain) ScreenModel *screenModel;
@property(nonatomic, retain) UIButton *backBtn;

- (void)changemodel:(ScreenModel*)model;
- (void)changebtnType;

@end

NS_ASSUME_NONNULL_END
