//
//  YellinMasterTabBarController.h
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "YellinUtility.h"
#import "YellinNavigationViewController.h"
#import "YellinMakeYellViewController.h"
#import "YellinMouthSoundsViewController.h"
#import "YellinMakeMouthSoundViewController.h"

@interface YellinMasterTabBarController : UITabBarController

+ (YellinMasterTabBarController *) generateMainScreen;

@end
