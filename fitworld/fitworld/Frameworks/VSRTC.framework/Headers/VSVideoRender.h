//
//  VSVideoRender.h
//  VSRTC
//
//  Created by pliu on 20200705.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSVideoRender : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (NSInteger)handle;
- (UIView *)render_view;
- (UIViewContentMode)content_mode;
- (void)set_content_mode:(UIViewContentMode)mode;
- (BOOL)is_mirrored;
- (void)set_mirrored:(BOOL)mirrored;

- (void)clearImage;
@end

NS_ASSUME_NONNULL_END
