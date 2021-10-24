//
//  TableCollectionViewCell.m
//  TableNested
//
//  Created by HanOBa on 2019/4/23.
//  Copyright © 2019 HanOBa. All rights reserved.
//

#import "TableCollectionViewCell.h"
#import "GoodsCell.h"
#import "UIDeps.h"
#import "AFNetworking.h"
#import "FITAPI.h"
#import "TableCollectionViewCell.h"
#import "Course.h"
#import "CourseDetailViewController.h"
#import "ConfigManager.h"
#import "RoomVC.h"

@implementation TableCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self baseCellConfig];
    [self baseCellDataSource];
    
}


// Config
- (void)baseCellConfig{
        
    self.logoImage.layer.masksToBounds = YES;
    self.logoImage.layer.borderWidth = 0.5f;
    
    self.attentionBtn.layer.masksToBounds = YES;
    self.attentionBtn.layer.cornerRadius = 11.f;
    self.attentionBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.attentionBtn.layer.borderWidth = 0.5f;
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsCell class]) bundle:nil] forCellWithReuseIdentifier:@"goodsCell"];
    
    self.myCollectionView.backgroundColor = UIColor.clearColor;
}

// Data Source
- (void)baseCellDataSource{
    self.logoImage.image = [UIImage imageNamed:@"shakehideimg_man"];
    self.subTitleLabel.text = @"xxxxx";
    [self.attentionBtn setTitle:@"More" forState:(UIControlStateNormal)];
}


#pragma mark - Collection Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
    Room *tmpRoom = [_dataArr objectAtIndex: indexPath.item];
    [cell changedatawithmodel:tmpRoom];
    cell.joinBtn.tag = indexPath.row;
    [cell.joinBtn addTarget:self action:@selector(join:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
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
    
    return CGSizeMake(220, 185);
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
    
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]) {
        [self.delegate didSelectItemAtIndexPath:indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)onClickCourseDetail:(UITapGestureRecognizer *)recognizer{
    NSLog(@"onClickCourseDetail ----  ");
    Room *selectRoom = [_dataArr objectAtIndex: recognizer.view.tag];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //这里的id填刚刚设置的值,vc设置属性就可以给下个页面传参数了
    CourseDetailViewController *vc = (CourseDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"courseDetailVC"];
    vc.selectRoom = selectRoom;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

- (void)join:(UIButton *) recognizer{
    NSLog(@"join ----");
    Room *selectRoom = [_dataArr objectAtIndex: recognizer.tag];
    NSString * nickName = @"123";
    [ConfigManager sharedInstance].eventId = selectRoom.event_id;
    [ConfigManager sharedInstance].nickName = nickName;
    [[ConfigManager sharedInstance] saveConfig];

    NSDictionary *codeDict = @{@"eid":selectRoom.event_id, @"name":nickName};
    RoomVC *roomVC = [[RoomVC alloc] initWith:codeDict];
    [[self viewController].navigationController pushViewController:roomVC animated:YES];
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


