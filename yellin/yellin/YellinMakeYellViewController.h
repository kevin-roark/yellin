//
//  YellinMakeYellViewController.h
//  yellin
//
//  Created by Kevin Roark on 1/21/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>
#import "LoginViewController.h"
#import "YellinUtility.h"
#import "YellinConstants.h"
#import "YellinMakeYellView.h"
#import "YellinAudioRecorder.h"

@interface YellinMakeYellViewController : UIViewController<AVAudioPlayerDelegate, AVAudioRecorderDelegate>

@property (nonatomic, strong) YellinMakeYellView *makeYellView;

@property (nonatomic, strong) YellinAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic) BOOL changedSound;

@end
