#import "ConfigManager.h"
#import <UIKit/UIKit.h>

#define USER_ID_KEY           @"VSV_USER_ID_KEY"
#define EVENT_ID_KEY          @"VSV_EVENT_ID_KEY"
#define NICK_NAME_KEY         @"VSV_NICK_NAME_KEY"
#define LANGUAGE_KEY         @"VSV_LANGUAGE_KEY"

@interface ConfigManager() {
    
}
@end

@implementation ConfigManager

+ (instancetype)sharedInstance {
    static ConfigManager * instance;
    if (!instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance = [[[self class] alloc] init];
            [instance loadConfig];
        });
    }
    return instance;
}

- (void)loadConfig {
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:USER_ID_KEY];
    if(self.userId == nil) {
        self.userId = @"";
    }
    self.eventId = [[NSUserDefaults standardUserDefaults] objectForKey:EVENT_ID_KEY];
    if(self.eventId == nil) {
        self.eventId = @"";
    }
    self.nickName = [[NSUserDefaults standardUserDefaults] objectForKey:NICK_NAME_KEY];
    if(self.nickName == nil) {
        self.nickName = @"";
    }
    
    NSString *lanStr = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_KEY];
    if(lanStr == nil) {
        //根据系统语言判断
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSArray* languagesArray = [defaults objectForKey:@"AppleLanguages"];
        NSString* systemlanguage = [languagesArray objectAtIndex:0];
        if([systemlanguage.lowercaseString containsString:@"zh-"]){
            self.language = LanguageEnum_Chinese;
        } else {
            self.language = LanguageEnum_English;
        }
        
    } else {
        self.language = [lanStr intValue];
    }
}

- (void)saveConfig {
    [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:self.eventId forKey:EVENT_ID_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:self.nickName forKey:NICK_NAME_KEY];
    [[NSUserDefaults standardUserDefaults] setObject:IntToString(self.language) forKey:LANGUAGE_KEY];
}

- (BOOL)isIpadMode {
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if ([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    } else if ([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    } else if ([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
}

@end
