//
//  SelectCountryViewController.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/11.
//

#import "BaseViewController.h"
#import "Country.h"


NS_ASSUME_NONNULL_BEGIN

typedef enum {
    SelectCountryType_Country, //国家
    SelectCountryType_City, //城市
    SelectCountryType_SubCity, //地级市
} SelectCountryType;

@interface SelectCountryViewController : BaseViewController

@property (nonatomic, assign) SelectCountryType selectType;

@property (nonatomic, strong) Country *country;
@end

NS_ASSUME_NONNULL_END
