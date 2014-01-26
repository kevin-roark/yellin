//
//  YellinMakeYellView.h
//  yellin
//
//  Created by Kevin Roark on 1/21/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YellinConstants.h"
#import "YellinUtility.h"

@interface YellinMakeYellView : UIView

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) UILabel *recordingTimeLabel;

@property (nonatomic, strong) UILabel *uploadingLabel;

@property (nonatomic) BOOL performedInitialAnimation;

- (void) addPostSoundButtons;
- (void) removePostSoundButtons;

- (void) animateRecordButtonUpWithDuration:(CGFloat)duration;

- (void) updateRecordingLengthStatus:(NSTimeInterval)currentLength;

@property (nonatomic, strong) NSTimer *uploadingTimer;
- (void) setToUploading:(BOOL)wantUploading;
- (void) updateUploadingView;

- (void) revertToOriginalState;

@end
