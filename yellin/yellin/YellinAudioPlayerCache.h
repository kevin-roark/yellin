//
//  YellinAudioPlayerCache.h
//  yellin
//
//  Created by Kevin Roark on 3/26/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "YellinAudioPlayer.h"

@interface YellinAudioPlayerCache : NSObject

@property (nonatomic, strong) PFObject *chirp;

@property (nonatomic, strong) YellinAudioPlayer *originalPlayer;
@property (nonatomic, strong) YellinAudioPlayer *mouthPlayer;

- (id)initWithChirp:(PFObject *)chirp;

- (void)makeOriginalPlayer:(void (^)())callback;
- (void)makeMouthPlayer:(void (^)())callback;

@end
