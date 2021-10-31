//
//  HeadTimeCollectionViewCell.h
//  FFitWorld
//
//  Created by feixiang on 2021/10/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeadTimeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UIView *selectedView;
- (void)addSubviews;

- (void)changeSelected;
- (void)changeunSelected;

@end

NS_ASSUME_NONNULL_END
