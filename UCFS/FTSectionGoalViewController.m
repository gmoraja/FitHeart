//
//  FTSectionGoalViewController.m
//  FitHeart
//
//  Created by Bitgears on 30/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTSectionGoalViewController.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTNotificationManager.h"
#import "FitnessSwitcherView.h"
#import "FTReminderViewController.h"
#import "FitnessSection.h"
#import "FTAppSettings.h"

@interface FTSectionGoalViewController () {
    FitnessSwitcherView* fitnessSwitcherView;
    BOOL editMode;
}

@end

@implementation FTSectionGoalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withGoal:(FTGoalData*)goalData asNew:(BOOL)isNew
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = section;
        currentGoalData = goalData;
        editMode = !isNew;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    int goal = [currentSection getCurrentGoal];
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[currentSection goalTitle:goal]
                    bkgFileName:[currentSection navBarBkg:goal]
                      textColor:[UIColor whiteColor]
                 isBackVisibile: NO
     ];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    FTGoalData* goalData = [currentSection lastGoalData];
    if (goalData==nil)
        goalData = [currentSection defaultGoalDataWithType:(int)goal];
    if (editMode) {
        goalData.goalValue = currentGoalData.goalValue;
        goalData.startDate = currentGoalData.startDate;
    }


    
    float offset_y = 44;
    if ([UCFSUtil deviceSystemIOS7]) offset_y = 0;
    CGRect goalContainerFrame = CGRectMake(0, offset_y, 320, [UCFSUtil contentAreaHeight]);
    goalContainerView = [[FTGoalContainerView alloc] initWithFrame:goalContainerFrame
                                                       withSection:currentSection
                                                      withGoalData:goalData
                         ];
    [self.view addSubview:goalContainerView];
    goalContainerView.delegate = self;
    
    if  ([currentSection sectionType]==SECTION_FITNESS) {
        float switcher_y = [UCFSUtil fullContentAreaHeight]-80;
        if ([UCFSUtil deviceSystemIOS7]) switcher_y -= 44;
        fitnessSwitcherView = [[FitnessSwitcherView alloc] initWithFrame:CGRectMake(0, switcher_y, 320, 80) dataType:goal];
        [self.view addSubview:fitnessSwitcherView];
        fitnessSwitcherView.delegate = self;
        fitnessSwitcherView.hidden = editMode;
        if (goalData!=nil)
            [fitnessSwitcherView switchImage:goalData.dataType.goaltypeId];
    }

    [goalContainerView updateWithGoalData:goalData];
    
    self.screenName = [NSString stringWithFormat:@"%@ Goal Screen", [UCFSUtil sectionName:[currentSection sectionType] withGoal:-1]];

   
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(cancelAction:) withSection:currentSection];
}


- (IBAction)cancelAction:(UIButton*)sender {
    /*
    if (goalContainerView!=nil && goalContainerView.headerView!=nil && goalContainerView.headerView.editModeEnabled) {
        [goalContainerView dismissKeyboard];
    }
    else
     */
        [self.navigationController popViewControllerAnimated: YES];
}


-(void)setupRightMenuButton{
    if (editMode)
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarSaveButtonWithTarget:self action:@selector(saveAction:) withSection:currentSection];
    else
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarNextButtonWithTarget:self action:@selector(nextAction:) withSection:currentSection];
}

- (IBAction)saveAction:(UIButton*)sender {
    FTGoalData* goalData = [goalContainerView getGoalData];
    if (editMode) {
        currentGoalData.goalValue = goalData.goalValue;
        currentGoalData.startDate = goalData.startDate;
        currentGoalData.uploadedToServer = 0;
        [currentSection saveGoalData:currentGoalData ];
    }
    else {
        [currentSection saveGoalData:goalData ];
    }

    [currentSection loadGoals];
    
    [self cancelAction:sender];
    
}

- (IBAction)nextAction:(UIButton*)sender {
    
    //save current goal
    FTGoalData* goalData = [goalContainerView getGoalData];
    goalData.startDate = [NSDate date];
    [currentSection setGoalData:goalData ];

    FTReminderData* reminder = [currentSection defaultReminderWithGoal:0];
    
    FTReminderViewController *viewController = [[FTReminderViewController alloc] initWithNibName:@"FitnessReminderView" bundle:nil withSection:currentSection withReminder:reminder withEditMode:false];
    [self.navigationController pushViewController:viewController animated:NO];
}



//############### SWITCHER VIEW DELEGATE

- (void)fitnessChangeDataType:(int)type {
    if (editMode==FALSE) {
        //load goal and init update UI
        [currentSection setCurrentGoal:type];
        FTGoalData* goalData = [currentSection defaultGoalDataWithType:type];
        [goalContainerView updateWithGoalData:goalData];
        
    }
    

}



-(IBAction)doneAction:(UIButton*)sender {
    [goalContainerView dismissKeyboard];

}

- (void)startEditingValue {
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarDoneButtonWithTarget:self action:@selector(doneAction:) withSection:currentSection];

}

- (void)finishEditingValue {
    if (editMode)
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarSaveButtonWithTarget:self action:@selector(saveAction:) withSection:currentSection];
    else
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarNextButtonWithTarget:self action:@selector(nextAction:) withSection:currentSection];

}

- (void)infoTouched {
    UIImage* image = [UIImage imageNamed:[currentSection infoGoalImageFilename]];
    NSString* text = [currentSection infoOverlayScreenText:[currentSection getCurrentGoal]];
    FTDialogView *dialogView = [[FTDialogView alloc] initFullscreenWithImage:image withText:text];
    dialogView.delegate = self;
    [self.parentViewController.view addSubview:dialogView];
    
}

- (void)dialogPopupFinished:(UIView*)dialogView {
    //hide loading
    [dialogView removeFromSuperview];
    //change navbar button
    //set default
    //[reminderSelect closeView];
    
    //[self updateDefaultUI];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
