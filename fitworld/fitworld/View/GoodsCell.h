//
//  GoodsCell.h
//  TableNested
//
//  Created by HanOBa on 2019/4/25.
//  Copyright © 2019 HanOBa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"
NS_ASSUME_NONNULL_BEGIN

@interface GoodsCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *timeDuringLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomname;
@property (weak, nonatomic) IBOutlet UILabel *roomuser;
@property (weak, nonatomic) IBOutlet UIImageView *countryimage;
@property (weak, nonatomic) IBOutlet UILabel *roomidLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;

@property (nonatomic, strong) Room * cellRoom;

- (void)changedatawithmodel:(Room*)room;

@end

NS_ASSUME_NONNULL_END
