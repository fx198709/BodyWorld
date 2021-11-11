//
//  TZImagePickerController+Vedio.h
//  Ework
//
//  Created by Yiche on 2018/11/28.
//  Copyright © 2018年 crm. All rights reserved.
//

#import "TZImagePickerController.h"

@interface TZImagePickerController (Vedio)
+ (AVMutableVideoComposition *)getVideoComposition:(AVAsset *)asset;
@end
