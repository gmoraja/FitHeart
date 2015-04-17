//
//  MoodReminderViewController.m
//  FitHeart
//
//  Created by Bitgears on 26/02/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "MoodReminderViewController.h"
#import "MoodSection.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTOptionGroupView.h"
#import "FTReminderSelectView.h"
#import "FTNotificationManager.h"


@interface MoodReminderViewController () {
    
    UIView *bodyContainerView;
    UIView* mainContainerView;
    
    FTOptionGroupView* optionView;
    FTReminderSelectView* simplepleasuresSelect;
    FTReminderSelectView* writeanoteSelect;
    FTReminderSelectView* mindfulnessSelect;
    FTReminderSelectView* callafriendSelect;
}

@end

@implementation MoodReminderViewController

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
                          title:UCFS_MoodReminderView_NavBar_Title
                    bkgFileName:[MoodSection navBarBkg:0]
                      textColor:[MoodSection mainColor:0]
                 isBackVisibile: YES
     ];
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    [self initBody];
    
    [self.view addSubview:bodyContainerView];

}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(backAction:)];
}

-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarSaveButtonWithTarget:self action:@selector(saveAction:)];
}

-(void)initOptions {
    NSMutableArray *allviews = [[NSMutableArray alloc] init];
    
    CGRect simplepleasuresRect = CGRectMake(0, 0, 320, 50);
    simplepleasuresSelect = [[FTReminderSelectView alloc] initWithFrame:simplepleasuresRect
                                                            withSection:[MoodSection class]
                                                                withFont:@"Futura-CondensedMedium"
                                                            withFontSize:18.0
                             ];
    [allviews addObject:simplepleasuresSelect];

/*
    CGRect writeanoteRect = CGRectMake(0, simplepleasuresRect.origin.y+simplepleasuresRect.size.height, 320, 50);
    writeanoteSelect = [[FTReminderSelectView alloc] initWithFrame:writeanoteRect
                                                            withSection:[MoodSection class]
                                                               withFont:@"Futura-CondensedMedium"
                                                           withFontSize:18.0
                             ];
    [allviews addObject:writeanoteSelect];
    
    CGRect mindfulnessRect = CGRectMake(0, writeanoteRect.origin.y+writeanoteRect.size.height, 320, 50);
    mindfulnessSelect = [[FTReminderSelectView alloc] initWithFrame:mindfulnessRect
                                                       withSection:[MoodSection class]
                                                          withFont:@"Futura-CondensedMedium"
                                                      withFontSize:18.0
                        ];
    [allviews addObject:mindfulnessSelect];
    
    CGRect callafriendRect = CGRectMake(0, mindfulnessRect.origin.y+mindfulnessRect.size.height, 320, 50);
    callafriendSelect = [[FTReminderSelectView alloc] initWithFrame:callafriendRect
                                                        withSection:[MoodSection class]
                                                           withFont:@"Futura-CondensedMedium"
                                                       withFontSize:18.0
                         ];
    [allviews addObject:callafriendSelect];
*/
    
    float pos = 0;
    float viewsSpace = [allviews count]*50;
    //float contentAreaHeight =[UCFSUtil contentAreaHeight];
    //float availableSpace = contentAreaHeight;
    pos = [UCFSUtil contentAreaHeight]-viewsSpace;
    //if ([UCFSUtil deviceIs3inch]==FALSE) pos = 390;

    optionView = [[FTOptionGroupView alloc] initWithFrame:CGRectMake(0, pos, 320, viewsSpace)
                                                withViews:allviews
                  ];
    
    simplepleasuresSelect.delegate = optionView;
    /*
    writeanoteSelect.delegate = optionView;
    mindfulnessSelect.delegate = optionView;
    callafriendSelect.delegate = optionView;
     */
    
}

- (void)initBody {
    
    
    [self initOptions];
    
    //body height depends on options position
    float bodyContainerHeight = optionView.frame.origin.y+ optionView.frame.size.height;
    CGRect bodyContainerRect = CGRectMake(0, 0, 320, bodyContainerHeight);
    bodyContainerView = [[UIView alloc] initWithFrame:bodyContainerRect];
/*
    if (enableSwipe) {
        float availableSpace = [UCFSUtil contentAreaHeight]-headerView.frame.size.height;
        swipeValue = bodyContainerHeight-availableSpace;
    }
*/
    [bodyContainerView addSubview:optionView];
    
    optionView.slidableView = mainContainerView;
    
    FTReminderData* simplepleasureReminder = [MoodSection loadReminderWithGoal:MOOD_GOAL_SIMPLEPLEASURE];
    if (simplepleasureReminder==nil) {
        simplepleasureReminder = [[FTReminderData alloc] initWithSection:SECTION_MOOD withGoal:MOOD_GOAL_SIMPLEPLEASURE asDaily:FALSE];
        simplepleasureReminder.frequency = TIME_FREQUENCY_WEEKLY;
        simplepleasureReminder.dayOfWeek = 3;
        simplepleasureReminder.dayOfMonth = 1;
        simplepleasureReminder.hours = 9;
        simplepleasureReminder.minutes = 0;
        simplepleasureReminder.amPm = 0;

    }
    [simplepleasuresSelect updateReminder:simplepleasureReminder];
    [simplepleasuresSelect setLabel:@"SIMPLE PLEASURES"];
}


- (IBAction)backAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)saveAction:(UIButton*)sender {
    [MoodSection  saveReminder:simplepleasuresSelect.reminderData];
    //notification
    [self scheduleNotificationWithReminder:simplepleasuresSelect.reminderData withGoal:MOOD_GOAL_SIMPLEPLEASURE];
    
    [self backAction:sender];
}

-(void)scheduleNotificationWithReminder:(FTReminderData*)reminder withGoal:(int)goalType {
    if (reminder!=nil) {
        FTNotification* notification = nil;
        if (reminder.frequency!=TIME_FREQUENCY_NONE) {
            //load notification
            notification = [MoodSection nextLocalNotificationWithGoal:goalType withDateType:reminder.frequency withLast:-1];
        }
        else {
            //empty notification
            notification = [[FTNotification alloc] init];
        }
        if (notification!=nil) {
            notification.section =  [MoodSection sectionType];
            notification.goal = goalType;
            [FTNotificationManager scheduleNotification:notification withReminder:reminder];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
