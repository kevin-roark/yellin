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
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 65);
        
        self.playOriginalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.playOriginalButton.frame = CGRectMake(18.0, 6.0, 140.0, 40);
        self.playOriginalButton.tintColor = [UIColor whiteColor];
        self.playOriginalButton.backgroundColor = [UIColor orangeColor];
        [self.playOriginalButton setTitle:@"ur sound" forState:UIControlStateNormal];
        [self addSubview:self.playOriginalButton];
        
        self.playMouthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.playMouthButton.frame = CGRectMake(self.frame.size.width - 10.0 - 140.0, 6.0, 140.0, 40);
        self.playMouthButton.tintColor = [UIColor whiteColor];
        self.playMouthButton.backgroundColor = [UIColor greenColor];
        [self.playMouthButton setTitle:@"mouth sound" forState:UIControlStateNormal];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"hh:mm - MMM d";
        NSDate *responseTime = [self.chirp objectForKey:@"respondedAt"];
        self.responseTimeLabel = [[UILabel alloc] init];
        self.responseTimeLabel.text = [timeFormatter stringFromDate:responseTime];
        self.responseTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        self.responseTimeLabel.textColor = [UIColor grayColor];
        self.responseTimeLabel.textAlignment = NSTextAlignmentRight;
        self.responseTimeLabel.frame = CGRectMake(self.playMouthButton.frame.origin.x + 10,
                                                  self.playMouthButton.frame.origin.y + self.playMouthButton.frame.size.height + 3,
                                                  65.0, 12.0);
        
        PFUser *god = [self.chirp objectForKey:@"mouthing_user"];
        NSString *godName = [god objectForKey:@"name"];
        NSArray *nameParts = [godName componentsSeparatedByString:@" "];
        NSString *godFirstName = [nameParts firstObject];
        self.fromWhichGodLabel = [[UILabel alloc] init];
        self.fromWhichGodLabel.text = [NSString stringWithFormat:@"from %@", godFirstName];
        self.fromWhichGodLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        self.fromWhichGodLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        self.fromWhichGodLabel.textAlignment = NSTextAlignmentRight;
        self.fromWhichGodLabel.frame = CGRectMake(self.responseTimeLabel.frame.origin.x + self.responseTimeLabel.frame.size.width - 15,
                                                  self.responseTimeLabel.frame.origin.y,
                                                  self.playMouthButton.frame.size.width - self.responseTimeLabel.frame.size.width, 12.0);
        
        NSDate *creationTime = [self.chirp createdAt];
        self.creationTimeLabel = [[UILabel alloc] init];
        self.creationTimeLabel.text = [timeFormatter stringFromDate:creationTime];
        self.creationTimeLabel.font = self.responseTimeLabel.font;
        self.creationTimeLabel.textColor = self.responseTimeLabel.textColor;
        self.creationTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.creationTimeLabel.frame = CGRectMake(self.playOriginalButton.frame.origin.x,
                                                  self.playOriginalButton.frame.origin.y + self.playOriginalButton.frame.size.height + 3,
                                                  self.playOriginalButton.frame.size.width,
                                                  self.responseTimeLabel.frame.size.height);
        [self addSubview:self.creationTimeLabel];
        
        self.noResponseYetLabel = [[UILabel alloc] init];
        self.noResponseYetLabel.text = @"No mouth response yet :(";
        self.noResponseYetLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        self.noResponseYetLabel.textAlignment = NSTextAlignmentCenter;
        self.noResponseYetLabel.numberOfLines = 0;
        self.noResponseYetLabel.textColor = [UIColor darkGrayColor];
        
        NSNumber *hasMouthSound = [self.chirp objectForKey:@"has_mouth_sound"];
        if ([hasMouthSound boolValue]) {
            [self addSubview:self.playMouthButton];
            [self addSubview:self.responseTimeLabel];
            [self addSubview:self.fromWhichGodLabel];
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
        }
    }
    return self;
}

+ (CGFloat)getHeight {
    return 65.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
