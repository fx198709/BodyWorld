//
//  VSVideoConfig.h
//  VSVideo
//
//  Created by pliu on 12/06/2019.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>
#include <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSVideoConfig : NSObject

- (NSArray<AVCaptureDeviceFormat *>*)GetCaptureDeviceFormats:(AVCaptureDevicePosition)position;
- (BOOL)switchCaptureParameterWithPosition:(BOOL)front andSize:(CGSize)size andFramerate:(int)fps;

- (BOOL)isUseFrontCamera;

- (BOOL)torch;
- (void)setTorch:(BOOL)open;

- (CGFloat)zoomFactor;
- (void)setZoomFactor:(CGFloat)factor;

- (BOOL)isFaceBeauty;
- (void)setFaceBeauty:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
