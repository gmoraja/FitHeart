//
//  FTSectionLogViewController.m
//  FitHeart
//
//  Created by Bitgears on 30/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTSectionLogViewController.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTLogContainerView.h"
#import "FTLogTimerContainerView.h"
#import "FitnessActivityViewController.h"
#import "FitnessEffortViewController.h"
#import "FTDateViewController.h"
#import "FitnessAfterGoalViewController.h"
#import "FTSalesForce.h"
#import "FTAppSettings.h"
#import "HealthSection.h"
#import "FitnessSection.h"

@interface FTSectionLogViewController () {
    CGRect logContainerFrame;
}



@end

@implementation FTSectionLogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = section;
        isEditing = false;
        editableLogData = nil;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withLogData:(FTLogData*)logData
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = section;
        isEditing = true;
        editableLogData = logData;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    int goal = [currentSection getCurrentGoal];
    self.wantsFullScreenLayout = YES;
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[currentSection logTitle:goal]
                    bkgFileName:[currentSection navBarBkg:0]
                      textColor:[UIColor whiteColor]
                 isBackVisibile: NO
     ];
    
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    float offset_y = 44;
    if ([UCFSUtil deviceSystemIOS7]) offset_y = 0;
    logContainerFrame = CGRectMake(0, offset_y, 320, [UCFSUtil contentAreaHeight]);
    
    FTHeaderConf* conf = nil;
    FTGoalData* goalData = nil;
    if ([currentSection sectionType]==SECTION_FITNESS) {
        goalData = [currentSection  goalDataWithType:-1];
        goal = goalData.dataType.goaltypeId;
    }
    else {
        if ([currentSection sectionType]==SECTION_HEALTH) {
            //fake goal data
            goalData = [[FTGoalData alloc] init];
            goalData.section = (int)[currentSection sectionType];
            goalData.dataType = [[FTDataType alloc] init];
            goalData.dataType.goaltypeId = [HealthSection getCurrentGoal];
            goal = goalData.dataType.goaltypeId;
        }
    }
    
    conf = [currentSection headerConfForLogWithGoalType:goal];
    
    
    switch(conf.uiType) { //0=single, 1=single+toplabel, 2=double, 3=timer
        case 0:
        case 1:
        case 2:
        case 3:
            logContainerView = [[FTLogContainerView alloc] initWithFrame:logContainerFrame
                                                             withSection:currentSection
                                                            withGoalData:goalData
                                                             withLogData:editableLogData
                                ];
            break;
        case 20:
            logContainerView = [[FTLogTimerContainerView alloc] initWithFrame:logContainerFrame
                                                                  withSection:currentSection
                                                                 withGoalData:goalData
                                                                  withLogData:editableLogData
                                ];
            break;
    }
    [self.view addSubview:logContainerView];
    //[logContainerView u
    logContainerView.delegate = self;

    
    [self setupUI];
    
    self.screenName = [NSString stringWithFormat:@"%@ Log Screen", [UCFSUtil sectionName:[currentSection sectionType] withGoal:-1]];

    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [logContainerView refreshBottomButtons];
    
    if (isEditing)
        [UCFSUtil trackGAEventWithCategory:@"ui_action" withAction:@"log_screen" withLabel:@"editing" withValue:[NSNumber numberWithInt:1]];

}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(cancelAction:) withSection:currentSection];
}

-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarSaveButtonWithTarget:self action:@selector(saveAction:) withSection:currentSection];
}

- (void)goToBack {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (IBAction)cancelAction:(UIButton*)sender {

    [self goToBack];
}

- (IBAction)saveAction:(UIButton*)sender {
    //save data
    FTGoalData* goalData = [currentSection goalDataWithType:-1];
    FTLogData* logData = nil;
    if ([currentSection sectionType]==SECTION_HEALTH) {
        logData = [logContainerView getLogData];
        logData.section = (int)[currentSection sectionType];
        logData.goalId = 0;
        [currentSection saveLogData:logData ];
        
        [self goToBack];
    }
    else {
        logData = [logContainerView getLogData];
        logData.section = (int)[currentSection sectionType];
        logData.goalType = goalData.dataType.goaltypeId;
        logData.goalId = goalData.goalId;
        [currentSection saveLogData:logData ];

        NSMutableArray* entries = [currentSection loadEntries:-1 withGoalData:goalData];
        float progress = [UCFSUtil calculteProgress:entries];
        BOOL reached = (progress>goalData.goalValue);
        
        if (reached) {
            //save goal
            goalData.reached = 1;
            goalData.uploadedToServer = 0;
            [currentSection updateGoalData:goalData];
        }
        
        
        FitnessAfterGoalViewController* viewController = [[FitnessAfterGoalViewController alloc] initWithNibName:@"FitnessAfterGoalView" bundle:nil asReached:reached asEndOfWeek:FALSE];
        [self.navigationController pushViewController:viewController animated:NO];
        
        [UCFSUtil trackGAEventWithCategory:@"ui_action" withAction:@"fitness_log_saved" withLabel:(reached?@"at goal":@"not at goal") withValue:[NSNumber numberWithInt:logData.logValue]];
        

    }

    
}



- (void)infoTouched {
    UIImage* image = [UIImage imageNamed:[currentSection infoLogImageFilename]];
    FTDialogView *dialogView = [[FTDialogView alloc] initFullscreenWithImage:image];
    dialogView.delegate = self;
    [self.parentViewController.view addSubview:dialogView];
    
}

- (void)bottomButtonTouched:(int)buttonType {
    UIViewController* viewController = nil;
    FTGoalData* goalData = [currentSection goalDataWithType:-1];
    FTLogData* logData = [logContainerView getLogData];
    switch (buttonType) {
        case 0:
            if ([currentSection sectionType]==SECTION_FITNESS) {
                viewController = [[FTDateViewController alloc] initWithNibName:@"FitnessDateView" bundle:nil withStartDate:goalData.startDate withLogData:logData withSection:currentSection];
            }
            else {
                NSDate* startDate = [UCFSUtil getDate:[NSDate date] addDays:-7];
                viewController = [[FTDateViewController alloc] initWithNibName:@"HealthDateView" bundle:nil withStartDate:startDate withLogData:logData withSection:currentSection];
            }
            break;
        case 1:
            viewController = [[FitnessActivityViewController alloc] initWithNibName:@"FitnessActivityView" bundle:nil withLogData:logData];
            break;
        case 2:
            viewController = [[FitnessEffortViewController alloc] initWithNibName:@"FitnessEffortView" bundle:nil withLogData:logData];
            break;
            
        default:
            break;
    }
    
    if (viewController!=nil) {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

        
        [self.navigationController pushViewController:viewController animated:NO];

    }
}

- (void)switchToTimer {
    
    FTGoalData* goalData = [currentSection  goalDataWithType:-1];
    FTLogData* logData = [logContainerView getLogData];
    logData.logValue = 0;
    
    //remove log container
    [logContainerView removeFromSuperview];
    
    //add timer log container
    logContainerView = [[FTLogTimerContainerView alloc] initWithFrame:logContainerFrame
                                                          withSection:currentSection
                                                         withGoalData:goalData
                                                          withLogData:logData
                        ];
    [self.view addSubview:logContainerView];
    [logContainerView updateTimeButton:true];
    logContainerView.delegate = self;
}

- (void)switchToManual {
    
    FTGoalData* goalData = [currentSection  goalDataWithType:-1];
    FTLogData* logData = [logContainerView getLogData];
    
    //remove log container
    [logContainerView removeFromSuperview];

    //add timer log container
    logContainerView = [[FTLogContainerView alloc] initWithFrame:logContainerFrame
                                                     withSection:currentSection
                                                    withGoalData:goalData
                                                     withLogData:logData
                        ];
    [self.view addSubview:logContainerView];
    [logContainerView updateWithGoalData:goalData withLogData:logData withActiveValue:0];
    [logContainerView updateTimeButton:false];
    logContainerView.delegate = self;
}


-(void)setupUI {
    
    int goal = [currentSection getCurrentGoal];
    FTGoalData* goalData = [currentSection goalDataWithType:goal];
    if (goalData==nil) goalData = [currentSection defaultGoalDataWithType:goal];
    FTLogData* logData = nil;
    if (isEditing) {
        logData = editableLogData;
    }
    else {
        logData = [currentSection defaultLogDataWithGoalType:goal];
        logData.uniqueId = -1; //IMPORTANT!!
        logData.insertDate = [NSDate date];
        if ( [currentSection sectionType]==SECTION_HEALTH && goal==0 ) {
            //for weight use last log value
            FTLogData* lastLog = [currentSection lastLogDataWithGoalType:0];
            if (lastLog!=nil)
                logData.logValue = lastLog.logValue;
        }
        else
            if ([currentSection sectionType]==SECTION_FITNESS) {
                FTLogData* lastLog = [currentSection lastLogDataWithGoalType:goal];
                if (lastLog!=nil) {
                    logData.logValue = lastLog.logValue;
                    logData.activity = lastLog.activity;
                    logData.effort = lastLog.effort;
                }
                if ([FitnessSection checkWeekIsOver:goalData]) {
                    logData.insertDate = [UCFSUtil getDate:goalData.startDate addDays:6];
                }
                
            }

    }

    [logContainerView updateWithGoalData:goalData withLogData:logData withActiveValue:0];
    
 
    
}







-(IBAction)doneAction:(UIButton*)sender {
    [logContainerView dismissKeyboard];
}

- (void)startEditingValue {
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarDoneButtonWithTarget:self action:@selector(doneAction:) withSection:currentSection];
}

- (void)finishEditingValue {
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarSaveButtonWithTarget:self action:@selector(saveAction:) withSection:currentSection];
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
