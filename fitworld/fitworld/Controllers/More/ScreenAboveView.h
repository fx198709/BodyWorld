//
//  ScreenAboveView.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ScreenBtnBlock)(NSArray*timeArray, NSArray*typeArray, BOOL show_join);


@interface ScreenAboveView : UIView{
    NSArray *_timeArray;
    NSArray *_typeArray;
    
}
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (assign, nonatomic) BOOL showJoin;


@property (strong, nonatomic) IBOutlet UIView* contentView;
@property (strong, nonatomic) IBOutlet UIView* durationView;
@property (strong, nonatomic) NSArray *lastSelectedIds;

@property (nonatomic, copy)ScreenBtnBlock screenOKClick;
@property (weak, nonatomic) IBOutlet UILabel *canenterLabel;
@property (weak, nonatomic) IBOutlet UIButton *canEnterBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top1constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top2constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthconstraint;

- (void)changeData:(NSArray*)timeArray andType:(NSArray*)typeArray isjoin:(BOOL)isjoin;
 

@end

NS_ASSUME_NONNULL_END
