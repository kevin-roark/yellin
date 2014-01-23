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
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"has_mouth_sound" equalTo:[NSNumber numberWithBool:NO]];
    
    return query;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    NSString *reuseIdentifierText = [NSString stringWithFormat:@"needs_mouth_%@", indexPath];
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
