//
//  YellinAppDelegate.h
//  yellin
//
//  Created by Kevin Roark on 1/20/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "YellinMasterTabBarController.h"
#import "YellinNavigationViewController.h"

@interface YellinAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, strong) YellinMasterTabBarController *master;

@end
