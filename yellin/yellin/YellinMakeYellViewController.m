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
    
    //self.navigationItem.titleView = [YellinUtility getTitleLabel:@"record a sound"];
    //[self.navigationItem.titleView sizeToFit];
    //self.navigationItem.title = @"record a sound";
    
    self.makeYellView = [[YellinMakeYellView alloc]
                             initWithFrame:CGRectMake(0, 56, self.view.frame.size.width, self.view.frame.size.height - 56)];
    
    // set up title stuff
    UILabel *titleLabel = [YellinUtility getTitleLabel:@"record a sound"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.frame = CGRectMake(0, 5, self.view.frame.size.width, 60);
    [self.view addSubview:titleLabel];
    
    self.view.backgroundColor = [YellinUtility warmYellinColor];
    
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
    
    [self.view addSubview:self.makeYellView];
    
    // have to login if necessary
    if (![PFUser currentUser] || ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        NSLog(@"user not logged in");
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:NO];
    }
    else {
        NSLog(@"User is logged in");
        NSLog(@"Current user: %@", [PFUser currentUser].description);
    }
}

- (void)recordButtonPressed {
    NSLog(@"record button pressed oh yeah");
    
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
    [self.recorder stop];
    
    if (!self.makeYellView.performedInitialAnimation) {
        [self.makeYellView animateRecordButtonUpWithDuration:1.0];
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
            [self recordButtonReleased];
        }
    }
    else if (timer && !self.recorder.recording) {
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
            [self.player play];
        }
    }
}

- (void)sendButtonPressed {
    NSLog(@"send button pressed");
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
            [chirp saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"created chirp objectttt");
                    [self.makeYellView revertToOriginalState];
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
