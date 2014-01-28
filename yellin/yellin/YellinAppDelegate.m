//
//  YellinAppDelegate.m
//  yellin
//
//  Created by Kevin Roark on 1/20/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinAppDelegate.h"

@implementation YellinAppDelegate

#define PARSE_APPLICATION_ID @"wlUxgDnv10baqrdV8cs5lCwva3V6n3IMuHVOmxdA"
#define PARSE_CLIENT_KEY     @"AzHkvrwtwADFpBXg519aHx3BJM1mWpzYWOqQxQin"


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [Parse setApplicationId:PARSE_APPLICATION_ID
                  clientKey:PARSE_CLIENT_KEY];
    [PFFacebookUtils initializeFacebook];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // make the tab stuff
    self.master = [YellinMasterTabBarController generateMainScreen];
    
    // see if we opened from a push
    NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notificationPayload) {
        [self setActiveTabFromPushNotificationData:notificationPayload];
    }
    
    // boilerplate
    self.navigationController = [[YellinNavigationViewController alloc] initWithRootViewController:self.master];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    // register for notifications
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // save this damn device that wants push notifications
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // handle a push notification while the app is active
    
    [PFPush handlePush:userInfo];
    //[self setActiveTabFromPushNotificationData:userInfo];
}

- (void)setActiveTabFromPushNotificationData:(NSDictionary *)pushData {
    NSString *activeTab = pushData[@"initialView"];
    if ([activeTab isEqualToString:MOUTH_SOUNDS_TAB]) {
        self.master.selectedViewController = [self.master.viewControllers objectAtIndex:1]; // second tab is mouth sounds
    }
    else if ([activeTab isEqualToString:MOUTH_RESPONSE_TAB]) {
        self.master.selectedViewController = [self.master.viewControllers objectAtIndex:3]; // last tab is our response tab
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL toReturn = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
    return toReturn;
}

@end
