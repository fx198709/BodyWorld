//
//  FriendCell.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
//是否是添加
@property (nonatomic, assign) BOOL isAdd;

@end

NS_ASSUME_NONNULL_END
