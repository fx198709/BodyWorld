//
//  CountryCode.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/12.
//

#import "BaseJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CountryCode : BaseJSONModel

@property (nonatomic, assign) int code;
@property (nonatomic, copy) NSString *en;
@property (nonatomic, copy) NSString *tw;
@property (nonatomic, copy) NSString *zh;
@property (nonatomic, copy) NSString *locale;

@end

NS_ASSUME_NONNULL_END
