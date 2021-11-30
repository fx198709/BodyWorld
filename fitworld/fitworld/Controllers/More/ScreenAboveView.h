//
//  ScreenAboveView.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ScreenBtnBlock)(NSArray*timeArray, NSArray*typeArray);


@interface ScreenAboveView : UIView{
    NSArray *_timeArray;
    NSArray *_typeArray;
    
}
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;

@property (strong, nonatomic) UIView* contentView;
@property (strong, nonatomic) UIView* durationView;
@property (strong, nonatomic) NSArray *lastSelectedIds;

@property (nonatomic, copy)ScreenBtnBlock screenOKClick;
@property (weak, nonatomic) IBOutlet UILabel *canenterLabel;
@property (weak, nonatomic) IBOutlet UIButton *canEnterBtn;

- (void)changeData:(NSArray*)timeArray andType:(NSArray*)typeArray;

@end

NS_ASSUME_NONNULL_END
