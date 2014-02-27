//
//  YellinNavigationViewController.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinNavigationViewController.h"
#import "YellinUtility.h"

@interface YellinNavigationViewController ()

@end

@implementation YellinNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
    
    //self.navigationBar.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    self.navigationBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
