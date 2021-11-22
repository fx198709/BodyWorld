//
//  ChangeInfoViewController.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/10.
//

#import "BaseNavViewController.h"

typedef enum : int {
    ChangeTypeEnum_NickName = 0,
    ChangeTypeEnum_Height,
    ChangeTypeEnum_Weight
}ChangeTypeEnum;

NS_ASSUME_NONNULL_BEGIN

@interface ChangeInfoViewController : BaseViewController

@property (nonatomic, assign) ChangeTypeEnum changeType;
@end

NS_ASSUME_NONNULL_END
