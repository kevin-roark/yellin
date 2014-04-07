//
//  YellinAudioPlayer.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinAudioPlayer.h"

@implementation YellinAudioPlayer

+ (void) getConfiguredPlayerWithParseAudioFile:(PFFile *)parseFile andCallback:(void (^)(YellinAudioPlayer *))callback {
    NSURL *audioURL = [NSURL URLWithString:parseFile.url];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSError *err;
        NSData *audioData = [NSData dataWithContentsOfURL:audioURL options:NSDataReadingMappedIfSafe error:&err];
        if (err) {
            NSLog(@"erorr loading audio data from parse: %@", [err localizedDescription]);
        }
        err = nil;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            
            // Setup audio session for playing
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setCategory:AVAudioSessionCategoryPlayback error:&err];
            if (err) {
                NSLog(@"Error setting playback: %@", [err localizedDescription]);
            }
            
            YellinAudioPlayer *player = [[YellinAudioPlayer alloc] initWithData:audioData error:&err];
            if (err) {
                NSLog(@"Error making original sound player: %@", [err localizedDescription]);
                callback(nil);
                return;
            }
            
            [player setVolume:1.0];
            callback(player);
        });
    });
}

@end
