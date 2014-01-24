//
//  YellinAudioTimelineView.h
//  yellin
//
//  Created by Kevin Roark on 1/24/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YellinAudioTimelineView : UIView

@property (nonatomic, strong) UIView *timeline;
@property (nonatomic, strong) UIView *currentTimeMarker;

- (void)startAnimationofTotalSeconds:(CGFloat)totalSeconds;

- (void)cancelAnimation;

@end
