//
//  YellinAudioRecorder.h
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface YellinAudioRecorder : AVAudioRecorder

+ (YellinAudioRecorder *) getConfiguredRecorderWithFileName:(NSString *)fileName;

@end
