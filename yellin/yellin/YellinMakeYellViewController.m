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
    
    YellinMakeYellView *v = [[YellinMakeYellView alloc] initWithFrame:self.view.frame];
    
    // set up recording targets
    [v.recordButton addTarget:self action:@selector(recordButtonPressed) forControlEvents:UIControlEventTouchDown];
    [v.recordButton addTarget:self action:@selector(recordButtonReleased) forControlEvents:UIControlEventTouchUpInside];
    [v.recordButton addTarget:self action:@selector(recordButtonReleased) forControlEvents:UIControlEventTouchUpOutside];
    
    // set up playing targets
    [v.playButton addTarget:self action:@selector(playButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    // set up audio file for recording
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               @"lil_yell.m4a",
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    NSError *err;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:&err];
    if (err) {
        NSLog(@"Error: %@", [err localizedDescription]);
    }
    else {
        self.recorder.delegate = self;
        self.recorder.meteringEnabled = YES;
        [self.recorder prepareToRecord];
    }
    
	self.view = v;
}

- (void)recordButtonPressed {
    NSLog(@"record button pressed");
    
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
            [self.recorder record];
            [NSTimer scheduledTimerWithTimeInterval:0.1
                     target:self selector:@selector(updateMidRecordingStatusView:)
                     userInfo:nil repeats:YES];
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
        v.recordingTimeLabel.text = [NSString stringWithFormat:@"%.02f // %.01f", self.recorder.currentTime, MAX_RECORDING_TIME];
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

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
   
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    NSLog(@"finished recording");
    
    if (flag) {
        YellinMakeYellView *v = (YellinMakeYellView *)self.view;
        [UIView animateWithDuration:1.0 animations:^{
            // animation block
            CGRect f = v.recordButton.frame;
            v.recordButton.frame = CGRectMake(f.origin.x, f.origin.y - 150, f.size.width, f.size.height);
        } completion:^(BOOL finished) {
            // completion block
            [v addPostSoundButtons];
        }];
    }
    else {
        
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
