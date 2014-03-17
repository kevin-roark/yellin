//
//  YellinAudioTimelineView.m
//  yellin
//
//  Created by Kevin Roark on 1/24/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinAudioTimelineView.h"

@implementation YellinAudioTimelineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.timeline = [[UIView alloc] initWithFrame:CGRectMake(0, 1.75, frame.size.width, 3)];
        self.timeline.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.timeline];
        
        self.currentTimeMarker = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        self.currentTimeMarker.layer.cornerRadius = 5;
        self.currentTimeMarker.backgroundColor = [UIColor blackColor];
        [self addSubview:self.currentTimeMarker];
    }
    return self;
}

- (void)startAnimationofTotalSeconds:(CGFloat)totalSeconds {
    self.currentTimeMarker.frame = CGRectMake(0, 0, 8, 8);
    [UIView animateWithDuration:totalSeconds animations:^{
        self.currentTimeMarker.frame = CGRectOffset(self.currentTimeMarker.frame, self.frame.size.width - self.currentTimeMarker.frame.size.width, 0);
    } completion:^(BOOL finished) {
        if (finished) {
            self.currentTimeMarker.frame = CGRectMake(0, 0, 8, 8);
        }
    }];
}

- (void)cancelAnimation {
    [self.layer removeAllAnimations];
    self.currentTimeMarker.frame = CGRectMake(0, 0, 8, 8);
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
