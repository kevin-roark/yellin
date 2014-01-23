//
//  YellinRespondToChirpView.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinRespondToChirpView.h"

@implementation YellinRespondToChirpView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self animateRecordButtonUpWithDuration:0.0];
        self.sendButton.enabled = NO;
        self.playButton.enabled = YES;
        [self.playButton setTitle:@"play original sound" forState:UIControlStateNormal];
        
        self.recordButton.frame = CGRectOffset(self.recordButton.frame, 0, -30);
        
        self.mouthPlayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.mouthPlayButton.frame = CGRectOffset(self.playButton.frame, 0, - (self.playButton.frame.size.height + 10));
        self.mouthPlayButton.backgroundColor = [UIColor purpleColor];
        self.mouthPlayButton.tintColor = [UIColor whiteColor];
        [self.mouthPlayButton setTitle:@"hear ur mouth sound" forState:UIControlStateNormal];
        [self addSubview:self.mouthPlayButton];
        self.mouthPlayButton.enabled = NO;
    }
    return self;
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
