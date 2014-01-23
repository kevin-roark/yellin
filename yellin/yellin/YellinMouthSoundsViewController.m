//
//  YellinMouthSoundsViewController.m
//  yellin
//
//  Created by Kevin Roark on 1/21/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinMouthSoundsViewController.h"

@interface YellinMouthSoundsViewController ()

@end

@implementation YellinMouthSoundsViewController

- (id)initWithStyle:(UITableViewStyle)style {
    YellinMouthSoundsViewController *vc = [super initWithStyle:style];
    
    vc.parseClassName = CHIRP_PARSE_KEY;
    vc.pullToRefreshEnabled = YES;
    vc.paginationEnabled = NO;
    
    vc.tableView.separatorColor = [UIColor redColor];
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YellinSoundRespondedCell getHeight];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    //[query whereKey:@"has_mouth_sound" equalTo:[NSNumber numberWithBool:YES]];
    [query whereKey:@"from_user" equalTo:[PFUser currentUser]];
    [query includeKey:@"mouthing_user"]; // include data for us to show responder's name
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    NSString *reuseIdentifierText = [NSString stringWithFormat:@"mouth_response_%@", indexPath];
    YellinSoundRespondedCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierText];
    
    if (!cell) {
        // make the cell
        cell = [[YellinSoundRespondedCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:reuseIdentifierText
                                                    chirpObject:object];
        [cell.playOriginalButton addTarget:self action:@selector(orignalSoundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.playMouthButton addTarget:self action:@selector(mouthSoundButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (IBAction)orignalSoundButtonPressed:(id)sender {
    if (self.audioPlayer.playing) { // another sound playin
        [self.audioPlayer pause];
    }
    
    UIButton *buttonPessed = sender;
    YellinSoundRespondedCell *soundResponseCell = (YellinSoundRespondedCell *)buttonPessed.superview.superview;
    PFObject *chirp = soundResponseCell.chirp;
    PFFile *originalAudio = [chirp objectForKey:@"original_sound"];
    self.audioPlayer = [YellinAudioPlayer getConfiguredPlayerWithParseAudioFile:originalAudio];
    [self.audioPlayer play];
}

- (IBAction)mouthSoundButtonPressed:(id)sender {
    if (self.audioPlayer.playing) { // another sound playin
        [self.audioPlayer pause];
    }
    
    UIButton *buttonPessed = sender;
    YellinSoundRespondedCell *soundResponseCell = (YellinSoundRespondedCell *)buttonPessed.superview.superview;
    PFObject *chirp = soundResponseCell.chirp;
    PFFile *mouthAudio = [chirp objectForKey:@"mouth_sound"];
    self.audioPlayer = [YellinAudioPlayer getConfiguredPlayerWithParseAudioFile:mouthAudio];
    [self.audioPlayer play];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
