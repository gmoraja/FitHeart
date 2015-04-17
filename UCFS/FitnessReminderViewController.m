//
//  FitnessReminderViewController.m
//  FitHeart
//
//  Created by Bitgears on 26/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FitnessReminderViewController.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"
#import "FTReminderData.h"
#import "FTReminderSelectView.h"
#import "FTOptionGroupView.h"
#import "FitnessStartDateViewController.h"


@interface FitnessReminderViewController () {
    FTFrequencySlider *reminderSlider;
    NSArray* timeFrequencies;
}



@end

@implementation FitnessReminderViewController

@synthesize reminderLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = [FitnessSection class];
        
        timeFrequencies = [[NSArray alloc] initWithObjects:
                           @"NONE",
                           @"DAILY",
                           @"WEEKLY",
                           @"MONTHLY",
                           nil
                           ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:@"REMINDER"
                    bkgFileName:[currentSection navBarBkg:0]
                      textColor:[UIColor whiteColor]
                 isBackVisibile: YES
     ];
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    
    //REMINDER SELECT

    reminderLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0];
    
    CGRect reminderSliderRect = CGRectMake(0, 200, 320, 400);
    reminderSlider = [UCFSUtil createFrequencySliderWithFrame:reminderSliderRect withSection:currentSection withPositions:timeFrequencies];
    reminderSlider.delegate = self;
    
    [self.view addSubview:reminderSlider];
    
}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(cancelAction:)];
}


- (IBAction)cancelAction:(UIButton*)sender {

    [self.navigationController popViewControllerAnimated: YES];
}


-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarNextButtonWithTarget:self action:@selector(nextAction:)];
}



- (IBAction)nextAction:(UIButton*)sender {
    
    
    //save reminders
    FTGoalData* goalData = nil;
    goalData = [currentSection goalDataWithType:FITNESS_GOAL_STEPS];
    if (goalData!=nil) {
        //goalData.reminder = [FTReminderData alloc] init;
        //[currentSection setGoalData:goalData ];

    }
    
    if ([currentSection sectionType]==SECTION_FITNESS) {
        FitnessStartDateViewController *viewController = [[FitnessStartDateViewController alloc] initWithNibName:@"FitnessStartDateView" bundle:nil];
        [self.navigationController pushViewController:viewController animated:NO];
        
    }
    
    
    
}

- (void)frequencyChanged:(int)frequency {
    reminderLabel.text = timeFrequencies[frequency];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
