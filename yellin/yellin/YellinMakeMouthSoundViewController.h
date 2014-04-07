//
//  YellinMakeMouthSoundViewController.h
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "YellinConstants.h"
#import "YellinMakeMouthSoundView.h"
#import "YellinSoundNeedsMouthCell.h"
#import "YellinRespondToChirpViewController.h"

@interface YellinMakeMouthSoundViewController : PFQueryTableViewController

@property (nonatomic, strong) UILabel *yellsTodoLabel;

@end
