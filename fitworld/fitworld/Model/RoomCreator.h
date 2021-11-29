//
//  RoomCreator.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/29.
//

#import "BaseJSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RoomCreator : BaseJSONModel

@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * country;
@property (nonatomic , copy) NSString              * country_icon;
@property (nonatomic , assign) NSInteger              gender;
@property (nonatomic , copy) NSString              * genderString;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * username;

@end

NS_ASSUME_NONNULL_END
