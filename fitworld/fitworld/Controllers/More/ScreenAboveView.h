//
//  ScreenAboveView.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ScreenBtnBlock)(NSArray*timeArray, NSArray*typeArray,NSArray * languageArray, BOOL show_join);


@interface ScreenAboveView : UIView{
    NSArray *_timeArray;
    NSArray *_typeArray;
    NSArray *_languageArray;
}
@property (strong, nonatomic)  UILabel *contentLabel;
@property (strong, nonatomic)  UILabel *durationLabel;
@property (strong, nonatomic)  UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (assign, nonatomic) BOOL showJoin;
@property (strong, nonatomic) IBOutlet UIScrollView *screenScrollview;


@property (strong, nonatomic)  UIView* contentView;
@property (strong, nonatomic)  UIView* durationView;
@property (strong, nonatomic)  UIView* languageView;
//9 10

@property (strong, nonatomic) NSArray *lastSelectedIds;

@property (nonatomic, copy)ScreenBtnBlock screenOKClick;
@property (weak, nonatomic) IBOutlet UILabel *canenterLabel;
@property (weak, nonatomic) IBOutlet UIButton *canEnterBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top1constraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top2constraint;

- (void)changeData:(NSArray*)timeArray andType:(NSArray*)typeArray andLanguage:(NSArray*)languageArray isjoin:(BOOL)isjoin;
 

@end

NS_ASSUME_NONNULL_END
