//
//  HealthGoalHomeViewController.m
//  FitHeart
//
//  Created by Bitgears on 08/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "HealthGoalHomeViewController.h"
#import "HealthSection.h"
#import "UCFSUtil.h"
#import "FTReminderViewController.h"
#import "FTReminderData.h"
#import "FTCircularEntriesGraph.h"
#import "FTSectionLogViewController.h"
#import "HealthHistoryViewController.h"

@interface HealthGoalHomeViewController () {
    
    NSString* unit;
    FTCircularEntriesGraph* circularEntriesGraph;
    FTLogData* lastLogData;
    UIButton* historyButton;
    UILabel* dateLabel;
}

@end

@implementation HealthGoalHomeViewController


@synthesize bottomButton;
@synthesize contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withGoalType:(int)goalType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil withSection:SECTION_FITNESS withGoalNibName:@"" withLogNibName:@""];
    if (self) {
        // Custom initialization
        currentGoalType = goalType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float w = 186;
    float h = 186;
    float space_y = 0;
    if ([UCFSUtil deviceSystemIOS7])
        space_y = 22;


    float totalHeight = [UCFSUtil contentAreaHeight] - bottomButton.frame.size.height;

    
    CGRect circularEntriesGraphFrame = CGRectMake((contentView.frame.size.width-w)/2, (totalHeight-h)/2-space_y, w, h);
    circularEntriesGraph = [[FTCircularEntriesGraph alloc] initWithFrame:circularEntriesGraphFrame
                                                              withRadius:89
                                                                withSize:24
                            ];
    circularEntriesGraph.wheelForegroundColor = [HealthSection mainColor:-1];
    circularEntriesGraph.wheelBackgroundColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(circularEntriesGraph.frame.origin.x, circularEntriesGraph.frame.origin.y+circularEntriesGraph.frame.size.height + 20, w, 60)];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(20.0)];
    dateLabel.textAlignment =  NSTextAlignmentCenter;
    dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    dateLabel.numberOfLines = 0;
    
    CGFloat y_center = 20;
    if ([UCFSUtil deviceIs3inch])
        y_center = 20;
    
    historyButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y_center, 280, 30)];
    [historyButton setTitle:@"History" forState:UIControlStateNormal];
    [historyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [historyButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    historyButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:20.0];
    historyButton.userInteractionEnabled = YES;
    [historyButton setAccessibilityLabel:@"History" ];
    [historyButton setAccessibilityHint:@"Tap to open history" ];
    [historyButton addTarget:self action:@selector(openHistory) forControlEvents:UIControlEventTouchUpInside];
    

    [self.view addSubview:circularEntriesGraph];
    [self.view addSubview:dateLabel];
    if (UIAccessibilityIsVoiceOverRunning())
        [self.view addSubview:historyButton];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[HealthSection goalTitle:currentGoalType]
                    bkgFileName:[HealthSection navBarBkg:0]
                      textColor:[HealthSection navBarTextColor:0]
                 isBackVisibile: NO
     ];
    
    
    FTReminderData* reminder = [HealthSection loadReminderWithGoal:currentGoalType];
    if (reminder!=nil && reminder.frequency!=0) {
        [self setupRightMenuButton:YES];
    }
    else {
        [self setupRightMenuButton:NO];
    }
    [self setupLeftMenuButton];
    
    
    lastLogData = [HealthSection lastLogDataWithGoalType:currentGoalType];

    bottomButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    
    switch(currentGoalType){
        case HEALTH_GOAL_WEIGHT:
            [bottomButton setTitle:@"ENTER WEIGHT" forState:UIControlStateNormal];
            unit = @"lbs";
            break;
        case HEALTH_GOAL_HEARTRATE:
            [bottomButton setTitle:@"ENTER HEART RATE" forState:UIControlStateNormal];
            unit = @"bpm";
            break;
        case HEALTH_GOAL_PRESSURE:
            [bottomButton setTitle:@"ENTER BLOOD PRESSURE" forState:UIControlStateNormal];
            unit = @"mmHg";
            break;
        case HEALTH_GOAL_GLUCOSE:
            [bottomButton setTitle:@"ENTER GLUCOSE" forState:UIControlStateNormal];
            unit = @"mg/dL";
            break;
        case HEALTH_GOAL_CHOLESTEROL_LDL:
            [bottomButton setTitle:@"ENTER LDL CHOLESTEROL" forState:UIControlStateNormal];
            unit = @"mg/dL";
            break;
            
    }
    

    
    if (lastLogData!=nil) {
        dateLabel.text = [NSString stringWithFormat:@"Entered on\n%@", [UCFSUtil formatDate:lastLogData.insertDate withFormat:@"MMM dd"]];
        if (currentGoalType==HEALTH_GOAL_PRESSURE) {
            [circularEntriesGraph resetWithProgress:lastLogData.logValue withValue:lastLogData.logValue withValue2:lastLogData.logValue2 withUnit:unit];
        }
        else {
            [circularEntriesGraph resetWithProgress:lastLogData.logValue withValue:lastLogData.logValue withUnit:unit];
        }
        [circularEntriesGraph setNeedsDisplay];

    }
    else {
        dateLabel.text = @"Never entered";
        [circularEntriesGraph resetWithProgress:0 withValue:0 withUnit:unit];
        [circularEntriesGraph setNeedsDisplay];

    }
    
    
}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(cancelAction:) withSection:[HealthSection class]];
}

- (IBAction)cancelAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)setupRightMenuButton:(BOOL)on {
    if (on)
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarReminderButtonWithTarget:self action:@selector(reminderAction:) asDark:NO];
    else
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarReminderOffButtonWithTarget:self action:@selector(reminderAction:) asDark:NO];
}

- (IBAction)reminderAction:(UIButton*)sender {
    
    FTReminderData* remider = [HealthSection loadReminderWithGoal:currentGoalType];
    if (remider==nil) {
        remider = [HealthSection defaultReminderWithGoal:currentGoalType];
    }
    
    UIViewController* viewController = [[FTReminderViewController alloc] initWithNibName:@"HealthReminderView" bundle:nil withSection:[HealthSection class] withReminder:remider withEditMode:true];
    [self goTo:viewController];
    
}

-(void)goTo:(UIViewController*)viewController {
    
    if (viewController!=nil) {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        [self.navigationController pushViewController:viewController animated:NO];
    }
}

- (IBAction)bottomButtonAction:(id)sender {
    [HealthSection setCurrentGoal:currentGoalType];
    [self addLog];
}


-(void)addLog {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    FTSectionLogViewController *viewController = [[FTSectionLogViewController alloc] initWithNibName:@"HealthLogView" bundle:nil withSection:[HealthSection class]];
    
    [self.navigationController pushViewController:viewController animated:NO];
    
}


-(void)openHistory {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    HealthHistoryViewController *viewController = [[HealthHistoryViewController alloc] initWithNibName:@"HealthHistoryView" bundle:nil withSection:[HealthSection class] withGoalType:currentGoalType];
    
    [self.navigationController pushViewController:viewController animated:NO];
    
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
