//
//  ConfigManager.h
//  VConductor
//
//  Created by pliu on 20210129.
//

#import <Foundation/Foundation.h>

#import <VSRTC/VSRTC.h>

@interface ConfigManager : NSObject

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* eventId;
@property (nonatomic, strong) NSString* nickName;

+ (instancetype)sharedInstance;

- (void)loadConfig;
- (void)saveConfig;

- (BOOL)isIpadMode;

@end

