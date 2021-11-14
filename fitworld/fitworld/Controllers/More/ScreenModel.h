//
//  ScreenModel.h
//  FFitWorld
//
//  Created by feixiang on 2021/11/15.
//

#import "BaseJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScreenModel : BaseJSONModel
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) BOOL    hasSelected;
- (instancetype)initWithJSON:(NSDictionary *)json;
@end

NS_ASSUME_NONNULL_END
