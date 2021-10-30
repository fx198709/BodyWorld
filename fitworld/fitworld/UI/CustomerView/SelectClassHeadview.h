//
//  SelectClassHeadview.h
//  FFitWorld
//
//  Created by feixiang on 2021/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectClassHeadview : UIView
@property (weak, nonatomic) IBOutlet UIImageView *image1view;
@property (weak, nonatomic) IBOutlet UIImageView *image2view;
@property (weak, nonatomic) IBOutlet UIImageView *image3view;
@property (weak, nonatomic) IBOutlet UILabel *steplabel1;
@property (weak, nonatomic) IBOutlet UILabel *steplabel2;
@property (weak, nonatomic) IBOutlet UILabel *steplabel3;
@property (weak, nonatomic) IBOutlet UIView *linebackview1;
@property (weak, nonatomic) IBOutlet UIView *linebackview2;
@property (weak, nonatomic) IBOutlet UIView *linebackview3;
@property (weak, nonatomic) IBOutlet UIView *linebackview4;

- (void)changeStep:(int)step;

@end

NS_ASSUME_NONNULL_END
