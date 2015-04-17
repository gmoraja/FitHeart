//
//  HealthHomeViewController.m
//  FitHeart
//
//  Created by Bitgears on 01/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "HealthHomeViewController.h"
#import "UCFSUtil.h"
#import "HealthSection.h"
#import "FTSectionGoalViewController.h"
#import "FTSectionLogViewController.h"
#import "HealthGoalSelectorView.h"
#import "HealthGoalHomeViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "AppDelegate.h"


@interface HealthHomeViewController () {
    
    HealthGoalSelectorView* goalSelectorView;
    UIView *contentViewBorder;
    
}

@end

@implementation HealthHomeViewController


@synthesize contentView;

- (id)initWithAction:(FTNotificationAction*)action
{
    /*
    self = [super initWithNibName:@"HealthHomeView"
                           bundle:nil
                      withSection:[HealthSection class]
                  withGoalNibName:@"HealthGoalView"
                   withLogNibName:@"HealthLogView"
            ];
    */
    if (self) {
        /*
        // Custom initialization
        showHomeView = FALSE;
        isSwipeEnabled = FALSE;
        showRightMenuBtn = FALSE;
         */
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //selector
    float y = 44;
    if ([UCFSUtil deviceSystemIOS7])
        y =0;
    CGRect goalSelectorRect = CGRectMake(0, y, 320, [UCFSUtil contentAreaHeight]);
    goalSelectorView = [[HealthGoalSelectorView alloc] initWithFrame:goalSelectorRect];
    goalSelectorView.delegate = self;

    
    
    [contentView addSubview:goalSelectorView];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
        [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                               item:self.navigationItem
                              title:[HealthSection title]
                        bkgFileName:[HealthSection navBarBkg:0]
                          textColor:[HealthSection navBarTextColor:0]
                     isBackVisibile: NO
         ];
    [self setupLeftMenuButton];
    
    
    [self updateUI:[HealthSection getCurrentGoal] ];
    for (int i=0; i<5; i++) {
        FTLogData* logData = [HealthSection lastLogDataWithGoalType:i];
        [goalSelectorView updateWithLog:logData withDataType:i];
    }
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate selectMenuItem:1];

    
}

-(void)setupLeftMenuButton {
    [self.navigationItem setLeftBarButtonItem:[UCFSUtil getNavigationBarMenuButton:nil withTarget:self action:@selector(menuAction:)] animated:NO];
}


- (IBAction)menuAction:(UIButton*)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

- (void)changeGoal:(int)goal {
    HealthGoalHomeViewController* viewController = [[HealthGoalHomeViewController alloc] initWithNibName:@"HealthGoalHomeView" bundle:nil withGoalType:goal];
    [self.navigationController pushViewController:viewController animated:NO];
}


- (IBAction)goalButtonAction:(id)sender {

}

-(void)openHistory {
    //[super openHistory];
    
}


-(void)updateUI:(HealthGoal)goal {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
