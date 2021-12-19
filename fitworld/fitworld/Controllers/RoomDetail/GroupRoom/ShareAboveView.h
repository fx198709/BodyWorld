//
//  ShareAboveView.h
//  FFitWorld
//
//  Created by feixiang on 2021/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareAboveView : UIView
@property (weak, nonatomic) IBOutlet UIView *shareview;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (copy, nonatomic)  AnyBtnBlock shareBtnClick;
-(void)createSubview;
@end

NS_ASSUME_NONNULL_END
