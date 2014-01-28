//
//  YellinSoundRespondedCell.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinSoundRespondedCell.h"

@implementation YellinSoundRespondedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier chirpObject:(PFObject *)chirp {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.chirp = chirp;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 77);
        
        self.playOriginalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.playOriginalButton.frame = CGRectMake(18.0, 6.0, 117.0, 40);
        self.playOriginalButton.tintColor = [UIColor whiteColor];
        self.playOriginalButton.backgroundColor = [YellinSoundRespondedCell originalButtonColor];
        [self.playOriginalButton setTitle:@"ur's" forState:UIControlStateNormal];
        [self addSubview:self.playOriginalButton];
        
        self.playMouthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.playMouthButton.frame = CGRectMake(self.playOriginalButton.frame.origin.x + self.playOriginalButton.frame.size.width + 6, 6.0, 117.0, 40);
        self.playMouthButton.tintColor = [UIColor whiteColor];
        self.playMouthButton.backgroundColor = [YellinSoundRespondedCell mouthButtonColor]; 
        [self.playMouthButton setTitle:@"mouth's" forState:UIControlStateNormal];
        
        self.originalTimeline = [[YellinAudioTimelineView alloc]
                                 initWithFrame:CGRectMake(self.playOriginalButton.frame.origin.x,
                                                          self.playOriginalButton.frame.origin.y + self.playOriginalButton.frame.size.height + 2,
                                                          self.playOriginalButton.frame.size.width, 10)];
        [self addSubview:self.originalTimeline];
        
        self.mouthTimeline = [[YellinAudioTimelineView alloc]
                              initWithFrame:CGRectMake(self.playMouthButton.frame.origin.x,
                                                       self.playMouthButton.frame.origin.y + self.playMouthButton.frame.size.height + 2,
                                                       self.playMouthButton.frame.size.width, 10)];
        
        self.playsRemainingLabel = [[UILabel alloc] init];
        NSNumber *mouthPlays = [self.chirp objectForKey:@"mouth_plays"];
        int playsRemaining = MAX_MOUTH_PLAYS - [mouthPlays intValue];
        self.playsRemainingLabel.text = [NSString stringWithFormat:@"%d", playsRemaining];
        self.playsRemainingLabel.textAlignment = NSTextAlignmentCenter;
        self.playsRemainingLabel.frame = CGRectMake(self.playMouthButton.frame.origin.x + self.playMouthButton.frame.size.width + 5,
                                                    5.0, 50, 50);
        self.playsRemainingLabel.layer.borderColor = [UIColor grayColor].CGColor;
        self.playsRemainingLabel.layer.borderWidth = 2.0;
        self.playsRemainingLabel.layer.cornerRadius = 25;
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"hh:mm - MMM d";
        NSDate *responseTime = [self.chirp objectForKey:@"respondedAt"];
        self.responseTimeLabel = [[UILabel alloc] init];
        self.responseTimeLabel.text = [timeFormatter stringFromDate:responseTime];
        self.responseTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        self.responseTimeLabel.textColor = [UIColor grayColor];
        self.responseTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.responseTimeLabel.frame = CGRectMake(self.playMouthButton.frame.origin.x,
            self.playMouthButton.frame.origin.y + self.playMouthButton.frame.size.height +  self.mouthTimeline.frame.size.height + 3,
            self.playMouthButton.frame.size.width, 12.0);
        
        PFUser *god = [self.chirp objectForKey:@"mouthing_user"];
        NSString *godName = [god objectForKey:@"name"];
        NSArray *nameParts = [godName componentsSeparatedByString:@" "];
        NSString *godFirstName = [nameParts firstObject];
        self.fromWhichGodLabel = [[UILabel alloc] init];
        self.fromWhichGodLabel.text = [NSString stringWithFormat:@"from %@", godFirstName];
        self.fromWhichGodLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        self.fromWhichGodLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        self.fromWhichGodLabel.textAlignment = NSTextAlignmentCenter;
        self.fromWhichGodLabel.frame = CGRectMake(self.playsRemainingLabel.frame.origin.x,
                                                  self.responseTimeLabel.frame.origin.y,
                                                  self.playsRemainingLabel.frame.size.width, 12.0);
        
        NSDate *creationTime = [self.chirp createdAt];
        self.creationTimeLabel = [[UILabel alloc] init];
        self.creationTimeLabel.text = [timeFormatter stringFromDate:creationTime];
        self.creationTimeLabel.font = self.responseTimeLabel.font;
        self.creationTimeLabel.textColor = self.responseTimeLabel.textColor;
        self.creationTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.creationTimeLabel.frame = CGRectMake(self.playOriginalButton.frame.origin.x,
            self.playOriginalButton.frame.origin.y + self.playOriginalButton.frame.size.height + self.originalTimeline.frame.size.height + 3,
            self.playOriginalButton.frame.size.width,
            self.responseTimeLabel.frame.size.height);
        [self addSubview:self.creationTimeLabel];
        
        self.noResponseYetLabel = [[UILabel alloc] init];
        self.noResponseYetLabel.text = @"No mouth response yet :(((((";
        self.noResponseYetLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        self.noResponseYetLabel.textAlignment = NSTextAlignmentCenter;
        self.noResponseYetLabel.numberOfLines = 0;
        self.noResponseYetLabel.textColor = [UIColor darkGrayColor];
        
        self.inactiveOverlay = [[UIView alloc] initWithFrame:self.frame];
        self.inactiveOverlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        NSNumber *hasMouthSound = [self.chirp objectForKey:@"has_mouth_sound"];
        if ([hasMouthSound boolValue]) {
            [self addSubview:self.playMouthButton];
            [self addSubview:self.responseTimeLabel];
            [self addSubview:self.fromWhichGodLabel];
            [self addSubview:self.mouthTimeline];
            [self addSubview:self.playsRemainingLabel];
        }
        else {
            self.playOriginalButton.frame = CGRectMake(self.playOriginalButton.frame.origin.x,
                                                       self.playOriginalButton.frame.origin.y,
                                                       self.playOriginalButton.frame.size.width * 1,
                                                       self.playOriginalButton.frame.size.height);
            self.creationTimeLabel.frame = CGRectMake(self.creationTimeLabel.frame.origin.x,
                                                      self.creationTimeLabel.frame.origin.y,
                                                      self.creationTimeLabel.frame.size.width * 1,
                                                      self.creationTimeLabel.frame.size.height);
            self.noResponseYetLabel.frame = CGRectMake(self.playOriginalButton.frame.origin.x + self.playOriginalButton.frame.size.width + 3,
                                                       self.playOriginalButton.frame.origin.y,
                                                       self.frame.size.width - self.playOriginalButton.frame.size.width - 25, 54);
            [self addSubview:self.noResponseYetLabel];
            self.backgroundColor = [YellinSoundRespondedCell noMouthColor];
        }
        
        if ([mouthPlays intValue] == MAX_MOUTH_PLAYS) {
            [self makeInactiveWithDuration:0.0];
        }
    }
    return self;
}

- (void)updateWithMouthPlays:(int)mouthPlays {
    int playsRemaining = MAX_MOUTH_PLAYS - mouthPlays;
    self.playsRemainingLabel.text = [NSString stringWithFormat:@"%d", playsRemaining];
}

- (void)makeInactive {
    [self makeInactiveWithDuration:1.0];
}

- (void)makeInactiveWithDuration:(NSTimeInterval)duration {
    [self addSubview:self.inactiveOverlay];
    [UIView animateWithDuration:duration animations:^{
        self.inactiveOverlay.backgroundColor = [YellinSoundRespondedCell inactiveColor];
        self.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8	alpha:1.0];
        self.creationTimeLabel.textColor = [UIColor blackColor];
        self.responseTimeLabel.textColor = [UIColor blackColor];
        self.fromWhichGodLabel.textColor = [UIColor blackColor];
    }];
}

+ (UIColor *)inactiveColor {
    return [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.6];
}

+ (UIColor *)noMouthColor {
    return [UIColor colorWithRed:0.9 green:0.96 blue:0.9 alpha:1];
}

+ (UIColor *)originalButtonColor {
    return [UIColor colorWithRed:1 green:0.65 blue:0.3 alpha:1];
}

+ (UIColor *)mouthButtonColor {
    return [UIColor colorWithRed:0.4 green:0.5 blue:1 alpha:1];
}

+ (CGFloat)getHeight {
    return 77.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
