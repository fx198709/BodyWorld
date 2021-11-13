//
//  FriendCell.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import <UIKit/UIKit.h>

typedef void (^AgreeAddCallBack)(void);

NS_ASSUME_NONNULL_BEGIN

@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
//是否是添加
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) int addStatus;

@property (nonatomic, copy)AgreeAddCallBack callBack;

@end

NS_ASSUME_NONNULL_END
