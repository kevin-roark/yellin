//
//  YellinMakeYellView.m
//  yellin
//
//  Created by Kevin Roark on 1/21/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinMakeYellView.h"

@implementation YellinMakeYellView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.performedInitialAnimation = NO;
        
        self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.recordButton.frame = CGRectMake(self.frame.size.width/2 - 75, self.frame.size.height - 220, 150, 150);
        self.recordButton.backgroundColor = [UIColor redColor];
        self.recordButton.layer.cornerRadius = 75;
        self.recordButton.enabled = YES;
        [self addSubview:self.recordButton];
        
        self.instructionLabel = [[UILabel alloc]
                                 initWithFrame:CGRectMake(10, self.frame.size.height - 72, self.frame.size.width - 20, 20)];
        self.instructionLabel.textAlignment = NSTextAlignmentCenter;
        self.instructionLabel.textColor = [UIColor darkGrayColor];
        self.instructionLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        self.instructionLabel.text = @"hold the button to record";
        [self addSubview:self.instructionLabel];
        
        /* now calling this in controller for speed?
        [self.recordButton addTarget:self action:@selector(recordButtonTouchdown) forControlEvents:UIControlEventTouchDown];
        [self.recordButton addTarget:self action:@selector(recordButtonTouchup) forControlEvents:UIControlEventTouchUpOutside];
        [self.recordButton addTarget:self action:@selector(recordButtonTouchup) forControlEvents:UIControlEventTouchUpInside];
        */
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.playButton.frame = CGRectMake(20, self.frame.size.height - 25, self.frame.size.width - 40, 50);
        self.playButton.backgroundColor = [UIColor greenColor];
        self.playButton.tintColor = [UIColor whiteColor];
        [self.playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.playButton setTitle:@"play" forState:UIControlStateNormal];
        [self addSubview:self.playButton];
        
        [self.playButton addTarget:self action:@selector(playButtonTouchdown) forControlEvents:UIControlEventTouchDown];
        [self.playButton addTarget:self action:@selector(playButtonTouchup) forControlEvents:UIControlEventTouchUpOutside];
        [self.playButton addTarget:self action:@selector(playButtonTouchup) forControlEvents:UIControlEventTouchUpInside];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendButton.frame = CGRectOffset(self.playButton.frame, 0, 60);
        self.sendButton.backgroundColor = [UIColor orangeColor];
        self.sendButton.tintColor = [UIColor whiteColor];
        [self.sendButton setTitle:@"send to us" forState:UIControlStateNormal];
        [self addSubview:self.sendButton];
        
        [self.sendButton addTarget:self action:@selector(sendButtonTouchdown) forControlEvents:UIControlEventTouchDown];
        [self.sendButton addTarget:self action:@selector(sendButtonTouchup) forControlEvents:UIControlEventTouchUpOutside];
        [self.sendButton addTarget:self action:@selector(sendButtonTouchup) forControlEvents:UIControlEventTouchUpInside];
        
        self.recordingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, self.frame.size.width - 20, 60)];
        self.recordingTimeLabel.textColor = [UIColor blackColor];
        self.recordingTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.recordingTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:40.0];
        self.recordingTimeLabel.text = @"";
        [self addSubview:self.recordingTimeLabel];
        
        self.uploadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.frame.size.width - 20, 100)];
        self.uploadingLabel.textColor = [YellinUtility getRandomColor];
        self.uploadingLabel.text = @"creating ur yell ...";
        self.uploadingLabel.font = [UIFont fontWithName:@"Helvetica" size:35.0];
        self.uploadingLabel.numberOfLines = 0;
        self.uploadingLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)playButtonTouchup {
    self.backgroundColor = [UIColor whiteColor];
    self.recordingTimeLabel.textColor = [UIColor blackColor];
}

- (void)playButtonTouchdown {
    self.backgroundColor = [YellinUtility lighterYellinGreen];
    self.recordingTimeLabel.textColor = [UIColor whiteColor];
}

- (void)recordButtonTouchup {
    if (!self.performedInitialAnimation) {
        self.instructionLabel.text = @"hold the button to record";
    }
    self.backgroundColor = [UIColor whiteColor];
    self.recordingTimeLabel.textColor = [UIColor blackColor];
}

- (void)recordButtonTouchdown {
    self.instructionLabel.text = @"";
    self.backgroundColor = [YellinUtility lighterRecordColor];
    self.recordingTimeLabel.textColor = [UIColor whiteColor];
}

- (void)sendButtonTouchup {
    self.backgroundColor = [UIColor whiteColor];
    self.recordingTimeLabel.textColor = [UIColor blackColor];
}

- (void)sendButtonTouchdown {
    self.backgroundColor = [YellinUtility lighterSendColor];
    self.recordingTimeLabel.textColor = [UIColor whiteColor];
}

- (void)addPostSoundButtons {
    //[self addSubview:self.playButton];
    //[self addSubview:self.sendButton];
}

- (void)removePostSoundButtons {
    //[self.playButton removeFromSuperview];
    //[self.sendButton removeFromSuperview];
}

- (void)setToUploading:(BOOL)wantUploading {
    if (wantUploading) {
        [self addSubview:self.uploadingLabel];
        self.sendButton.enabled = NO;
        self.playButton.enabled = NO;
        self.uploadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.28
            target:self selector:@selector(updateUploadingView) userInfo:nil repeats:YES];
    } else {
        //[self.uploadingLabel removeFromSuperview];
        self.sendButton.enabled = YES;
        self.sendButton.enabled = YES;
        [self.uploadingTimer invalidate];
        self.uploadingTimer = nil;
    }
}

- (void)updateUploadingView {
    static BOOL goingRight = YES;
    self.uploadingLabel.textColor = [YellinUtility getRandomColor];
    [UIView animateWithDuration:self.uploadingTimer.timeInterval animations:^{
        if (goingRight) {
            self.uploadingLabel.frame = CGRectOffset(self.uploadingLabel.frame, 3, 0);
        } else {
            self.uploadingLabel.frame = CGRectOffset(self.uploadingLabel.frame, -3, 0);
        }
    }];
    goingRight = !goingRight;
}

- (void)animateRecordButtonUpWithDuration:(CGFloat)duration {
    self.performedInitialAnimation = YES;
    self.instructionLabel.text = @"";
    [UIView animateWithDuration:duration animations:^{
        // animation block
        self.recordButton.frame = CGRectOffset(self.recordButton.frame, 0, -150);
        self.playButton.frame = CGRectOffset(self.playButton.frame, 0, -150);
        self.sendButton.frame = CGRectOffset(self.sendButton.frame, 0, -150);
    } completion:^(BOOL finished) {
        // completion block
    }];
}

- (void)revertToOriginalState {
    self.performedInitialAnimation = NO;
    self.recordingTimeLabel.text = @"";
    self.uploadingLabel.text = @"ALL DONE!!";
    self.instructionLabel.alpha = 0.0;
    
    [self performRevertAnimation];  
}

- (void)performRevertAnimation {
    [UIView animateWithDuration:1.0 animations:^{
        // animation block
        self.recordButton.frame = CGRectOffset(self.recordButton.frame, 0, 150);
        self.playButton.frame = CGRectOffset(self.playButton.frame, 0, 150);
        self.sendButton.frame = CGRectOffset(self.sendButton.frame, 0, 150);
        self.uploadingLabel.alpha = 0.0;
        self.instructionLabel.alpha = 0.4;
    } completion:^(BOOL finished) {
        // completion block
        self.uploadingLabel.text = @"creating ur yell ...";
        self.uploadingLabel.alpha = 1.0;
        [self.uploadingLabel removeFromSuperview];
        self.instructionLabel.alpha = 1.0;
        self.instructionLabel.text = @"hold the button to record";
    }];
}

- (void) updateRecordingLengthStatus:(NSTimeInterval)currentLength {
    if (currentLength < 0.05)
        return;
    
    NSTimeInterval lengthToShow = MIN(currentLength, MAX_RECORDING_TIME);
    self.recordingTimeLabel.text = [NSString stringWithFormat:@"%.01f // %.01f", lengthToShow, MAX_RECORDING_TIME];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
