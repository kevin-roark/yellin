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
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.titleView = [YellinUtility getTitleLabel:@"login to Yellin'"];
    [self.navigationItem.titleView sizeToFit];
    
    UILabel *jumboLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 50)];
    jumboLabel.textAlignment = NSTextAlignmentCenter;
    jumboLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:40.0];
    jumboLabel.textColor = [UIColor colorWithRed:0.08 green:0.08 blue:0.08 alpha:1.0];
    jumboLabel.text = @"Yellin':";
    [self.view addSubview:jumboLabel];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, jumboLabel.frame.origin.y + jumboLabel.frame.size.height, self.view.frame.size.width - 40, 270)];
    subLabel.textAlignment = NSTextAlignmentLeft;
    subLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:24.0];
    subLabel.textColor = [UIColor colorWithRed:0.05 green:0.05 blue:0.05 alpha:1.0];
    subLabel.numberOfLines = 0;
    subLabel.lineBreakMode = NSLineBreakByWordWrapping;
    subLabel.text = @"Record the sounds around you and vocalize your world.\n\nLogin below to get started. Learn what the world sounds like through mouths alone.";
    [self.view addSubview:subLabel];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(20, subLabel.frame.origin.y + subLabel.frame.size.height, self.view.frame.size.width - 40, 75);
    loginButton.layer.cornerRadius = 5.0;
    loginButton.tintColor = [UIColor whiteColor];
    loginButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.3 blue:1.0 alpha:1.0];
    [loginButton setTitle:@"Login with Facebook" forState:UIControlStateNormal];
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
                    [[PFInstallation currentInstallation] setObject:[user objectId] forKey:@"userID"];
                    [[PFInstallation currentInstallation] saveInBackground];
                }
                else {
                    NSLog(@"error with facebook request: %@", [error localizedDescription]);
                }
            }];
            
            [self goToMainTabs];
        } else {
            NSLog(@"User with facebook logged in!");
            user[@"installation"] = [PFInstallation currentInstallation];
            [user saveInBackground];
            [[PFInstallation currentInstallation] setObject:user forKey:@"user"];
            [[PFInstallation currentInstallation] setObject:[user objectId] forKey:@"userID"];
            [[PFInstallation currentInstallation] saveInBackground];
            
            [self goToMainTabs];
        }
    }];
}

- (void)goToMainTabs {
    
    
    
    [self.navigationController popViewControllerAnimated:YES]; // go back to tabs
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
