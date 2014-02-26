//
//  YellinAudioPlayer.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinAudioPlayer.h"

@implementation YellinAudioPlayer

+ (YellinAudioPlayer *) getConfiguredPlayerWithParseAudioFile:(PFFile *)parseFile {
    NSURL *originalAudioFileURL = [NSURL URLWithString:parseFile.url];
    NSError *err;
    NSData *originalAudioData = [[NSData alloc] initWithContentsOfURL:originalAudioFileURL options:NSDataReadingMappedIfSafe error:&err];
    if (err) {
        NSLog(@"erorr loading audio data from parse: %@", [err localizedDescription]);
    }
    err = nil;
    
    // Setup audio session for playing
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&err];
    if (err) {
        NSLog(@"Error setting playback: %@", [err localizedDescription]);
    }
    
    YellinAudioPlayer *player = [[YellinAudioPlayer alloc] initWithData:originalAudioData error:&err];
    if (err) {
        NSLog(@"Error making original sound player: %@", [err localizedDescription]);
        return nil;
    }
    [player setVolume:1.0];
    return player;
}

@end
