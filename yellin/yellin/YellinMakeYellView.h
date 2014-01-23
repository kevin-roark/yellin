//
//  YellinMakeYellView.h
//  yellin
//
//  Created by Kevin Roark on 1/21/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YellinConstants.h"

@interface YellinMakeYellView : UIView

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UILabel *recordingTimeLabel;

- (void) addPostSoundButtons;
- (void) removePostSoundButtons;

- (void) animateRecordButtonUpWithDuration:(CGFloat)duration;

- (void) updateRecordingLengthStatus:(NSTimeInterval)currentLength;

@end
