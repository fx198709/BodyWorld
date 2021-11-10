//
//  ChangeInfoViewController.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import "BaseNavViewController.h"

typedef enum : int {
    ChangeTypeEnum_NickName,
    ChangeTypeEnum_Height,
    ChangeTypeEnum_Weight,
    ChangeTypeEnum_Info
}ChangeTypeEnum;

NS_ASSUME_NONNULL_BEGIN

@interface ChangeInfoViewController : BaseNavViewController

@property (nonatomic, assign) ChangeTypeEnum changeType;
@end

NS_ASSUME_NONNULL_END
