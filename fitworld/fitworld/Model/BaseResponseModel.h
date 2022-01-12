//
//  BaseResponseModel.h
//  FFitWorld
//
//  Created by TinaXie on 2022/1/12.
//

#import "BaseJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseResponseModel : BaseJSONModel

@property (nonatomic , assign) NSInteger status;
@property (nonatomic , copy) NSString * msg;
@property (nonatomic , assign) NSInteger recordset;

@end

NS_ASSUME_NONNULL_END
