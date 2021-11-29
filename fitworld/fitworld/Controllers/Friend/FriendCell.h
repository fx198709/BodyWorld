//
//  FriendCell.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/13.
//

#import <UIKit/UIKit.h>


typedef enum {
    FriendCell_agree, //同意添加好友
    FriendCell_agreeed, //已添加好友
    FriendCell_delete, //删除好友
    FriendCell_add  //添加好友
}FriendCellType;

NS_ASSUME_NONNULL_BEGIN

@interface FriendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *line;

//cell类型
@property (nonatomic, assign) FriendCellType cellType;
@property (nonatomic, assign) int addStatus;

@property (nonatomic, copy) BaseCallBack btnCallBack;

@end

NS_ASSUME_NONNULL_END
