//
//  YellinMouthSoundsViewController.h
//  yellin
//
//  Created by Kevin Roark on 1/21/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "YellinConstants.h"
#import "YellinUtility.h"
#import "YellinSoundRespondedCell.h"
#import "YellinAudioPlayer.h"
#import "YellinAudioPlayerCache.h"

@interface YellinMouthSoundsViewController : PFQueryTableViewController

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic) BOOL nothingHere;
@property (nonatomic, strong) UILabel *nothingHereLabel;

@property (nonatomic, strong) YellinSoundRespondedCell *activeCell;

@property (nonatomic, strong) YellinAudioPlayerCache *playerCache;

@end
