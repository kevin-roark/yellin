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
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"hh:mm - MMM d";
        NSDate *responseTime = [self.chirp objectForKey:@"respondedAt"];
        self.responseTimeLabel = [[UILabel alloc] init];
        self.responseTimeLabel.text = [timeFormatter stringFromDate:responseTime];
        self.responseTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:10.0];
        self.responseTimeLabel.textColor = [UIColor grayColor];
        self.responseTimeLabel.textAlignment = NSTextAlignmentRight;
        self.responseTimeLabel.frame = CGRectMake(self.frame.size.width - 70.0, self.frame.size.height - 14.0, 65.0, 12.0);
        [self addSubview:self.responseTimeLabel];
        
        PFUser *god = [self.chirp objectForKey:@"mouthing_user"];
        NSString *godName = [god objectForKey:@"name"];
        NSArray *nameParts = [godName componentsSeparatedByString:@" "];
        NSString *godFirstName = [nameParts firstObject];
        self.fromWhichGodLabel = [[UILabel alloc] init];
        self.fromWhichGodLabel.text = [NSString stringWithFormat:@"from %@", godFirstName];
        self.fromWhichGodLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        self.fromWhichGodLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        self.fromWhichGodLabel.textAlignment = NSTextAlignmentRight;
        self.fromWhichGodLabel.frame = CGRectMake(self.responseTimeLabel.frame.origin.x, self.responseTimeLabel.frame.origin.y - 14.0,
                                                  self.responseTimeLabel.frame.size.width, 14.0);
        [self addSubview:self.fromWhichGodLabel];
        
        self.playOriginalButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.playOriginalButton.frame = CGRectMake(5.0, 6.0, 115.0, self.frame.size.height - 12);
        self.playOriginalButton.tintColor = [UIColor whiteColor];
        self.playOriginalButton.backgroundColor = [UIColor orangeColor];
        [self.playOriginalButton setTitle:@"ur sound" forState:UIControlStateNormal];
        [self addSubview:self.playOriginalButton];
        
        self.playMouthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.playMouthButton.frame = CGRectOffset(self.playOriginalButton.frame, 120, 0);
        self.playMouthButton.tintColor = [UIColor whiteColor];
        self.playMouthButton.backgroundColor = [UIColor purpleColor];
        [self.playMouthButton setTitle:@"mouth sound" forState:UIControlStateNormal];
        [self addSubview:self.playMouthButton];
        
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 1.0;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
