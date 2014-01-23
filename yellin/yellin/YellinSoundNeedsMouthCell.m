//
//  YellinSoundNeedsMouthCell.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinSoundNeedsMouthCell.h"

@implementation YellinSoundNeedsMouthCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier chirpObject:(PFObject *)chirp {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
        self.chirp = chirp;
        
        self.textLabel.text = @"xxx";
        self.backgroundColor = [UIColor blackColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:self.textLabel.font.fontName size:13.0];
        
        self.layer.borderColor = [UIColor greenColor].CGColor;
        self.layer.borderWidth = 3.0;
        
        PFUser *fromUser = [self.chirp objectForKey:@"from_user"];
        [fromUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            NSString *name = [object objectForKey:@"name"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = @"hh:mm";
            NSString *timeString = [df stringFromDate:[self.chirp createdAt]];
            df.dateFormat = @"MMMM d";
            NSString *dateString = [df stringFromDate:[self.chirp createdAt]];
            self.textLabel.text = [NSString stringWithFormat:@"yell from %@ at %@ on %@", name, timeString, dateString];
        }];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
