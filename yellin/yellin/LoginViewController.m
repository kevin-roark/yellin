//
//  LoginViewController.m
//  yellin
//
//  Created by Kevin Roark on 1/21/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    NSLog(@"loading login view controller");
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(20, 100, self.view.frame.size.width - 40, 50);
    loginButton.tintColor = [UIColor whiteColor];
    loginButton.backgroundColor = [UIColor blueColor];
    [loginButton setTitle:@"Login with faceblog" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (IBAction)loginButtonTouchHandler:(id)sender  {
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_location"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            
            // new user so add real name and other stuff if want
            FBRequest *facebookRequest = [FBRequest requestForMe];
            [facebookRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary *userData = (NSDictionary *)result;
                    NSLog(@"%@", userData[@"name"]);
                    user[@"name"] = userData[@"name"];
                    user[@"installation"] = [PFInstallation currentInstallation];
                    user[@"is_god"] = [NSNumber numberWithBool:NO];
                    [user saveInBackground];
                    [[PFInstallation currentInstallation] setObject:user forKey:@"user"];
                    [[PFInstallation currentInstallation] saveInBackground];
                }
                else {
                    NSLog(@"error with facebook request: %@", [error localizedDescription]);
                }
            }];
            
            [self.navigationController popViewControllerAnimated:YES]; // go back to tabs
        } else {
            NSLog(@"User with facebook logged in!");
            [self.navigationController popViewControllerAnimated:YES]; // go back to tabs
        }
    }];
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
