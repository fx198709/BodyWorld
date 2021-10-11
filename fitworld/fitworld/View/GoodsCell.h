//
//  GoodsCell.h
//  TableNested
//
//  Created by HanOBa on 2019/4/25.
//  Copyright © 2019 HanOBa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UILabel *startTime;

@end

NS_ASSUME_NONNULL_END
