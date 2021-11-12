//
//  SelectCountryCodeViewController.h
//  FFitWorld
//
//  Created by xiejc on 2021/11/12.
//

#import <UIKit/UIKit.h>
#import "CountryCode.h"

typedef void (^SelectCountryCodeCallBack)(CountryCode *code);

NS_ASSUME_NONNULL_BEGIN

@interface SelectCountryCodeViewController : BaseViewController

@property (nonatomic, copy) SelectCountryCodeCallBack callback;

@end

NS_ASSUME_NONNULL_END
