//
//  AppDelegate.h
//  fitworld
//
//  Created by mac on 2021/7/1.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;
@property(nonatomic, assign) BOOL allowRotation; 

@property (readonly, strong) NSPersistentCloudKitContainer *persistentContainer;

- (void)saveContext;


@end

