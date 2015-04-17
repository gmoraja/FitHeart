//
//  FTSectionHomeViewController.m
//  FitHeart
//
//  Created by Bitgears on 29/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTSectionHomeViewController.h"
#import "FTSection.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTSectionGoalViewController.h"
#import "FTSectionLogViewController.h"
#import "FTSectionLogListViewController.h"
#import "LateralMenuViewController.h"
#import "LearnMoreContentViewController.h"
#import "FTHomeActionDialogView.h"
#import "FTReminderViewController.h"
#import "FitnessStartDateViewController.h"
#import "FitnessIntroViewController.h"
#import "FTGoalHistoryViewController.h"
#import "FTWeeksLogsViewController.h"

@implementation FTSectionHomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withGoalNibName:(NSString*)goalNib withLogNibName:(NSString*)logNib {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = section;
        containerView = nil;
        goalNibName = goalNib;
        logNibName = logNib;
        showHomeView = TRUE;
        isSwipeEnabled = TRUE;
        containerViewHeight = 0;
        bannerHeight = 80;
        swipeValue = bannerHeight;
        currentDateType = 0; //DAY
        dottedLine = [UIImage imageNamed:@"dotted_line.png"];
        showLeftMenuBtn = YES;
        showRightMenuBtn = YES;

        bannerY = 0;
        if ([UCFSUtil deviceSystemIOS7]==FALSE) bannerY = 44;

    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    
    
    //circularView
    if (containerView!=nil) {
        if (showHomeView) {
            homeView = [[FTHomeView alloc] initWithFrame:CGRectMake(0,0, 320, containerView.frame.size.height) withSection:currentSection];
            [containerView addSubview:homeView];
            homeView.delegate = self;
        }
    }
    
    //action dialog
    float actionDialogY = [UIApplication sharedApplication].statusBarFrame.size.height;
    if ([UCFSUtil deviceSystemIOS7])
        actionDialogY -= 20;
    
    actionDialog = [[FTHomeActionDialogView alloc] initWithFrame:CGRectMake(0, actionDialogY, 320, [UCFSUtil fullContentAreaHeight]) withSection:currentSection];
    actionDialog.hidden = YES;
    actionDialog.delegate = self;
    [self.view addSubview:actionDialog];

    [currentSection loadGoals];
    
    // Create and initialize a tap gesture
    [self initPanrecognizer];
    
    self.screenName = [NSString stringWithFormat:@"%@ Home Screen", [UCFSUtil sectionName:[currentSection sectionType] withGoal:-1]];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[currentSection title]
                    bkgFileName:[currentSection navBarBkg:-1]
                      textColor:[currentSection navBarTextColor:-1]
                 isBackVisibile: NO
     ];
    if (navBarSwipeDown!=nil)
        navBarSwipeDown.enabled = YES;
    if (navBarTap!=nil)
        navBarTap.enabled = YES;

    if (showLeftMenuBtn)
        [self setupLeftMenuButton];
    if (showRightMenuBtn)
        [self setupRightMenuButton];
    
    [self loadEntriesWithGoal:[currentSection getCurrentGoal] withDateType:currentDateType];
    
}

-(void)viewDidDisappear:(BOOL)animated {
/*
    [self.navigationController.navigationBar removeGestureRecognizer:navBarTap];
    [self.navigationController.navigationBar removeGestureRecognizer:navBarSwipeDown];
    NSArray* recognizers = [self.navigationController.navigationBar gestureRecognizers];

*/
    if (navBarSwipeDown!=nil)
        navBarSwipeDown.enabled = NO;
    if (navBarTap!=nil)
        navBarTap.enabled = NO;
    
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    for (CALayer* layer in [self.view.layer sublayers])
    {
        [layer removeAllAnimations];
    }
}


-(void)setupLeftMenuButton {
    [self.navigationItem setLeftBarButtonItem:[UCFSUtil getNavigationBarMenuButton:nil withTarget:self action:@selector(menuAction:)] animated:NO];
}


-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarActionButtonWithTarget:self action:@selector(openDialogAction:)];
}

- (IBAction)menuAction:(UIButton*)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

-(IBAction)openDialogAction:(UIButton*)sender {
    if (actionDialog.hidden==YES) {
        actionDialog.hidden = NO;
        [UCFSUtil trackGAEventWithCategory:@"ui_action" withAction:@"fitness_setting_menu" withLabel:@"open" withValue:[NSNumber numberWithInt:1]];
    }
    else
        actionDialog.hidden = YES;
}


- (void)buttonChangeGoalTouch {
    [self editGoal];
    actionDialog.hidden = YES;
}



- (void)buttonReminderTouch {
    FTReminderData* reminder = [currentSection loadReminderWithGoal:[currentSection getCurrentGoal] ];

    FTReminderViewController *viewController = [[FTReminderViewController alloc] initWithNibName:@"FitnessReminderView" bundle:nil withSection:currentSection withReminder:reminder withEditMode:true];
    [self.navigationController pushViewController:viewController animated:NO];
    actionDialog.hidden = YES;

}
 

- (void)buttonNewGoalTouch {
    actionDialog.hidden = YES;
}

- (void)closeTouch {
    actionDialog.hidden = YES;
}



- (void)changeSection:(SectionType)type {

    UIViewController* viewController = [UCFSUtil getViewControllerWithSection:type withAction:nil];
    if (viewController!=nil) {

        UINavigationController *navController = self.navigationController;
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:viewController animated:NO];

    }

}

-(void)loadEntriesWithGoal:(int)goal withDateType:(int)dateType {
    [currentSection loadGoals];
    FTGoalData* goalData = [currentSection goalDataWithType:goal];
    if (goalData!=nil) {
        NSMutableArray* entries = [currentSection loadEntries:-1 withGoalData:goalData];
        if (homeView!=nil)
            [homeView updateGoalData:goalData withEntries:entries withDateType:-1 withLastLog:nil];
        
        float progress = [UCFSUtil calculteProgress:entries];
        reached = (progress>goalData.goalValue);
    }


}

-(void)editGoal {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    FTGoalData* goalData = [currentSection goalDataWithType:[currentSection getCurrentGoal] ];
    
    FTSectionGoalViewController *viewController = [[FTSectionGoalViewController alloc] initWithNibName:goalNibName bundle:nil withSection:currentSection withGoal:goalData asNew:false];
    
    [self.navigationController pushViewController:viewController animated:NO];
}

-(void)addLog {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    FTSectionLogViewController *viewController = [[FTSectionLogViewController alloc] initWithNibName:logNibName bundle:nil withSection:currentSection];
    
    [self.navigationController pushViewController:viewController animated:NO];
    
}

- (void)buttonHistoryTouch {
    [self openHistory];
}


-(void)openHistory {
    if ([currentSection sectionType]==SECTION_HEALTH)
        return;
}

-(void)openLogList {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    FTGoalData* goalData = [currentSection goalDataWithType:[currentSection getCurrentGoal] ];
    
    
    FTWeeksLogsViewController *viewController = [[FTWeeksLogsViewController alloc] initWithNibName:@"FitnessWeeksLogsView"
                                                                                            bundle:nil
                                                                                       withSection:currentSection
                                                                                      withGoalData:goalData
                                                                                    withLogNibName:logNibName
                                                 ];
    
    [self.navigationController pushViewController:viewController animated:NO];
    
}



//############### CIRCULAR VIEW DELEGATE

- (void)buttonInfoTouch {
    UIImage* image = [UIImage imageNamed:[currentSection infoHomeImageFilename]];
    NSString* text = @"Set SMART goals that are Specific, Measureable, Attainable, Relevant, and Timely.";
    FTDialogView *dialogView = [[FTDialogView alloc] initFullscreenWithImage:image withText:text];
    dialogView.delegate = self;
    [self.parentViewController.view addSubview:dialogView];
}

- (void)dialogPopupFinished:(UIView*)dialogView {
    [dialogView removeFromSuperview];
}

- (void)buttonGoalTouch {
    [self editGoal];
}

- (void)buttonListTouch {
    
}

- (void)buttonEntryTouchWithDate:(FTGoalData*)goalData; {
    [self openLogList];
}


- (void)buttonDateTypeTouch:(int)dateType {
}



//############### GESTURE MANAGEMENT


- (void)initPanrecognizer {
    
    if (navBarSwipeDown==nil) {
        navBarSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        navBarSwipeDown.cancelsTouchesInView = NO;
        [navBarSwipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
        [self.navigationController.navigationBar addGestureRecognizer:navBarSwipeDown];
        //[containerView addGestureRecognizer:swipeDown];
    }
    else {
        navBarSwipeDown.enabled = YES;
    }
    
    if (navBarTap==nil) {
        navBarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(navigationTap:)];
        navBarTap.numberOfTapsRequired = 1;

        [self.navigationController.navigationBar addGestureRecognizer:navBarTap];
    }
    else {
        navBarTap.enabled = YES;
    }
}



-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if([recognizer direction] == UISwipeGestureRecognizerDirectionDown) {
            CGPoint location = [recognizer locationInView:self.view];
            if (location.x>80 && location.x<240) {
                [self openHistory];
            }

        }
    }
}

-(void)navigationTap:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self openHistory];
    }

}


- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.view];
    if (abs(translation.y)>abs(translation.x)) {
        
        CGFloat y = recognizer.view.center.y + translation.y;
        if (y<(contentStartY-80)) {
            y=contentStartY-80;
        }
        else
            if (y>contentStartY) {
                y=contentStartY;
            }
        recognizer.view.center = CGPointMake(recognizer.view.center.x, y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    else
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
}

//############### NOTIFICATION



- (void)notificationAction:(FTNotification*)notification {
    if (notification!=nil && notification.action!=nil) {
        if (notification.action.actionSection==[currentSection sectionType]) {
            [self goToScreen:notification.action.actionScreen];
        }
        else
            if (notification.action.actionSection==5) {
                //learn more
                LearnMoreContentViewController *viewController = [[LearnMoreContentViewController alloc] initWithNibName:@"LearnMoreContentView" bundle:nil];
                viewController.sectionId = notification.action.actionScreen;
                viewController.headerId = notification.action.actionItem;
                CATransition* transition = [CATransition animation];
                transition.duration = 0.4f;
                transition.type = kCATransitionMoveIn;
                transition.subtype = kCATransitionFromRight;
                [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
                
                [self.navigationController pushViewController:viewController animated:NO];
            }
    }
}

-(void)goToScreen:(int)screen {
    if (screen==1)
        [self editGoal];
    else
        if (screen==2)
            [self addLog];
}

-(void)enableScreen {
    if (screenMaskView==nil)
        screenMaskView = [[ScreenMaskView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:screenMaskView];
}

-(void)disableScreen {
    if (screenMaskView!=nil)
        [screenMaskView removeFromSuperview];
}



@end
