//
//  YellinMasterTabBarController.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinMasterTabBarController.h"

@interface YellinMasterTabBarController ()

@end

@implementation YellinMasterTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (YellinMasterTabBarController *)generateMainScreen {
    YellinMasterTabBarController *screen = [[YellinMasterTabBarController alloc] init];
    NSMutableArray *tabs = [[NSMutableArray alloc] init];
    
    // recording tab
    YellinMakeYellViewController *makeYellVC = [[YellinMakeYellViewController alloc] init];
    YellinNavigationViewController *makeYellNVC = [[YellinNavigationViewController alloc] initWithRootViewController:makeYellVC];
    makeYellNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"yell" image:[UIImage imageNamed:@"first"] selectedImage:[UIImage imageNamed:@"first"]];
    makeYellNVC.navigationBarHidden = NO;
    [tabs addObject:makeYellNVC];
    
    // mouth sound responses view
    YellinMouthSoundsViewController *mouthSoundsVC = [[YellinMouthSoundsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    YellinNavigationViewController *mouthSoundsNVC = [[YellinNavigationViewController alloc] initWithRootViewController:mouthSoundsVC];
    mouthSoundsNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"replies" image:[UIImage imageNamed:@"second"] selectedImage:[UIImage imageNamed:@"second"]];
    mouthSoundsNVC.navigationBarHidden = NO;
    [tabs addObject:mouthSoundsNVC];
    
    // make about tab view
    YellinAboutTabViewController *aboutVC = [[YellinAboutTabViewController alloc] init];
    YellinNavigationViewController *aboutNVC = [[YellinNavigationViewController alloc] initWithRootViewController:aboutVC];
    aboutNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"about" image:nil selectedImage:nil];
    aboutNVC.navigationBarHidden = NO;
    [tabs addObject:aboutNVC];
    
    // here do something to see if user is one of the "chosen few"
    if ([PFUser currentUser] // user logged in
        && [[YellinUtility theChosenFew] containsObject:[PFUser currentUser].objectId]) { // and is one of us
        YellinMakeMouthSoundViewController *makeMouthVC = [[YellinMakeMouthSoundViewController alloc] initWithStyle:UITableViewStyleGrouped];
        YellinNavigationViewController *makeMouthNVC = [[YellinNavigationViewController alloc] initWithRootViewController:makeMouthVC];
        makeMouthNVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"mouth sounds" image:nil selectedImage:nil];
        [tabs addObject:makeMouthNVC];
    }
    
    [screen setViewControllers:tabs animated:NO];
    return screen;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
