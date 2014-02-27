//
//  YellinAboutTabViewController.m
//  yellin
//
//  Created by Kevin Roark on 1/26/14.
//  Copyright (c) 2014 Kevin Roark. All rights reserved.
//

#import "YellinAboutTabViewController.h"

@interface YellinAboutTabViewController ()

@end

@implementation YellinAboutTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.navigationItem.titleView = [YellinUtility getTitleLabel:@"about yellin"];
    [self.navigationItem.titleView sizeToFit];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    float y = 12.0;
    
    // set up the 'what'
    UILabel *what = [YellinAboutTabViewController configuredHeaderLabelWithFrame:CGRectMake(12, y, self.view.frame.size.width - 12, 24)];
    what.text = @"What?";
    what.textColor = [YellinAboutTabViewController whatColorWithAlpha:1.0];
    y += what.frame.size.height;
    
    UIView *mainDescriptionFrame = [[UIView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width - 20, 165)];
    mainDescriptionFrame.backgroundColor = [YellinAboutTabViewController whatColorWithAlpha:0.8];
    
    UILabel *mainDescription = [YellinAboutTabViewController
        configuredDescriptionLabelWithFrame:CGRectMake(5, 0, mainDescriptionFrame.frame.size.width - 10, mainDescriptionFrame.frame.size.height)];
    NSMutableString *mainText = [NSMutableString stringWithString:@"\u2022 Send \"us\" any sound.\n"];
    [mainText appendString:@"\u2022 \"We\" recreate that sound with \"our\" mouths and send it back to you in realtime for max listening pleasure.\n"];
    [mainText appendString:[NSString stringWithFormat:@"\u2022 Listen to \"our\" special mouth sound %d whole times (you'll lov it!!).\n", MAX_MOUTH_PLAYS]];
    [mainText appendString:@"\u2022 Do it a lot cuz we're crazy cool funny lol."];
    mainDescription.text = mainText;

    [mainDescriptionFrame addSubview:mainDescription];
    y += mainDescription.frame.size.height + 10;
    
    // set up the 'who'
    UILabel *who = [YellinAboutTabViewController configuredHeaderLabelWithFrame:CGRectMake(12, y, self.view.frame.size.width - 12, 24)];
    who.text = @"Who?";
    who.textColor = [YellinAboutTabViewController whoColorWithAlpha:1.0];
    y += who.frame.size.height;
    
    UIView *whoDescriptionFrame = [[UIView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width - 20, 220)];
    whoDescriptionFrame.backgroundColor = [YellinAboutTabViewController whoColorWithAlpha:0.8];
    
    UILabel *whoDescription = [YellinAboutTabViewController
        configuredDescriptionLabelWithFrame:CGRectMake(5, 0, whoDescriptionFrame.frame.size.width - 10, whoDescriptionFrame.frame.size.height)];
    NSMutableString *whoText = [[NSMutableString alloc] init];
    [whoText appendString:@"Who is makin' all these crazy cool mouth sounds? For now it's just Kevin, Dylan, and Henry, three chillers who made this "];
    [whoText appendString:@"thing. We r sorry for delayed responses in cases where we are all sleeping or something (LoL!)! In case we ever need more "];
    [whoText appendString:@"mouths and u wanna be one, or in case u just wanna chat or need a friend, you can reach us at Kev's twitter: @LIMP__BISCUIT."];
    whoDescription.text = whoText;
    
    [whoDescriptionFrame addSubview:whoDescription];
    y += whoDescriptionFrame.frame.size.height + 10;
    
    // set up the 'thanks'
    UILabel *thanks = [YellinAboutTabViewController configuredHeaderLabelWithFrame:CGRectMake(12, y, self.view.frame.size.width - 12, 24)];
    thanks.text = @"Thanks!";
    thanks.textColor = [YellinAboutTabViewController thanksColorWithAlpha:1.0];
    y += thanks.frame.size.height;
    
    UIView *thanksDescriptionFrame = [[UIView alloc] initWithFrame:CGRectMake(10, y, self.view.frame.size.width - 20, 60)];
    thanksDescriptionFrame.backgroundColor = [YellinAboutTabViewController thanksColorWithAlpha:0.8];
    
    UILabel *thanksDescription = [YellinAboutTabViewController
        configuredDescriptionLabelWithFrame:CGRectMake(5, 0, thanksDescriptionFrame.frame.size.width - 10, thanksDescriptionFrame.frame.size.height)];
    NSMutableString *thanksText = [NSMutableString stringWithString:@"Thanks for playing with this and humoring us!! Seriously!!!"];
    thanksDescription.text = thanksText;
    
    [thanksDescriptionFrame addSubview:thanksDescription];
    y += thanksDescriptionFrame.frame.size.height + 10;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, y);
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:what];
    [scrollView addSubview:mainDescriptionFrame];
    [scrollView addSubview:who];
    [scrollView addSubview:whoDescriptionFrame];
    [scrollView addSubview:thanks];
    [scrollView addSubview:thanksDescriptionFrame];
    [self.view addSubview:scrollView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (UIColor *)whatColorWithAlpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:0.7 green:0.3 blue:0.7 alpha:alphaValue];
}

+ (UIColor *)whoColorWithAlpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:0.3 green:0.7 blue:0.7 alpha:alphaValue];
}

+ (UIColor *)thanksColorWithAlpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:0.3 green:0.9 blue:0.4 alpha:alphaValue];
}

+ (UILabel *)configuredHeaderLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont fontWithName:@"Helvetica" size:22];
    return label;
}

+ (UILabel *)configuredDescriptionLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    label.textColor = [UIColor whiteColor];
    return label;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UINavigationBar appearance].barTintColor = [YellinUtility aboutYellinColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [YellinUtility aboutYellinColor];
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
