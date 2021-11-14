//
//  TableCollectionViewCell.h
//  TableNested
//
//  Created by HanOBa on 2019/4/23.
//  Copyright © 2019 HanOBa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CellDelegate <NSObject>

/** 点击的CollectionView Cell */
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface TableCollectionViewCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (nonatomic , assign) id<CellDelegate> delegate;

@property (nonatomic, strong)  NSMutableArray *dataArr;

//主要是为了刷新 页面里面的倒计时
- (void)timerToReloadCollectionView;


@end

NS_ASSUME_NONNULL_END
