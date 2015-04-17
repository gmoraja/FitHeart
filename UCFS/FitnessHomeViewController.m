//
//  FitnessHomeViewController.m
//  FitHeart
//
//  Created by Bitgears on 11/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FitnessHomeViewController.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"
#import "FTSectionGoalViewController.h"
#import "FTSectionLogViewController.h"
#import "FitnessAfterGoalViewController.h"
#import "FitnessIntroViewController.h"
#import "AppDelegate.h"
#import "FTGoalHistoryViewController.h"


@interface FitnessHomeViewController () {
    FTNotificationAction* notificationAction;
    BOOL weekIsOver;
}


@end

@implementation FitnessHomeViewController

@synthesize standardView;
@synthesize contentView;
@synthesize endOfWeekView;
@synthesize continueButton;
@synthesize textLabel;
@synthesize subtitleLabel;
@synthesize setNewGoalNoButton;
@synthesize setNewGoalYesButton;
@synthesize setNewGoalTitleLabel;
@synthesize setNewGoalSubtitleLabel;
@synthesize setNewGoalView;
@synthesize addActivityButton;


- (id)initWithAction:(FTNotificationAction*)action
{
    self = [super initWithNibName:@"FitnessHomeView"
                           bundle:nil
                      withSection:[FitnessSection class]
                  withGoalNibName:@"FitnessGoalView"
                   withLogNibName:@"FitnessLogView"
            ];
    
    if (self) {
        // Custom initialization
        notificationAction = action;
        currentDateType = 1; //WEEK
        weekIsOver = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    containerViewHeight = [UCFSUtil contentAreaHeight] - continueButton.frame.size.height;
    contentView.frame = CGRectMake(0, contentView.frame.origin.y, 320, containerViewHeight);

    containerView = contentView;
    [super viewDidLoad];

    /*
    if (notificationAction!=nil) {
        [FitnessSection setCurrentGoal:notificationAction.actionGoal];
        [super goToScreen:notificationAction.actionScreen];
    }
    else
        [FitnessSection setCurrentGoal:FITNESS_GOAL_TIME];
     */
    
    setNewGoalView.hidden = YES;
    setNewGoalTitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:22.0];
    setNewGoalSubtitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    setNewGoalNoButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    setNewGoalYesButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    
    [currentSection loadGoals];
    FTGoalData* goalData = [currentSection goalDataWithType:-1];
    if ([FitnessSection checkWeekIsOver:goalData]) {
        weekIsOver = YES;
        textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
        subtitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0];
        continueButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
        endOfWeekView.hidden = NO;
        standardView.hidden = YES;
        showLeftMenuBtn = NO;
        showRightMenuBtn = NO;
    }
    else {
        weekIsOver = FALSE;
        standardView.hidden = NO;
        endOfWeekView.hidden = YES;
        showLeftMenuBtn = YES;
        showRightMenuBtn = YES;
    }


    addActivityButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    
}

- (void)viewDidAppear:(BOOL)animated {
    FTGoalData* goalData = [currentSection goalDataWithType:-1];
    if ([FitnessSection checkWeekIsOver:goalData]) {
        weekIsOver = YES;
        if (endOfWeekView.hidden) {
            showLeftMenuBtn = YES;
            showRightMenuBtn = YES;
        }
        else {
            showLeftMenuBtn = NO;
            showRightMenuBtn = NO;
        }
        
    }
    else {
        weekIsOver = FALSE;
        showLeftMenuBtn = YES;
        showRightMenuBtn = YES;
    }
    
    [super viewDidAppear:animated];
    
    
    
    [self updateUI:goalData.dataType.goaltypeId ];
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate selectMenuItem:0];

    
}

- (void)timerFireMethod:(NSTimer *)timer {
    //mainSelector.isEnabled = true;
}

- (IBAction)showMessage:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"FitHeart"
                                                      message:@"You will be able to add an activity after you goal has started. Your goal has not started yet. To change your goal to start today, tap the menu on the top right of the screen to Set a New Goal."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}


- (IBAction)addAction:(UIButton*)sender {
    FTGoalData* goalData = [currentSection goalDataWithType:-1];
    
    //check startdate
    NSDate* startDate = [UCFSUtil setTimeWithDate:goalData.startDate withHours:0 withMinutes:0 withSeconds:0];
    NSDate* nowDate = [UCFSUtil setTimeWithDate:[NSDate date] withHours:0 withMinutes:0 withSeconds:0];

    if ([startDate compare:nowDate] == NSOrderedDescending) {
        [self showMessage:nil];
    }
    else
        [self addLog];

}

-(IBAction)goalButtonAction:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch([segmentedControl selectedSegmentIndex]) {
        case 0:
            [FitnessSection setCurrentGoal:FITNESS_GOAL_TIME];
            break;
            
        case 1:
            //[FitnessSection setCurrentGoal:FITNESS_GOAL_DISTANCE];
            break;
            
        case 2:
            [FitnessSection setCurrentGoal:FITNESS_GOAL_STEPS];
            break;
    }
    
    [self updateUI:[FitnessSection getCurrentGoal] ];
    [self loadEntriesWithGoal:[FitnessSection getCurrentGoal] withDateType:1];
}

-(void)setupRightMenuButton{
    if (weekIsOver)
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarGoalReachedButtonWithTarget:self action:@selector(endOfWeekAction:)];
    else
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarActionButtonWithTarget:self action:@selector(openDialogAction:)];
}

- (IBAction)continueAction:(id)sender {
    standardView.hidden = NO;
    endOfWeekView.hidden = YES;
    showLeftMenuBtn = YES;
    [self setupLeftMenuButton];
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarGoalReachedButtonWithTarget:self action:@selector(endOfWeekAction:)];
    
}

- (void)buttonNewGoalTouch {
    [super buttonNewGoalTouch];
    
    setNewGoalView.hidden = NO;
    standardView.hidden = YES;
    endOfWeekView.hidden = YES;
    
    self.navigationController.navigationBar.hidden = YES;
    
    setNewGoalView.frame = CGRectMake(0, -44, 320, [UCFSUtil fullContentAreaHeight]);
    
    
}


- (IBAction)setNewGoalYesAction:(id)sender {
    
    FitnessIntroViewController *viewController = [[FitnessIntroViewController alloc] initWithNibName:@"FitnessIntroView" bundle:nil asNewWeek:FALSE];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:viewController animated:NO];
    setNewGoalView.hidden = YES;
    standardView.hidden = NO;
    endOfWeekView.hidden = YES;
}

- (IBAction)setNewGoalNoAction:(id)sender {
    setNewGoalView.hidden = YES;
    standardView.hidden = NO;
    endOfWeekView.hidden = YES;
    
    self.navigationController.navigationBar.hidden = NO;
    
}

-(IBAction)endOfWeekAction:(id)sender {
    FitnessAfterGoalViewController* viewController = [[FitnessAfterGoalViewController alloc] initWithNibName:@"FitnessAfterGoalView" bundle:nil asReached:reached asEndOfWeek:YES];
    [self.navigationController pushViewController:viewController animated:NO];
}

-(void)updateUI:(FitnessGoal)goal {
    switch(goal) {
        case FITNESS_GOAL_TIME:
            [homeView setGoalText:@"GOAL" textColor:[FitnessSection circularOverlayTextColor]];
            [homeView setUnitText:@"minutes" textColor:[FitnessSection circularOverlayTextColor]];
            break;
            
        case FITNESS_GOAL_STEPS:
            [homeView setGoalText:@"GOAL" textColor:[FitnessSection circularOverlayTextColor]];
            [homeView setUnitText:@"steps" textColor:[FitnessSection circularOverlayTextColor]];
            break;
    }
}

-(void)openHistory {
    [super openHistory];
    CATransition* transition = [CATransition animation];

    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    FTGoalHistoryViewController *viewController = [[FTGoalHistoryViewController alloc] initWithNibName:@"FitnessGoalHistoryView" bundle:nil withSection:[FitnessSection class] withLogNibName:@""];
    
    [self.navigationController pushViewController:viewController animated:NO];
    
}

//################ WEEK IS OVER





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
