//
//  AppDelegate.m
//  fitworld
//
//  Created by mac on 2021/7/1.
//

#import "AppDelegate.h"
#import "TUIKit.h"
#import "VConductorClient.h"
#import "UIImage+Extension.h"
#define NavBlackTextColor UIColorFromRGB(0x000000)//导航文字黑色

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[VConductorClient sharedInstance] initSDK];
//    if (@available(iOS 13.0, *)) {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent; //黑色
//    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent; //黑色
//    }
    [self setDefaultTabNavTintColor];
    return YES;
}

- (void)setDefaultTabNavTintColor {
    //去除顶部横线
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]]];
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    
    //UINavigationBar 的设置
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    shadow.shadowOffset = CGSizeMake(0, 0);
    NSDictionary *dic = @{NSForegroundColorAttributeName:UIColor.whiteColor,
                          NSShadowAttributeName:shadow,
                          NSFontAttributeName:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium]};
    [[UINavigationBar appearance] setTitleTextAttributes: dic];
    [[UINavigationBar appearance] setTintColor:UIColor.whiteColor];//设置按钮颜色
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor,NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateDisabled];
//    [[UINavigationBar appearance] setBarTintColor:appBackViewColor];
    
    //设置navigationBar背景颜色，并去除底部分割线
    UIImage *image = [UIImage imageWithColor:[UIColor blackColor]];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].shadowImage = [[UIImage alloc] init];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
//     forBarMetrics:UIBarMetricsDefault];

}



#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentCloudKitContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentCloudKitContainer alloc] initWithName:@"fitworld"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
