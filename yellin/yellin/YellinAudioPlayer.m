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
    YellinAudioPlayer *player = [[YellinAudioPlayer alloc] initWithData:originalAudioData error:&err];
    if (err) {
        NSLog(@"Error making original sound player: %@", [err localizedDescription]);
        return nil;
    }
    return player;
}

@end
