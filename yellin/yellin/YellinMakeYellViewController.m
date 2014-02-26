//
//  YellinMakeYellViewController.m
//  yellin
//
//  Created by Kevin Roark on 1/21/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinMakeYellViewController.h"

@interface YellinMakeYellViewController ()

@end

@implementation YellinMakeYellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.makeYellView = [[YellinMakeYellView alloc] initWithFrame:self.view.frame];
    
    self.navigationController.navigationBar.barTintColor = [YellinUtility warmYellinColor];
    self.navigationItem.titleView = [YellinUtility getTitleLabel:@"record a sound"];
    [self.navigationItem.titleView sizeToFit];
    
    // set up recording targets
    [self.makeYellView.recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.makeYellView.recordButton addTarget:self action:@selector(recordButtonReleased) forControlEvents:UIControlEventTouchUpInside];
    [self.makeYellView.recordButton addTarget:self action:@selector(recordButtonReleased) forControlEvents:UIControlEventTouchUpOutside];
    
    // set up playing targets
    [self.makeYellView.playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // set up sending targets
    [self.makeYellView.sendButton addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // set up recorder
    self.recorder = [YellinAudioRecorder getConfiguredRecorderWithFileName:@"lil_yell.m4a"];
    self.recorder.delegate = self;
    [self.recorder prepareToRecord];
    
    self.view = self.makeYellView;
    
    // have to login if necessary
    if (![PFUser currentUser] || ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"user not logged in");
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:NO];
    }
    else {
        NSLog(@"User is logged in");
        NSLog(@"Current user: %@", [PFUser currentUser].description);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UINavigationBar appearance].barTintColor = [YellinUtility warmYellinColor];
}

- (void)recordButtonPressed {
    NSLog(@"record button pressed oh yeah");
    
    // Setup audio session for recording
    NSError *err;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    if (err) {
        NSLog(@"Error setting playback: %@", [err localizedDescription]);
    }
    
    if (self.player.playing) { // shouldn't happen, but doesn't hurt
        [self.player stop];
    }
        
    if (!self.recorder.recording) { // again this should always be the case
        NSError *err;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:&err];
        if (err) {
            NSLog(@"Error: %@", [err localizedDescription]);
        }
        else {
            [self startRecording];
        }
    }
}

- (void)startRecording {
    [NSTimer scheduledTimerWithTimeInterval:0.1
            target:self selector:@selector(updateMidRecordingStatusView:)
            userInfo:nil repeats:YES];
    [self.recorder record];
}

- (void)recordButtonReleased {
    NSLog(@"record button released");
    
    CGFloat recordingLength = self.recorder.currentTime;
    [self.recorder stop];
    
    if (!self.makeYellView.performedInitialAnimation && recordingLength > MIN_RECORDING_TIME) {
        [self.makeYellView animateRecordButtonUpWithDuration:1.0];
    }
    
    // Setup audio session for playing
    NSError *err;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&err];
    if (err) {
        NSLog(@"Error setting playback: %@", [err localizedDescription]);
    }
    
    // in the future would be cool to change to 'pause' ala vine so that u can compose
    // sound from multiple places u know but pause doesn't set off the finished recording event
}

- (void)updateMidRecordingStatusView:(NSTimer *)timer {
    if (self.recorder.recording) {
        if (self.recorder.currentTime <= MAX_RECORDING_TIME + 0.04) {
            [self.makeYellView updateRecordingLengthStatus:self.recorder.currentTime];
        }
        else {
            [timer invalidate];
            timer = nil;
            self.makeYellView.backgroundColor = [UIColor whiteColor];
            [self recordButtonReleased];
        }
    }
    else if (timer && !self.recorder.recording) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)updateMidPlayingStatusView:(NSTimer *)timer {
    if (self.player.playing) {
        [self.makeYellView updateRecordingLengthStatus:self.player.currentTime];
    }
    else if (timer && !self.player.playing) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)playButtonPressed {
    if (!self.recorder.recording) { // again just a safe-catch-all or whatever
        NSError *err;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:&err];
        if (err) {
            NSLog(@"Error: %@", [err localizedDescription]);
        }
        else {
            self.player.delegate = self;
            [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self selector:@selector(updateMidPlayingStatusView:)
                                           userInfo:nil repeats:YES];
            [self.player play];
        }
    }
}

- (void)sendButtonPressed {
    NSLog(@"send button pressed");
    [self.makeYellView setToUploading:YES];
    
    NSData *audioData = [NSData dataWithContentsOfURL:self.recorder.url];
    PFFile *audioFile = [PFFile fileWithData:audioData];
    [audioFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // audio is uploaded to parse!!
        if (!error) {
            NSLog(@"uploaded audio, creating chirp object");
            PFObject *chirp = [PFObject objectWithClassName:CHIRP_PARSE_KEY];
            chirp[@"original_sound"] = audioFile;
            chirp[@"has_mouth_sound"] = [NSNumber numberWithBool:NO];
            chirp[@"from_user"] = [PFUser currentUser];
            chirp[@"mouth_plays"] = [NSNumber numberWithInt:0];
            [chirp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"created chirp objectttt");
                    [self.makeYellView setToUploading:NO];
                    [self.makeYellView revertToOriginalState];
                    
                    // should send a push notification to us
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"userID" containedIn:[[YellinUtility theChosenFew] allObjects]];
                    NSLog(@"yellin utility as array: %@", [[YellinUtility theChosenFew] allObjects]);
                    
                    NSDictionary *pushData = @{
                        @"alert":[NSString stringWithFormat:@"new yell from: %@", [[PFUser currentUser] objectForKey:@"name"]],
                        @"badge": @"Increment",
                        @"initialView": MOUTH_RESPONSE_TAB
                    };
                    PFPush *godPush = [[PFPush alloc] init];
                    [godPush setQuery:pushQuery];
                    [godPush setData:pushData];
                    [godPush sendPushInBackground];
                    
                    NSLog(@"sent push to gods");
                }
                else {
                    NSLog(@"failed to create chirp: %@", [error localizedDescription]);
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

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
   
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    NSLog(@"finished recording");
    
    if (!flag) {
        NSLog(@"failed recording ...");
    }
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
