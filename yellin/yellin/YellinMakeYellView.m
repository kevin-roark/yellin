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
        
        self.recordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.recordButton.frame = CGRectMake(self.frame.size.width/2 - 75, self.frame.size.height - 220, 150, 150);
        self.recordButton.backgroundColor = [UIColor redColor];
        self.recordButton.layer.cornerRadius = 75;
        self.recordButton.enabled = YES;
        [self addSubview:self.recordButton];
        
        self.playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.playButton.frame = CGRectMake(20, self.frame.size.height - 25, self.frame.size.width - 40, 50);
        self.playButton.backgroundColor = [UIColor greenColor];
        self.playButton.tintColor = [UIColor whiteColor];
        [self.playButton setTitle:@"play" forState:UIControlStateNormal];
        [self addSubview:self.playButton];
        
        self.sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.sendButton.frame = CGRectOffset(self.playButton.frame, 0, 60);
        self.sendButton.backgroundColor = [UIColor orangeColor];
        self.sendButton.tintColor = [UIColor whiteColor];
        [self.sendButton setTitle:@"send to us" forState:UIControlStateNormal];
        [self addSubview:self.sendButton];
        
        self.recordingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, self.frame.size.width - 20, 60)];
        self.recordingTimeLabel.textColor = [UIColor blackColor];
        self.recordingTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.recordingTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:40.0];
        self.recordingTimeLabel.text = @"";
        [self addSubview:self.recordingTimeLabel];
    }
    return self;
}

- (void)addPostSoundButtons {
    //[self addSubview:self.playButton];
    //[self addSubview:self.sendButton];
}

- (void)removePostSoundButtons {
    //[self.playButton removeFromSuperview];
    //[self.sendButton removeFromSuperview];
}

- (void)animateRecordButtonUpWithDuration:(CGFloat)duration {
    self.performedInitialAnimation = YES;
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
    
    [UIView animateWithDuration:1.0 animations:^{
        // animation block
        self.recordButton.frame = CGRectOffset(self.recordButton.frame, 0, 150);
        self.playButton.frame = CGRectOffset(self.playButton.frame, 0, 150);
        self.sendButton.frame = CGRectOffset(self.sendButton.frame, 0, 150);
    } completion:^(BOOL finished) {
        // completion block
    }];
}

- (void) updateRecordingLengthStatus:(NSTimeInterval)currentLength {
    self.recordingTimeLabel.text = [NSString stringWithFormat:@"%.01f // %.01f", currentLength, MAX_RECORDING_TIME];
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
