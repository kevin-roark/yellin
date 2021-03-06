//
//  YellinAudioPlayer.h
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>

@interface YellinAudioPlayer : AVAudioPlayer

+ (void) getConfiguredPlayerWithParseAudioFile:(PFFile *)parseFile andCallback:(void (^)(YellinAudioPlayer *player))callback;

@end
