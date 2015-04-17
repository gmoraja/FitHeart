//
//  MoodHomeViewController.m
//  FitHeart
//
//  Created by Bitgears on 19/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "MoodHomeViewController.h"
#import "MenuItem.h"
#import "UCFSUtil.h"
#import "MoodSection.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "LateralMenuViewController.h"
#import "FTBannerView.h"
#import "FTAppSettings.h"
#import "FTHowDoYouFeelViewController.h"
#import "FTReminderViewController.h"
#import "MoodHistoryViewController.h"
#import "AppDelegate.h"


static NSArray *moodMessageArray = nil;


@interface MoodHomeViewController () {
    UIImageView* reminderImageView;
    
    FTReminderData* reminder;
    
    UIImageView* lastLogImageView;
    UILabel* lastLogEnteredLabel;
    UILabel* lastLogValueLabel;
    UILabel* messageLabel;

}

@end

@implementation MoodHomeViewController

@synthesize contentView;
@synthesize enterMoodButton;

- (id)initWithAction:(FTNotificationAction*)action
{
    self = [super initWithNibName:@"MoodHomeView"
                           bundle:nil
                      withSection:[MoodSection class]
                  withGoalNibName:nil
                   withLogNibName:nil
            ];
    
    if (self) {
        // Custom initialization
        showHomeView = FALSE;
        isSwipeEnabled = FALSE;
        
        
    }
    return self;
}


- (void)viewDidLoad
{
    containerView = contentView;
    
    [super viewDidLoad];
    
    
    static float w = 181;
    static float h = 181;
    if ([UCFSUtil deviceIs3inch]){
        w = 140;
        h = 140;
    }
    
    lastLogImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-w)/2, 52, w, h)];
    lastLogImageView.userInteractionEnabled = YES;
    [lastLogImageView setIsAccessibilityElement:YES];

    lastLogEnteredLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lastLogImageView.frame.origin.y+h+26, 320, 16)];
    lastLogEnteredLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0  blue:118.0/255.0  alpha:1.0];
    lastLogEnteredLabel.backgroundColor = [UIColor clearColor];
    lastLogEnteredLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:(16.0)];
    lastLogEnteredLabel.textAlignment =  NSTextAlignmentCenter;
    lastLogEnteredLabel.lineBreakMode = NSLineBreakByWordWrapping;
    lastLogEnteredLabel.numberOfLines = 1;
    lastLogEnteredLabel.text = @"";
    
    
    lastLogValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, lastLogEnteredLabel.frame.origin.y+lastLogEnteredLabel.frame.size.height, 320, 30)];
    lastLogValueLabel.textColor = [UIColor blackColor];
    lastLogValueLabel.backgroundColor = [UIColor clearColor];
    lastLogValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(22.0)];
    lastLogValueLabel.textAlignment =  NSTextAlignmentCenter;
    lastLogValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    lastLogValueLabel.numberOfLines = 1;
    lastLogValueLabel.text = @"";
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, lastLogValueLabel.frame.origin.y+lastLogValueLabel.frame.size.height+20, 280, 30)];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:(18.0)];
    messageLabel.textAlignment =  NSTextAlignmentCenter;
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.numberOfLines = 0;
    messageLabel.text = @"";
    
    enterMoodButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];

    [contentView addSubview:lastLogImageView];
    [contentView addSubview:lastLogEnteredLabel];
    [contentView addSubview:lastLogValueLabel];
    [contentView addSubview:messageLabel];

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    reminder = [MoodSection loadReminderWithGoal:0];
    if (reminder!=nil && reminder.frequency!=0) {
        [self setupRightMenuButton:YES];
    }
    else {
        [self setupRightMenuButton:NO];
    }
    
    //last log
    FTLogData* lastLog = [MoodSection lastLogDataWithGoalType:0];
    if (lastLog!=nil) {
        lastLogEnteredLabel.text = @"entered";
        lastLogValueLabel.text = [UCFSUtil formatDate:lastLog.insertDate withFormat:@"MMM dd"];
        int intValue = (int)(lastLog.logValue);
        [lastLogImageView setAccessibilityLabel:@"Mood status"];
        switch(intValue) {
            case 0:
                [lastLogImageView setImage:[UIImage imageNamed:@"mood_smile_5_big"]];
                [lastLogImageView setAccessibilityValue:@"Very bad"];
                break;
            case 1:
                [lastLogImageView setImage:[UIImage imageNamed:@"mood_smile_4_big"]];
                [lastLogImageView setAccessibilityValue:@"Bad"];
                break;
            case 2:
                [lastLogImageView setImage:[UIImage imageNamed:@"mood_smile_3_big"]];
                [lastLogImageView setAccessibilityValue:@"Neutral"];
                break;
            case 3:
                [lastLogImageView setImage:[UIImage imageNamed:@"mood_smile_2_big"]];
                [lastLogImageView setAccessibilityValue:@"Good"];
                break;
            case 4:
                [lastLogImageView setImage:[UIImage imageNamed:@"mood_smile_1_big"]];
                [lastLogImageView setAccessibilityValue:@"Very good"];
                break;
        }
        
        lastLogImageView.hidden = NO;

        messageLabel.text = [MoodHomeViewController getMoodMessage];
        [messageLabel sizeToFit];
        CGRect oldFrame = messageLabel.frame;
        CGRect newFrame = CGRectMake((320-oldFrame.size.width)/2, lastLogValueLabel.frame.origin.y+lastLogValueLabel.frame.size.height+20, oldFrame.size.width, oldFrame.size.height);
        messageLabel.frame = newFrame;

    }
    else {
        lastLogImageView.hidden = YES;
        
        messageLabel.text = [MoodHomeViewController getMoodMessage];
        [messageLabel sizeToFit];
        CGRect oldFrame = messageLabel.frame;
        CGRect newFrame = CGRectMake((320-oldFrame.size.width)/2, ([UCFSUtil fullContentAreaHeight]-oldFrame.size.height-enterMoodButton.frame.size.height)/2, oldFrame.size.width, oldFrame.size.height);
        messageLabel.frame = newFrame;
    }
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate selectMenuItem:2];

    
}

-(void)setupLeftMenuButton {
    [self.navigationItem setLeftBarButtonItem:[UCFSUtil getNavigationBarMenuDarkButton:nil withTarget:self action:@selector(menuAction:)] animated:NO];
}

-(void)setupRightMenuButton:(BOOL)on {
    if (on)
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarReminderButtonWithTarget:self action:@selector(reminderAction:) asDark:YES];
    else
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarReminderOffButtonWithTarget:self action:@selector(reminderAction:) asDark:YES];
}



- (IBAction)reminderAction:(UIButton*)sender {
    
    FTReminderData* remider = [MoodSection loadReminderWithGoal:0];
    if (remider==nil) {
        remider = [MoodSection defaultReminderWithGoal:0];
    }
    
    UIViewController* viewController = [[FTReminderViewController alloc] initWithNibName:@"MoodReminderView" bundle:nil withSection:[MoodSection class] withReminder:remider withEditMode:true];
    [self goTo:viewController];
    
}

-(void)openHistory {
    [super openHistory];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    UIViewController* viewController = [[MoodHistoryViewController alloc] initWithNibName:@"MoodHistoryView" bundle:nil withSection:[MoodSection class]];
    
    [self.navigationController pushViewController:viewController animated:NO];
    
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if([recognizer direction] == UISwipeGestureRecognizerDirectionDown) {
        [self openHistory];

    }
    
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

-(void)goToScreen:(int)screen {
    UIViewController *viewController = nil;
    switch (screen) {
        case 0: //simple pleasures
            //viewController = [[MoodSimplePleasuresViewController alloc] initWithNibName:@"MoodSimplePleasuresView" bundle:nil];
            break;
            
        default:
            break;
    }
    [self goTo:viewController];
}

- (IBAction)enterMoodAction:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    FTHowDoYouFeelViewController *viewController = [[FTHowDoYouFeelViewController alloc] initWithNibName:@"MoodHowDoYouFeelView" bundle:nil withSection:currentSection];
    
    [self.navigationController pushViewController:viewController animated:NO];
}


+ (NSString*)getMoodMessage {
    if (moodMessageArray==nil) {
        moodMessageArray = [[NSArray alloc] initWithObjects:
                                          @"Your mood can help improve your health.",
                                          @"Even under stress, people can still have positive experiences, too.",
                                          @"Positive emotions – like joy, interest, contentment, and love – can reduce stress.",
                                          @"Savoring positive activities can help you cope with stress.",
                                          @"Savor positive activities: Celebrate! Slow down and enjoy it. Tell a friend.",
                                          @"Take the time to notice and cherish small positive events that happen everyday.",
                                          @"Think back on something good in the past. How did you feel then? Now?",
                                          @"Gratitude can be the way you feel when you’re thankful. Are you thankful?",
                                          @"Gratitude can lead to positive emotions and reduce stress. Are you thankful?",
                                          @"Gratitude strengthens social ties and increases feelings of self worth.",
                                          @"Mindfulness is a way of paying attention non-judgmentally in the present moment.",
                                          @"Mindfulness can make bad things less overwhelming.",
                                          @"Mindfulness can help you note good things you might have overlooked.",
                                          @"How you think about an event can make it feel stressful, relaxing, or meaningful.",
                                          @"Interpret small annoyances or obstacles in a more positive way to reduce stress.",
                                          @"Think of something mildly stressful. Can you think about it in a more positive way?",
                                          @"You can use your personal strengths to cope with stress in a positive way.",
                                          @"Recalling your strengths can often help you accomplish what you want to do.",
                                          @"Achieving goals can help you experience positive emotions and reduce stress.",
                                          @"When setting attainable goals for yourself, keep your strengths and skills in mind.",
                                          @"Doing nice things for other people can make you feel better.",
                                          @"Have you done something nice for someone else recently?",
                                          @"Try to do something nice for someone else – a friend, family, or a stranger.",

                                          nil
                                          ];
    }
    
    int index = [FTAppSettings getMoodMessageIndex];
    index++;
    if (index>=[moodMessageArray count])
        index = 0;
    [FTAppSettings setMoodMessageIndex:index];
    
    return moodMessageArray[index];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
