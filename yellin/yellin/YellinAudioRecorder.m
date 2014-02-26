//
//  YellinAudioRecorder.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinAudioRecorder.h"

@implementation YellinAudioRecorder

+ (YellinAudioRecorder *)getConfiguredRecorderWithFileName:(NSString *)fileName {
    // set up audio file for recording
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               fileName,
                               nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    NSError *err;
    
    // Setup audio session for recording
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&err];
    if (err) {
        NSLog(@"Error setting playback: %@", [err localizedDescription]);
    }
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    YellinAudioRecorder *recorder = [[YellinAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:&err];
    if (err) {
        NSLog(@"Error: %@", [err localizedDescription]);
        return nil;
    }
    
    recorder.meteringEnabled = YES;
    return recorder;
}

- (id)initWithURL:(NSURL *)url settings:(NSDictionary *)settings error:(NSError *__autoreleasing *)outError {
    return [super initWithURL:url settings:settings error:outError];
}

@end
