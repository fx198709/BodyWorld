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
#import "NoDataCollectionViewCell.h"
#import "CreateCourseSuccessViewController.h"
#import "AfterTrainingViewController.h"
#import "GroupRoomDetailViewController.h"

@implementation TableCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self baseCellConfig];
    [self reloadData:NO];
}


// Config
- (void)baseCellConfig{
    
    self.logoImage.layer.masksToBounds = YES;
    self.logoImage.layer.borderWidth = 0.5f;
    
    self.attentionBtn.layer.masksToBounds = YES;
    self.attentionBtn.layer.cornerRadius = 11.f;
    self.attentionBtn.layer.borderWidth = 0.5f;
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GoodsCell class]) bundle:nil] forCellWithReuseIdentifier:@"goodsCell"];
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NoDataCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"NoDataCollectionViewCellString"];
    
    
    
    
    self.myCollectionView.backgroundColor = UIColor.clearColor;
}

// Data Source
- (void)reloadData:(BOOL)isTraining {
    self.backgroundColor = UIColor.blackColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.subTitleLabel.text = @"";
    [self.attentionBtn setTitle:Text_More forState:UIControlStateNormal];
    [self.attentionBtn setTitle:Text_More forState:UIControlStateHighlighted];
    
    if (isTraining) {
        [self.logoImage setImage:[UIImage imageNamed:@"index_buddy"]];
        self.subTitleLabel.text = Text_Training;
    } else {
        [self.logoImage setImage:[UIImage imageNamed:@"index_group"]];
        self.subTitleLabel.text = Text_Group;
    }
    [self.myCollectionView reloadData];
}

- (void)timerToReloadCollectionView{
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
    if (_dataArr.count >0) {
        GoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
        Room *tmpRoom = [_dataArr objectAtIndex: indexPath.item];
        [cell changedatawithmodel:tmpRoom];
        cell.joinBtn.tag = indexPath.row+100;
        int state = [tmpRoom reachRoomDealState];
        if (state == 1 || state == 2) {
            [cell.joinBtn addTarget:self action:@selector(joinBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        //        开始直播
        if (state == 5) {
            [cell.joinBtn addTarget:self action:@selector(startLivingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
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
    
    return CGSizeMake(260, 211);
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
    //    选中某个课程的背景
    if (_dataArr.count > indexPath.row) {
        Room *selectRoom = [_dataArr objectAtIndex: indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //这里的id填刚刚设置的值,vc设置属性就可以给下个页面传参数了
        if (selectRoom.course.type_int == 1) {
            
            GroupRoomDetailViewController *vc =[[GroupRoomDetailViewController alloc] initWithNibName:@"GroupRoomDetailViewController" bundle:nil];
            vc.selectRoom = selectRoom;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }else{
            if (selectRoom.is_join) {
                CreateCourseSuccessViewController *vc =[[CreateCourseSuccessViewController alloc] initWithNibName:@"CreateCourseSuccessViewController" bundle:nil];
                vc.event_id = selectRoom.event_id;
                [[self viewController].navigationController pushViewController:vc animated:YES];
            }else{
                CourseDetailViewController *vc = (CourseDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"courseDetailVC"];
                vc.selectRoom = selectRoom;
                [[self viewController].navigationController pushViewController:vc animated:YES];
            }
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)startLivingBtnClicked:(UIButton *) recognizer{
    Room *selectRoom = [_dataArr objectAtIndex: recognizer.tag-100];
    [[APPObjOnce sharedAppOnce] joinRoom:selectRoom withInvc:[self viewController]];
    
    //    Room *room1 = [_dataArr objectAtIndex: recognizer.tag-100];
    //    AfterTrainingViewController *trainingvc = [[AfterTrainingViewController alloc] initWithNibName:@"AfterTrainingViewController" bundle:nil];
    //    [[self viewController].navigationController pushViewController:trainingvc animated:YES];
    //    trainingvc.event_id = room1.event_id;
    //    trainingvc.invc = [self viewController];
    //    return;
}


- (void)joinBtnClicked:(UIButton *) recognizer{
    //    这边需要正在进行中的，才能开始，需要判断状态
    //    做测试用
    
    Room *room = [_dataArr objectAtIndex: recognizer.tag-100];
    AFAppNetAPIClient *manager =[AFAppNetAPIClient manager];
    UIView *parentView =[[self viewController] view];
    UIViewController *parentControl = [self viewController];
    [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    if (room.is_join) {
        //        取消选中
        
        NSDictionary *baddyParams = @{
            @"event_id": room.event_id,
            @"friend_id":[APPObjOnce sharedAppOnce].currentUser.id
        };
        [manager POST:@"room/kickout" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:parentView animated:YES];
            if (CheckResponseObject(responseObject)) {
                [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"操作成功", @"操作成功") control:[self viewController]];
                if ([parentControl respondsToSelector:@selector(headerRereshing)]) {
                    [parentControl performSelector:@selector(headerRereshing)];
                }
                
            }else{
                [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"] control:[self viewController]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [CommonTools showNETErrorcontrol:[self viewController]];
            [MBProgressHUD hideHUDForView:parentView animated:YES];
            
        }];
    }else{
        NSDictionary *baddyParams = @{
            @"event_id": room.event_id,
            @"is_join":[NSNumber numberWithBool:!room.is_join]
        };
        [manager POST:@"practise/join" parameters:baddyParams success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:parentView animated:YES];
            if (CheckResponseObject(responseObject)) {
                [CommonTools showAlertDismissWithContent:ChineseStringOrENFun(@"操作成功", @"操作成功") control:[self viewController]];
                if ([parentControl respondsToSelector:@selector(headerRereshing)]) {
                    [parentControl performSelector:@selector(headerRereshing)];
                }
            }else{
                [CommonTools showAlertDismissWithContent:[responseObject objectForKey:@"msg"] control:[self viewController]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [CommonTools showNETErrorcontrol:[self viewController]];
            [MBProgressHUD hideHUDForView:parentView animated:YES];
            
        }];
    }
    
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


