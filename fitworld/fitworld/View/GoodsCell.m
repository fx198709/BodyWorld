//
//  GoodsCell.m
//  TableNested
//
//  Created by HanOBa on 2019/4/25.
//  Copyright © 2019 HanOBa. All rights reserved.
//

#import "GoodsCell.h"

@implementation GoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.f;
    
    self.goodsImage.contentMode = UIViewContentModeScaleToFill;

}



@end
