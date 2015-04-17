//
//  FitnessIntroViewController.m
//  FitHeart
//
//  Created by Bitgears on 23/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FitnessIntroViewController.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTSectionGoalViewController.h"
#import "AppDelegate.h"



@interface FitnessIntroViewController ()

@end

@implementation FitnessIntroViewController

@synthesize setgoalButton;
@synthesize subtitleLabel;
@synthesize text1Label;
@synthesize text2Label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil asNewWeek:(BOOL)newWeek
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isNewWeek = newWeek;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;

    text1Label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    text2Label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    subtitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0];
    setgoalButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    
    if (isNewWeek) {
        subtitleLabel.text = @"Ready to start a new week?";
        text1Label.text = @"Set SMART goals that are: Specific, Measureable, Attainable, Relevant, and Timely.";
        text2Label.hidden = YES;
        [setgoalButton setTitle:@"SET A NEW GOAL?" forState:UIControlStateNormal];
    }
    else {
        subtitleLabel.text = @"Let's begin!";
        text1Label.text = @"One of the most important parts of staying healthy is being active.";
        text2Label.hidden = NO;
        [setgoalButton setTitle:@"SET A GOAL" forState:UIControlStateNormal];
        
    }


}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];

    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[FitnessSection title]
                    bkgFileName:[FitnessSection navBarBkg:0]
                      textColor:[UIColor whiteColor]
                 isBackVisibile: NO
     ];
    
    [self setupLeftMenuButton];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate selectMenuItem:0];
    
}

-(void)setupLeftMenuButton {
    [self.navigationItem setLeftBarButtonItem:[UCFSUtil getNavigationBarMenuButton:nil withTarget:self action:@selector(menuAction:)] animated:NO];
}


- (IBAction)menuAction:(UIButton*)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setgoalAction:(id)sender {
    [self editGoal];
    
}

-(void)editGoal {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    
    FTSectionGoalViewController *viewController = [[FTSectionGoalViewController alloc] initWithNibName:@"FitnessGoalView" bundle:nil withSection:[FitnessSection class] withGoal:nil asNew:TRUE];
    
    [self.navigationController pushViewController:viewController animated:NO];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
