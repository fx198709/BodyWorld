//
//  Country.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/12.
//

#import "BaseJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Country : BaseJSONModel

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, copy) NSString *name_en;
@property (nonatomic, copy) NSString *code;

@end

NS_ASSUME_NONNULL_END
