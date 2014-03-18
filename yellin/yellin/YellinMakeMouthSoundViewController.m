//
//  YellinMakeMouthSoundViewController.m
//  yellin
//
//  Created by Kevin Roark on 1/22/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinMakeMouthSoundViewController.h"

@interface YellinMakeMouthSoundViewController ()

@end

@implementation YellinMakeMouthSoundViewController

- (id)initWithStyle:(UITableViewStyle)style {
    YellinMakeMouthSoundViewController *vc = [super initWithStyle:style];
    
    vc.parseClassName = CHIRP_PARSE_KEY;
    vc.pullToRefreshEnabled = YES;
    vc.paginationEnabled = NO;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    tableHeader.backgroundColor = [UIColor orangeColor];
    
    self.yellsTodoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableHeader.frame.size.width - 15, tableHeader.frame.size.height)];
    self.yellsTodoLabel.text = @"yells to do";
    self.yellsTodoLabel.textColor = [UIColor blueColor];
    self.yellsTodoLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    self.yellsTodoLabel.textAlignment = NSTextAlignmentCenter;
    [tableHeader addSubview:self.yellsTodoLabel];
    
    self.tableView.tableHeaderView = tableHeader;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // set up cache if necessary, makes things happen on no network
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    [query whereKey:@"has_mouth_sound" equalTo:[NSNumber numberWithBool:NO]];
    
    return query;
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    NSUInteger numObjects = [self.objects count];
    self.yellsTodoLabel.text = [NSString stringWithFormat:@"%lu yells to do", (unsigned long)numObjects];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    NSString *reuseIdentifierText = [NSString stringWithFormat:@"needs_mouth_%@", object];
    YellinSoundNeedsMouthCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierText];
    
    if (!cell) {
        // make the cell
        cell = [[YellinSoundNeedsMouthCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:reuseIdentifierText
                                                chirpObject:object];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCell:)];
        [cell addGestureRecognizer:tapRecognizer];
    }
    
    return cell;
}

- (void)tappedCell:(UIGestureRecognizer *)recognizer {
    NSLog(@"cell tap");
    
    CGPoint tapLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *tappedIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    YellinSoundNeedsMouthCell *tappedCell = (YellinSoundNeedsMouthCell *) [self.tableView cellForRowAtIndexPath:tappedIndexPath];
    
    YellinRespondToChirpViewController *responseVC = [[YellinRespondToChirpViewController alloc] init];
    responseVC.chirp = tappedCell.chirp;
    
    [self.navigationController pushViewController:responseVC animated:YES];
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
