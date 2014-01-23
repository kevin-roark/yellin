//
//  YellinSoundRespondedCell.h
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AVFoundation/AVFoundation.h>

@interface YellinSoundRespondedCell : UITableViewCell

@property (nonatomic, strong) PFObject *chirp;

@property (nonatomic, strong) UILabel *fromWhichGodLabel;
@property (nonatomic, strong) UILabel *responseTimeLabel;
@property (nonatomic, strong) UILabel *creationTimeLabel;

@property (nonatomic, strong) UILabel *noResponseYetLabel;

@property (nonatomic, strong) UIButton *playOriginalButton;
@property (nonatomic, strong) UIButton *playMouthButton;

+ (CGFloat)getHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier chirpObject:(PFObject *)chirp;

@end
