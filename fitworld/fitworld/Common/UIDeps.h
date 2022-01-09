
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define  UIColorFromRGBA(r,g,b,a) [UIColor colorWithRed:r / 255.0  green:g / 255.0 blue:b / 255.0 alpha:a]

#define UIColorFromRGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define LightGreen UIColorFromRGBHex(0x4BA9AC);
#define DarkGreen UIColorFromRGBHex(0x297274);

#import "Masonry.h"
#import "MaterialDesignSymbol.h"
#import "EntypoSymbol.h"
#import "MaterialDesignColor.h"

#import "MBProgressHUD.h"
#import "JTMaterialSwitch.h"
#import "ConsoleTextView.h"
#import "TWSReleaseNotesView.h"

#import <SDWebImage/SDWebImage.h>

