//
//  OrientationViewController.m
//  FitHeart
//
//  Created by Bitgears on 09/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "OrientationViewController.h"
#import "OrientationSection.h"
#import "UCFSUtil.h"
#import "FitnessHomeViewController.h"
#import "NutritionHomeViewController.h"
#import "FTAppSettings.h"
#import "FitnessIntroViewController.h"
#import "TutorialViewController.h"

@interface OrientationViewController ()

@end

@implementation OrientationViewController

@synthesize submitButton;
@synthesize context1Label;
@synthesize context2Label;
@synthesize moodLabel;
@synthesize healthLabel;
@synthesize fitnessLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[OrientationSection title]
                    bkgFileName:[OrientationSection navBarBkg]
                      textColor:[UIColor blackColor]
                 isBackVisibile: NO
     ];

    
    
    context1Label.font = [UIFont fontWithName:@"SourceSansPro-Light" size:16.0];
    context2Label.font = [UIFont fontWithName:@"SourceSansPro-Light" size:16.0];
    moodLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0];
    healthLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0];
    fitnessLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:16.0];
    
    submitButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitAction:(id)sender {
    
    [FTAppSettings confirmOrientation];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    TutorialViewController* viewController = [[TutorialViewController alloc] initWithNibName:@"TutorialView" bundle:nil withFirstLaunch:YES];
    [self.navigationController pushViewController:viewController animated:NO];

    /*
    //check fitness goal
    BOOL existsGoal = false;
    if (existsGoal) {
        UIViewController* viewController = [UCFSUtil getViewControllerWithSection:SECTION_FITNESS withAction:nil];
        [self.navigationController pushViewController:viewController animated:NO];
        
    }
    else {
        UIViewController* viewController = [[FitnessIntroViewController alloc] initWithNibName:@"FitnessIntroView" bundle:nil asNewWeek:FALSE];
        [self.navigationController pushViewController:viewController animated:NO];
        
    }
     */
    
}


@end
