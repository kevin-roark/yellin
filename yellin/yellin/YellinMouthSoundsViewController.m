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
    vc.paginationEnabled = YES;
    
    vc.tableView.separatorColor = [YellinUtility coolYellinColor];
    vc.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.8 alpha:1];
    
    // Setup audio session for playing
    NSError *err;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:&err];
    if (err) {
        NSLog(@"Error setting playback: %@", [err localizedDescription]);
    }
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nothingHere = NO;
    
    self.nothingHereLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 200)];
    self.nothingHereLabel.text = @"Nothin' here, because you haven't sent sounds!! send us some sounds!!";
    self.nothingHereLabel.textAlignment = NSTextAlignmentCenter;
    self.nothingHereLabel.numberOfLines = 0;
    self.nothingHereLabel.font = [UIFont fontWithName:@"Helvetica" size:24];

    self.navigationItem.titleView = [YellinUtility getTitleLabel:@"hear ur sounds"];
    [self.navigationItem.titleView sizeToFit];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UINavigationBar appearance].barTintColor = [YellinUtility coolYellinColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [YellinUtility coolYellinColor];
    [self loadObjects];
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nextpage"];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nextpage"];
        cell.textLabel.text = @"look at more sounds Lol!";
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.3 alpha:1.0];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YellinSoundRespondedCell getHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00000001;
}

- (PFQuery *)queryForTable {
    if (![PFUser currentUser])
        return nil;
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    //[query whereKey:@"has_mouth_sound" equalTo:[NSNumber numberWithBool:YES]];
    
    [query whereKey:@"from_user" equalTo:[PFUser currentUser]];
    [query includeKey:@"mouthing_user"]; // include data for us to show responder's name
    
    // set up cache if necessary, makes things happen on no network
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    //[query orderByDescending:@"active_mouth_sound"];
    //[query addDescendingOrder:@"respondedAt"];
    [query addDescendingOrder:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    NSString *reuseIdentifierText = nil; //[NSString stringWithFormat:@"mouth_response_%@", indexPath];
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

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    if ([self.objects count] <= 0 && !self.nothingHere) {
        [self.view addSubview:self.nothingHereLabel];
        self.nothingHere = YES;
    }
    else if (self.nothingHere && [self.objects count] > 0) {
        [self.nothingHereLabel removeFromSuperview];
        self.nothingHere = NO;
    }
}

- (IBAction)orignalSoundButtonPressed:(id)sender {
    if (self.audioPlayer.playing) { // another sound playin
        [self.audioPlayer pause];
        [self.activeCell.originalTimeline cancelAnimation];
        [self.activeCell.mouthTimeline cancelAnimation];
    }
    
    UIButton *buttonPessed = sender;
    YellinSoundRespondedCell *soundResponseCell = (YellinSoundRespondedCell *)buttonPessed.superview.superview;
    self.activeCell = soundResponseCell;
    
    PFObject *chirp = soundResponseCell.chirp;
    PFFile *originalAudio = [chirp objectForKey:@"original_sound"];
    self.audioPlayer = [YellinAudioPlayer getConfiguredPlayerWithParseAudioFile:originalAudio];
    
    soundResponseCell.originalSoundLength = self.audioPlayer.duration;
    [self.activeCell.originalTimeline startAnimationofTotalSeconds:self.activeCell.originalSoundLength];
    [self.audioPlayer play];
}

- (IBAction)mouthSoundButtonPressed:(id)sender {
    if (self.audioPlayer.playing) { // another sound playin
        [self.audioPlayer pause];
        [self.activeCell.originalTimeline cancelAnimation];
        [self.activeCell.mouthTimeline cancelAnimation];
    }
    
    UIButton *buttonPessed = sender;
    YellinSoundRespondedCell *soundResponseCell = (YellinSoundRespondedCell *)buttonPessed.superview.superview;
    self.activeCell = soundResponseCell;
    
    // update the chirp object
    if (![self.activeCell.chirp objectForKey:@"first_mouth_play_time"]) {
        [self.activeCell.chirp setObject:[NSDate date] forKey:@"first_mouth_play_time"];
    }
    NSNumber *currentMouthPlays = [self.activeCell.chirp objectForKey:@"mouth_plays"];
    int nextMouthPlays = [currentMouthPlays intValue] + 1;
    [self.activeCell updateWithMouthPlays:nextMouthPlays];
    [self.activeCell.chirp setObject:[NSNumber numberWithInt:nextMouthPlays] forKey:@"mouth_plays"];
    [self.activeCell.chirp saveInBackground];
    
    if (nextMouthPlays == MAX_MOUTH_PLAYS) {
        [self.activeCell makeInactive];
    }
    
    PFObject *chirp = soundResponseCell.chirp;
    PFFile *mouthAudio = [chirp objectForKey:@"mouth_sound"];
    self.audioPlayer = [YellinAudioPlayer getConfiguredPlayerWithParseAudioFile:mouthAudio];
    
    soundResponseCell.mouthSoundLength = self.audioPlayer.duration;
    [self.activeCell.mouthTimeline startAnimationofTotalSeconds:self.activeCell.mouthSoundLength];
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
