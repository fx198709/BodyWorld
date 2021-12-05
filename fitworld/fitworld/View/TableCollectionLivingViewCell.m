//
//  TableCollectionLivingViewCell.m
//  TableNested
//
//  Created by HanOBa on 2019/4/23.
//  Copyright © 2019 HanOBa. All rights reserved.
//

#import "TableCollectionLivingViewCell.h"
#import "LivingGoodsCell.h"
#import "UIDeps.h"
#import "AFNetworking.h"
#import "FITAPI.h"
#import "TableCollectionLivingViewCell.h"
#import "Course.h"
#import "CourseDetailViewController.h"
#import "ConfigManager.h"
#import "RoomVC.h"
#import "NoDataCollectionViewCell.h"

@implementation TableCollectionLivingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self baseCellConfig];
    [self reloadData];
}


// Config
- (void)baseCellConfig{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.logoImage.layer.masksToBounds = YES;
    self.logoImage.layer.borderWidth = 0.5f;
    
    self.attentionBtn.layer.masksToBounds = YES;
    self.attentionBtn.layer.cornerRadius = 11.f;
    self.attentionBtn.layer.borderWidth = 0.5f;
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LivingGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:@"LivingGoodsCellString"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NoDataCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"NoDataCollectionViewCellString"];

    self.myCollectionView.backgroundColor = UIColor.clearColor;
}

// Data Source
- (void)reloadData {
    self.subTitleLabel.text = @"";
    [self.attentionBtn setTitle:Text_More forState:UIControlStateNormal];
    [self.attentionBtn setTitle:Text_More forState:UIControlStateHighlighted];
    self.subTitleLabel.text = ChineseStringOrENFun(@"正在进行", @"LIVE NOW");
    
    self.backgroundColor = UIColor.blackColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.myCollectionView reloadData];
}


#pragma mark - Collection Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArr.count?_dataArr.count:1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataArr.count > 0) {
        LivingGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LivingGoodsCellString" forIndexPath:indexPath];
        Room *tmpRoom = [_dataArr objectAtIndex: indexPath.item];
        [cell changedatawithmodel:tmpRoom];
        cell.joinBtn.tag = indexPath.row;
        [cell.joinBtn addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        NoDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoDataCollectionViewCellString" forIndexPath:indexPath];
        return cell;
    }
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(285, 152);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_dataArr.count > indexPath.row) {
        Room *selectRoom = [_dataArr objectAtIndex: indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //这里的id填刚刚设置的值,vc设置属性就可以给下个页面传参数了
        CourseDetailViewController *vc = (CourseDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"courseDetailVC"];
        vc.selectRoom = selectRoom;
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


 
- (void)join:(UIButton *) recognizer{
    NSLog(@"join ----");
    Room *selectRoom = [_dataArr objectAtIndex: recognizer.tag];
    [[APPObjOnce sharedAppOnce] joinRoom:selectRoom withInvc:[self viewController]];
}


- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


@end


