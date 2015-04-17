//
//  NutritionHomeViewController.m
//  FitHeart
//
//  Created by Bitgears on 27/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "NutritionHomeViewController.h"
#import "UCFSUtil.h"
#import "FTSection.h"
#import "NutritionSection.h"
#import "FTSectionGoalViewController.h"
#import "FTSectionLogViewController.h"

@interface NutritionHomeViewController () {
}


@end

@implementation NutritionHomeViewController

@synthesize contentView;
@synthesize goalTab;


- (id)initWithAction:(FTNotificationAction*)action
{
    self = [super initWithNibName:@"NutritionHomeView"
                           bundle:nil
                      withSection:[NutritionSection class]
                  withGoalNibName:@"NutritionGoalView"
                   withLogNibName:@"NutritionLogView"
            ];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    containerView = contentView;
    goalSegmentedControl = goalTab;
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self setupRightMenuButton];
    [NutritionSection setCurrentGoal:NUTRITION_GOAL_WEIGHT];
    
    currentDateType = 0; //day
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self updateUI:[NutritionSection getCurrentGoal] ];
}



-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarAddButton:nil withTarget:self action:@selector(addAction:)];
}


- (IBAction)addAction:(UIButton*)sender {
    [self addLog];
}

-(IBAction)goalButtonAction:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
    switch([segmentedControl selectedSegmentIndex]) {
        case 0:
            [NutritionSection setCurrentGoal:NUTRITION_GOAL_WEIGHT];
            break;
            
        case 1:
            [NutritionSection setCurrentGoal:NUTRITION_GOAL_CALORIES];
            break;
    }
    
    [self updateUI:[NutritionSection getCurrentGoal] ];
    [self loadEntriesWithGoal:[NutritionSection getCurrentGoal] withDateType:0];
    
}

     
-(void)updateUI:(NutritionGoal)goal {
    switch(goal) {
        case NUTRITION_GOAL_WEIGHT:
            [homeView setGoalText:@"GOAL" textColor:[NutritionSection circularOverlayTextColor]];
            [homeView setUnitText:@"lbs" textColor:[NutritionSection circularOverlayTextColor]];
            break;
            
        case NUTRITION_GOAL_CALORIES:
            [homeView setGoalText:@"GOAL" textColor:[NutritionSection circularOverlayTextColor]];
            [homeView setUnitText:@"calories" textColor:[NutritionSection circularOverlayTextColor]];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
