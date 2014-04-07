//
//  YellinAudioPlayerCache.m
//  yellin
//
//  Created by Kevin Roark on 3/26/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinAudioPlayerCache.h"

@implementation YellinAudioPlayerCache

- (id)initWithChirp:(PFObject *)chirp {
    self = [super init];
    
    self.originalPlayer = nil;
    self.mouthPlayer = nil;
    self.chirp = chirp;
    
    return self;
}

- (void)makeOriginalPlayer:(void (^)())callback {
    PFFile *audio = [self.chirp objectForKey:@"original_sound"];
    [YellinAudioPlayer getConfiguredPlayerWithParseAudioFile:audio andCallback:^void(YellinAudioPlayer *player) {
        self.originalPlayer = player;
        callback();
    }];
}

- (void)makeMouthPlayer:(void (^)())callback {
    PFFile *audio = [self.chirp objectForKey:@"mouth_sound"];
    [YellinAudioPlayer getConfiguredPlayerWithParseAudioFile:audio andCallback:^void(YellinAudioPlayer *player) {
        self.mouthPlayer = player;
        callback();
    }];
}

@end
