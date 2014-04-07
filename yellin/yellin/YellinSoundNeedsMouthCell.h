//
//  YellinSoundNeedsMouthCell.h
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface YellinSoundNeedsMouthCell : UITableViewCell

@property (nonatomic, strong) PFObject *chirp;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier chirpObject:(PFObject *)chirp;

@end
