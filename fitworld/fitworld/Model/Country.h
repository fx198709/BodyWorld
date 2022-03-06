//
//  Country.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/12.
//

#import "BaseJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Country : BaseJSONModel

@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *name_en;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) int level;
@property (nonatomic, copy) NSString *pingying;
@property (nonatomic, copy) NSString *orderString;//可以是拼音，也可以是
@property (nonatomic, copy) NSString *firstWord;//第一个字母

- (void)changeOrderString;
@end

NS_ASSUME_NONNULL_END
