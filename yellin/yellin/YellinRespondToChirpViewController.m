//
//  YellinRespondToChirpViewController.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinRespondToChirpViewController.h"

@interface YellinRespondToChirpViewController ()

@end

@implementation YellinRespondToChirpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    YellinRespondToChirpView *chirpResponseView = [[YellinRespondToChirpView alloc] initWithFrame:self.view.frame];
    
    // set up play buttons
    [chirpResponseView.sendButton addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [chirpResponseView.playButton addTarget:self action:@selector(playOriginalSoundButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [chirpResponseView.mouthPlayButton addTarget:self action:@selector(playMouthSoundButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // set up record button
    [chirpResponseView.recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchDown];
    [chirpResponseView.recordButton addTarget:self action:@selector(recordButtonReleased) forControlEvents:UIControlEventTouchUpInside];
    [chirpResponseView.recordButton addTarget:self action:@selector(recordButtonReleased) forControlEvents:UIControlEventTouchUpOutside];
    
    // set up recorder
    self.recorder = [YellinAudioRecorder getConfiguredRecorderWithFileName:@"lil_yell.m4a"];
    self.recorder.delegate = self;
    [self.recorder prepareToRecord];
    
    // set up original sound player
    PFFile *originalAudioFile = [self.chirp objectForKey:@"original_sound"];
    self.originalPlayer = [YellinAudioPlayer getConfiguredPlayerWithParseAudioFile:originalAudioFile];
    self.originalPlayer.delegate = self;
    
    self.navigationController.navigationBarHidden = NO;
    self.view = chirpResponseView;
}

- (void)sendButtonPressed {
    NSLog(@"send button pressed");
    NSData *audioData = [NSData dataWithContentsOfURL:self.recorder.url];
    PFFile *audioFile = [PFFile fileWithData:audioData];
    [audioFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // audio is uploaded to parse!!
        if (!error) {
            NSLog(@"uploaded audio, updating chirp object");
            self.chirp[@"mouth_sound"] = audioFile;
            self.chirp[@"has_mouth_sound"] = [NSNumber numberWithBool:YES];
            self.chirp[@"active_mouth_sound"] = [NSNumber numberWithBool:YES];
            self.chirp[@"mouthing_user"] = [PFUser currentUser];
            self.chirp[@"respondedAt"] = [NSDate date];
            [self.chirp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"updated chirp objectttt");
                    
                    // send push notification to user
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"user" equalTo:[self.chirp objectForKey:@"from_user"]];
                    NSLog(@"object for user key: %@", [self.chirp objectForKey:@"from_user"]);
                    NSDictionary *pushData = @{
                        @"alert": @"u got a new mouth sound !!",
                        @"badge": @"Increment",
                        @"initialView": MOUTH_SOUNDS_TAB
                    };
                    PFPush *responsePush = [[PFPush alloc] init];
                    [responsePush setQuery:pushQuery];
                    [responsePush setData:pushData];
                    [responsePush sendPushInBackground];
                    
                    NSLog(@"sent push to user");
                    
                    // display alert to us
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Got ur mouth sound"
                                                              message:@"Its in there"
                                                              delegate:self
                                                              cancelButtonTitle:@"Bye"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
                else {
                    NSLog(@"failed to update chirp: %@", [error localizedDescription]);
                }
            }];
        }
        else {
            NSLog(@"failed to upload audio: %@", [error localizedDescription]);
        }
    } progressBlock:^(int percentDone) {
        // code to display percent of audio uploaded or something
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // alert for completed mouth sound
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playOriginalSoundButtonPressed {
    if (self.originalPlayer.playing) {
        [self.originalPlayer pause];
        self.originalPlayer.currentTime = 0.0;
    }
    [self.originalPlayer play];
}

- (void)playMouthSoundButtonPressed {
    if (!self.recorder.recording) { // again just a safe-catch-all or whatever
        NSError *err;
        self.mouthPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:&err];
        if (err) {
            NSLog(@"Error: %@", [err localizedDescription]);
        }
        else {
            self.mouthPlayer.delegate = self;
            [self.mouthPlayer play];
        }
    }
}

- (void)recordButtonPressed {
    NSLog(@"record button pressed oh yeah");
    
    if (self.originalPlayer.playing) { // shouldn't happen, but doesn't hurt
        [self.originalPlayer stop];
    }
    if (self.mouthPlayer.playing) { // shouldn't happen, but doesn't hurt
        [self.mouthPlayer stop];
    }
    
    if (!self.recorder.recording) { // again this should always be the case
        NSError *err;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:&err];
        if (err) {
            NSLog(@"Error starting recording: %@", [err localizedDescription]);
        }
        else {
            [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self selector:@selector(updateMidRecordingStatusView:)
                                           userInfo:nil repeats:YES];
            [self.recorder record];
        }
    }
}

- (void)recordButtonReleased {
    NSLog(@"record button released");
    [self.recorder stop];
    
    // in the future would be cool to change to 'pause' ala vine so that u can compose
    // sound from multiple places u know but pause doesn't set off the finished recording event
}

- (void)updateMidRecordingStatusView:(NSTimer *)timer {
    if (self.recorder.recording) {
        YellinMakeYellView *v = (YellinMakeYellView *)self.view;
        [v updateRecordingLengthStatus:self.recorder.currentTime];
    }
    else if (timer && !self.recorder.recording) {
        [timer invalidate];
        timer = nil;
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag {
    NSLog(@"finished recording");
    YellinRespondToChirpView *v = (YellinRespondToChirpView *)self.view;
    v.sendButton.enabled = YES;
    v.mouthPlayButton.enabled = YES;
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
