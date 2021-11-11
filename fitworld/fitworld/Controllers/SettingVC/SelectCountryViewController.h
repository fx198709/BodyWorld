//
//  SelectCountryViewController.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/11.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    SelectCountryType_Country, //国家
    SelectCountryType_City, //城市
} SelectCountryType;

@interface SelectCountryViewController : BaseViewController

@property (nonatomic, assign) SelectCountryType selectType;

@end

NS_ASSUME_NONNULL_END
