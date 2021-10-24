//
//  TableCollectionLivingViewCell.h
//  TableNested
//
//  Created by HanOBa on 2019/4/23.
//  Copyright © 2019 HanOBa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LivingCellDelegate <NSObject>

/** 点击的CollectionView Cell */
- (void)didSelectLivingCellDelegateItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface TableCollectionLivingViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (nonatomic , assign) id<LivingCellDelegate> delegate;

@property (nonatomic, strong)  NSMutableArray *dataArr;


@end

NS_ASSUME_NONNULL_END
