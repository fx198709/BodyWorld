//
//  ChatManager.h
//  VConductor
//
//  Created by pliu on 20210521.
//

#import <Foundation/Foundation.h>

#import <VSRTC/VSRTC.h>

@interface ChatManager : NSObject

+ (instancetype)sharedInstance;

- (void)initSDK;

- (void)joinChat:(NSString*)groupId withUserName:(NSString*)userName andUserSig:(NSString*)srvUserSig;
- (void)quitChat;

@end

