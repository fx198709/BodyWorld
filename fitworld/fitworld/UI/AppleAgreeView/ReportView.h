//
//  ReportView.h
//  FFitWorld
//
//  Created by feixiang on 2022/2/22.
//

#import <UIKit/UIKit.h>
#import "PBTextWithPlaceHoldView.h"
#import "PBTextWithPlaceHoldViewDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface ReportView : UIView{
    NSString *uploadImageurl;
    UIImage *currentImage;
    PBTextWithPlaceHoldViewDelegate *viewTextDelegate;
}

@property (nonatomic, retain)NSMutableArray *dataArray;
@property (nonatomic, retain)PBTextWithPlaceHoldView *textview;


@property (nonatomic, assign) BaseNavViewController *rootControl;
@property (nonatomic, retain) UIButton *uploadBtn;


- (void)createSubview;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
@end

NS_ASSUME_NONNULL_END