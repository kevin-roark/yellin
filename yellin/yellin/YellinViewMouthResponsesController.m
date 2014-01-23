//
//  YellinViewMouthResponsesController.m
//  yellin
//
//  Created by Kevin Roark on 1/23/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinViewMouthResponsesController.h"

@interface YellinViewMouthResponsesController ()

@end

@implementation YellinViewMouthResponsesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableVC = [[YellinMouthSoundsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
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
