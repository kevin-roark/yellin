//
//  YellinRespondToChirpViewController.h
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>
#import "YellinRespondToChirpView.h"
#import "YellinAudioRecorder.h"
#import "YellinAudioPlayer.h"

@interface YellinRespondToChirpViewController : UIViewController<AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) PFObject *chirp;

@property (nonatomic, strong) YellinAudioRecorder *recorder;

@property (nonatomic, strong) AVAudioPlayer *originalPlayer;
@property (nonatomic, strong) AVAudioPlayer *mouthPlayer;

@end
