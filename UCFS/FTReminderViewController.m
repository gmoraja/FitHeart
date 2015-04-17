//
//  FitnessReminderViewController.m
//  FitHeart
//
//  Created by Bitgears on 26/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTReminderViewController.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"
#import "FTReminderData.h"
#import "FTReminderSelectView.h"
#import "FTOptionGroupView.h"
#import "FitnessStartDateViewController.h"
#import "AFPickerView.h"
#import "MoodSection.h"
#import "HealthSection.h"
#import "FTNotificationManager.h"

static float dayOfWeekPickerWidth = 138;
static float dayOfMonthPickerWidth = 138;
static float timeHoursPickerWidth = 50;
static float timeMinutesPickerWidth = 50;
static float timeAmPmPickerWidth = 50;
static NSArray *dayOfWeek = nil;
static NSArray *timeFrequencies = nil;
static NSArray *amPm = nil;


@interface FTReminderViewController () {
    FTFrequencySlider *reminderSlider;
    NSArray* timeFrequencies;

    UIFont *pickerFont;
    AFPickerView *dayOfWeekPickerView;
    AFPickerView *timeHoursPickerView;
    AFPickerView *timeMinutesPickerView;
    AFPickerView *timeAmPmPickerView;
    AFPickerView *dayOfMonthPickerView;
    UIImageView *pickerMaskImage;
    UIView *pickerBkgView;
    UIView *sep1View;
    UIView *sep2View;
    UIView *sep3View;
    
    FTReminderData *reminderData;
    BOOL isEdit;
}



@end

@implementation FTReminderViewController

@synthesize reminderLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withReminder:(FTReminderData*)reminder withEditMode:(BOOL)edit
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isEdit = edit;
        currentSection = section;
        if (reminder!=nil) {
            reminderData = reminder;
        }
        else {
            reminderData = [[FTReminderData alloc] initWithSection:(int)[section sectionType] withGoal:0 asDaily:false];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initSlider];
    [self initPickers];
    reminderLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:@"REMINDER"
                    bkgFileName:[currentSection navBarBkg:0]
                      textColor:[currentSection navBarTextColor:0]
                 isBackVisibile: NO
     ];
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    [self updateReminder:reminderData];
    
}


-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(cancelAction:) withSection:currentSection];
}


- (IBAction)cancelAction:(UIButton*)sender {

    [self.navigationController popViewControllerAnimated: YES];
}


-(void)setupRightMenuButton{
    if ([currentSection sectionType]==SECTION_FITNESS) {
        if (isEdit) {
            self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarSaveButtonWithTarget:self action:@selector(nextAction:) withSection:currentSection];
        }
        else {
            self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarNextButtonWithTarget:self action:@selector(nextAction:) withSection:currentSection];
        }
    }
    else {
        self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarSaveButtonWithTarget:self action:@selector(nextAction:) withSection:currentSection];
    }
}



- (IBAction)nextAction:(UIButton*)sender {
    
    if ([currentSection sectionType]==SECTION_FITNESS) {
        
        //save reminders
        [FitnessSection saveReminder:reminderData];
        [self scheduleNotification:reminderData];

        if (isEdit) {
            [self.navigationController popViewControllerAnimated:NO];
        }
        else {
            FitnessStartDateViewController *viewController = [[FitnessStartDateViewController alloc] initWithNibName:@"FitnessStartDateView" bundle:nil];
            [self.navigationController pushViewController:viewController animated:NO];
        }
    }
    else
        if ([currentSection sectionType]==SECTION_MOOD) {
            //save reminders
            [MoodSection saveReminder:reminderData];
            [self scheduleNotification:reminderData];
            
            [self.navigationController popViewControllerAnimated:NO];
            
        }
        else
            if ([currentSection sectionType]==SECTION_HEALTH) {
                //save reminders
                [HealthSection saveReminder:reminderData];
                [self scheduleNotification:reminderData];
                
                [self.navigationController popViewControllerAnimated:NO];
                
            }
    
}


-(void)initSlider  {
    
    timeFrequencies = [[NSArray alloc] initWithObjects:
                       @"NONE",
                       @"DAILY",
                       @"WEEKLY",
                       @"MONTHLY",
                       nil
                       ];
    
    
    
    float y =reminderLabel.frame.origin.y+reminderLabel.frame.size.height+10;
    CGRect reminderSliderRect = CGRectMake(0, y, 320, 90);
    reminderSlider = [UCFSUtil createFrequencySliderWithFrame:reminderSliderRect withSection:currentSection withPositions:timeFrequencies];
    reminderSlider.delegate = self;
    
    [self.view addSubview:reminderSlider];
}

-(void)initPickers {
    
    dayOfWeek = [[NSArray alloc] initWithObjects:
                 @"SUNDAY",
                 @"MONDAY",
                 @"TUESDAY",
                 @"WEDNESDAY",
                 @"THURSDAY",
                 @"FRIDAY",
                 @"SATURDAY",
                 nil
                 ];
    
    amPm = [[NSArray alloc] initWithObjects:
            @"AM",
            @"PM",
            nil
            ];
    
    float offset_y = reminderSlider.frame.origin.y + reminderSlider.frame.size.height + 10;
    float availableHeight = [UCFSUtil contentAreaHeight] - (reminderSlider.frame.origin.y + reminderSlider.frame.size.height +10);
    float rowHeight = floor(availableHeight / 7);
    float pickerHeight = rowHeight*7;
    
    // background
    pickerBkgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, offset_y+(pickerHeight-rowHeight)/2, 320, rowHeight)];
    pickerBkgView.backgroundColor = [currentSection mainColor:-1];
    
    CGRect dayOfWeekPickerRect = CGRectMake(0, offset_y, dayOfWeekPickerWidth, pickerHeight);
    CGRect dayOfMonthPickerRect = CGRectMake(0, offset_y, dayOfMonthPickerWidth, pickerHeight);
    CGRect timeHoursPickerRect = CGRectMake(dayOfWeekPickerRect.origin.x+dayOfWeekPickerRect.size.width, offset_y, timeHoursPickerWidth, pickerHeight);
    CGRect timeMinutesPickerRect = CGRectMake(timeHoursPickerRect.origin.x+timeHoursPickerRect.size.width, offset_y, timeMinutesPickerWidth, pickerHeight);
    CGRect timeAmPmPickerRect = CGRectMake(timeMinutesPickerRect.origin.x+timeMinutesPickerRect.size.width, offset_y, timeAmPmPickerWidth, pickerHeight);
    
    
    dayOfWeekPickerView = [UCFSUtil initPickerWithFrame:dayOfWeekPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:2 withTag:100 ];
    dayOfWeekPickerView.visibleRange = 3;
    [dayOfWeekPickerView reloadData];
    [dayOfWeekPickerView setAccessibilityLabel:@"Reminder day of the week"];
    //[dayOfWeekPickerView setAccessibilityHint:@"Tap to select next day of the week"];
    
    dayOfMonthPickerView = [UCFSUtil initPickerWithFrame:dayOfMonthPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:2 withTag:104 ];
    dayOfMonthPickerView.visibleRange = 3;
    [dayOfMonthPickerView reloadData];
    [dayOfMonthPickerView setAccessibilityLabel:@"Reminder day of month"];
    //[dayOfMonthPickerView setAccessibilityHint:@"Tap to select next day of month"];
    
    
    float sepPadding = 20;
    
    sep1View = [[UIView alloc] initWithFrame:CGRectMake(timeHoursPickerRect.origin.x, offset_y+sepPadding, 1, pickerHeight-sepPadding*2)];
    sep1View.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.8];
    
    timeHoursPickerView = [UCFSUtil initPickerWithFrame:timeHoursPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:0 withTag:101 ];
    timeHoursPickerView.visibleRange = 3;
    [timeHoursPickerView reloadData];
    [timeHoursPickerView setAccessibilityLabel:@"Reminder hours"];
    //[timeHoursPickerView setAccessibilityHint:@"Tap to select next hour"];
    
    sep2View = [[UIView alloc] initWithFrame:CGRectMake(timeMinutesPickerRect.origin.x, offset_y+sepPadding, 1, pickerHeight-sepPadding*2)];
    sep2View.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.8];
    
    timeMinutesPickerView = [UCFSUtil initPickerWithFrame:timeMinutesPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:0 withTag:102 ];
    timeMinutesPickerView.visibleRange = 3;
    [timeMinutesPickerView reloadData];
    [timeMinutesPickerView setAccessibilityLabel:@"Reminder minutes"];
    //[timeMinutesPickerView setAccessibilityHint:@"Tap to select next minute step"];
    
    sep3View = [[UIView alloc] initWithFrame:CGRectMake(timeAmPmPickerRect.origin.x, offset_y+sepPadding, 1, pickerHeight-sepPadding*2)];
    sep3View.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.8];
    
    timeAmPmPickerView = [UCFSUtil initPickerWithFrame:timeAmPmPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:0 withTag:103];
    timeAmPmPickerView.visibleRange = 3;
    [timeAmPmPickerView reloadData];
    [timeAmPmPickerView setAccessibilityLabel:@"Reminder time period"];
    //[timeAmPmPickerView setAccessibilityHint:@"Tap to select ante meridiem or post meridiem"];
    
    float mask_height = 75;
    
    UIImage* gradientTopImg = [UIImage imageNamed:@"picker_gradient_top"];
    UIImageView* gradientTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, offset_y, 320, mask_height)];
    [gradientTop setImage:gradientTopImg];
    [gradientTop setUserInteractionEnabled:NO];
    
    UIImage* gradientBottomImg = [UIImage imageNamed:@"picker_gradient_bottom"];
    UIImageView* gradientBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UCFSUtil contentAreaHeight]-mask_height, 320, mask_height)];
    [gradientBottom setImage:gradientBottomImg];
    [gradientBottom setUserInteractionEnabled:NO];
    
    [self.view addSubview:pickerBkgView];
    [self.view addSubview:dayOfWeekPickerView];
    [self.view addSubview:dayOfMonthPickerView];
    [self.view addSubview:sep1View];
    [self.view addSubview:timeHoursPickerView];
    [self.view addSubview:sep2View];
    [self.view addSubview:timeMinutesPickerView];
    [self.view addSubview:sep3View];
    [self.view addSubview:timeAmPmPickerView];
    [self.view addSubview:gradientTop];
    [self.view addSubview:gradientBottom];
}



- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView
{
    if (pickerView!=nil) {
        switch (pickerView.tag) {
            case 100: return 7; break;
            case 101: return 12; break;
            case 102: return 12; break;
            case 103: return 2; break;
            case 104: return 31; break;
        }
    }
    return 0;
}


- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row
{
    if (pickerView!=nil) {
        int value = 0;
        switch (pickerView.tag) {
            case 100:
                if (dayOfWeek!=nil && row<[dayOfWeek count])
                    return  [dayOfWeek objectAtIndex:row];
                else
                    return 0;
                break;
            case 101:
                if ((row+1)<10)
                    return [NSString stringWithFormat:@"0%i", (row+1)];
                else
                    return [NSString stringWithFormat:@"%i", (row+1)];
                break;
            case 102:
                value = row * 5;
                if (value<10)
                    return [NSString stringWithFormat:@"0%i", value];
                else
                    return [NSString stringWithFormat:@"%i", value];
                break;
            case 103:
                if (amPm!=nil && row<[amPm count])
                    return [amPm objectAtIndex:row];
                else
                    return 0;
                break;
            case 104:
                /*
                if ((row+1)<10)
                    return [NSString stringWithFormat:@"0%i", (row+1)];
                else
                 */
                    return [NSString stringWithFormat:@"%i", (row+1)];
                break;
        }
    }
    
    
    return 0;
    
}


- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row
{
    if (pickerView!=nil) {
        switch (pickerView.tag) {
            case 100:
                reminderData.dayOfWeek = (int)row+1;
                [dayOfWeekPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected day of the week %@", [dayOfWeek objectAtIndex:reminderData.dayOfWeek-1] ]];
                break;
            case 101:
                reminderData.hours = (int)row+1;
                [timeHoursPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected hours %i", reminderData.hours ]];
                break;
            case 102:
                reminderData.minutes = (int)row * 5;
                [timeMinutesPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected minutes %i", reminderData.minutes ]];
                break;
            case 103:
                reminderData.amPm = (int)row;
                [timeAmPmPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected period %@", [amPm objectAtIndex:reminderData.amPm] ]];
                break;
            case 104:
                reminderData.dayOfMonth = (int)row+1;
                [dayOfMonthPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected day of the month %i", reminderData.dayOfMonth ]];
                break;
        }
    }
    
    reminderLabel.text = [self frequencyLabel:(int)reminderData.frequency];
}

- (void)frequencyChanged:(int)frequency {
    switch(frequency) {
        case TIME_FREQUENCY_NONE:
            pickerBkgView.hidden = true;
            pickerMaskImage.hidden = true;
            sep1View.hidden = true;
            sep2View.hidden = true;
            sep3View.hidden = true;
            [self setDayOfWeekPickerVisible:FALSE];
            [self setDayOfMonthPickerVisible:FALSE];
            [self setTimePickerVisible:FALSE];
            break;
        case TIME_FREQUENCY_DAILY:
            sep1View.hidden = FALSE;
            sep2View.hidden = FALSE;
            sep3View.hidden = FALSE;
            pickerMaskImage.hidden = FALSE;
            pickerBkgView.hidden = FALSE;
            [self setDayOfWeekPickerVisible:FALSE];
            [self setDayOfMonthPickerVisible:FALSE];
            [self setTimePickerVisible:TRUE];
            break;
        case TIME_FREQUENCY_WEEKLY:
            sep1View.hidden = FALSE;
            sep2View.hidden = FALSE;
            sep3View.hidden = FALSE;
            pickerBkgView.hidden = false;
            pickerMaskImage.hidden = false;
            [self setDayOfWeekPickerVisible:TRUE];
            [self setDayOfMonthPickerVisible:FALSE];
            [self setTimePickerVisible:TRUE];
            break;
        case TIME_FREQUENCY_MONTHLY:
            sep1View.hidden = FALSE;
            sep2View.hidden = FALSE;
            sep3View.hidden = FALSE;
            pickerBkgView.hidden = false;
            pickerMaskImage.hidden = false;
            [self setDayOfWeekPickerVisible:FALSE];
            [self setDayOfMonthPickerVisible:TRUE];
            [self setTimePickerVisible:TRUE];
            break;
    }
    reminderData.frequency = frequency;
    reminderLabel.text = [self frequencyLabel:reminderData.frequency];
}

- (NSString*)currentDateDay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    NSDate *date = [NSDate date];
    return [dateFormatter stringFromDate:date];
}


- (NSString*)frequencyLabel:(int)frequency {
    NSString *str = nil;
    NSString *day = nil;
    NSString *hours = nil;
    NSString *minutes = nil;
    NSString *ampm = nil;
    NSString *dayOfMonth = nil;
    
    if (frequency!=TIME_FREQUENCY_NONE) {
        day = [[dayOfWeek objectAtIndex:reminderData.dayOfWeek-1] substringWithRange:NSMakeRange(0, 3)];
        hours = [NSString stringWithFormat:@"%i", reminderData.hours ];
        if (reminderData.hours<10) hours = [NSString stringWithFormat:@"0%i", reminderData.hours ];
        minutes = [NSString stringWithFormat:@"%i", reminderData.minutes];
        if (reminderData.minutes<10) minutes = [NSString stringWithFormat:@"0%i", reminderData.minutes ];
        ampm = [amPm objectAtIndex:reminderData.amPm];
        dayOfMonth = [NSString stringWithFormat:@"%i", reminderData.dayOfMonth];
        //if (reminderData.dayOfMonth<10) dayOfMonth = [NSString stringWithFormat:@"0%i", reminderData.dayOfMonth];
        
    }
    
    switch(frequency) {
        case TIME_FREQUENCY_NONE:
            str = @"NONE";
            break;
        case TIME_FREQUENCY_DAILY:
            str = [NSString stringWithFormat:@"DAILY %@:%@ %@", hours, minutes, ampm ];
            break;
        case TIME_FREQUENCY_WEEKLY:
            str = [NSString stringWithFormat:@"EVERY %@ %@:%@ %@", day, hours, minutes, ampm ];
            break;
        case TIME_FREQUENCY_MONTHLY: {
                NSString* suffix = @"th";
                if (reminderData.dayOfMonth==1 || reminderData.dayOfMonth==21 || reminderData.dayOfMonth==31) suffix = @"st";
                else if (reminderData.dayOfMonth==2 || reminderData.dayOfMonth==22 ) suffix = @"nd";
                else if (reminderData.dayOfMonth==3 || reminderData.dayOfMonth==23 ) suffix = @"rd";
            
                str = [NSString stringWithFormat:@"MONTHLY %@%@ %@:%@ %@", dayOfMonth, suffix, hours, minutes, ampm ];
            }
            break;
    }
    
    
    return  str;
}


-(void)setDayOfWeekPickerVisible:(BOOL)visible {
    dayOfWeekPickerView.hidden = !visible;
    dayOfWeekPickerView.userInteractionEnabled = visible;
    [dayOfWeekPickerView setIsAccessibilityElement:visible];
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

-(void)setDayOfMonthPickerVisible:(BOOL)visible {
    dayOfMonthPickerView.hidden = !visible;
    dayOfMonthPickerView.userInteractionEnabled = visible;
    [dayOfMonthPickerView setIsAccessibilityElement:visible];
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

-(void)setTimePickerVisible:(BOOL)visible {
    timeHoursPickerView.hidden = !visible;
    timeMinutesPickerView.hidden = !visible;
    timeAmPmPickerView.hidden = !visible;
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

-(void)updateReminder:(FTReminderData*)reminder {
    reminderData = reminder;
    [reminderSlider updatePosition:reminderData.frequency];
    [reminderSlider setNeedsDisplay];
    
    if (reminderData.dayOfMonth==0 || reminderData.dayOfMonth>31)
        reminderData.dayOfMonth = 1;
    
    dayOfMonthPickerView.selectedRow = reminderData.dayOfMonth-1;
    [dayOfMonthPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected day of the month %i", reminderData.dayOfMonth ]];

    dayOfWeekPickerView.selectedRow = reminderData.dayOfWeek-1;
    [dayOfWeekPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected day of the week %@", [dayOfWeek objectAtIndex:reminderData.dayOfWeek-1] ]];

    timeHoursPickerView.selectedRow = reminderData.hours-1;
    [timeHoursPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected hours %i", reminderData.hours ]];

    timeMinutesPickerView.selectedRow = (reminderData.minutes / 5);
    [timeMinutesPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected minutes %i", reminderData.minutes ]];

    timeAmPmPickerView.selectedRow = reminderData.amPm;
    [timeAmPmPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected period %@", [amPm objectAtIndex:reminderData.amPm] ]];

    [self frequencyChanged:(int)reminderData.frequency];
    
    [dayOfWeekPickerView setNeedsDisplay];
    [timeHoursPickerView setNeedsDisplay];
    [timeMinutesPickerView setNeedsDisplay];
    [timeAmPmPickerView setNeedsDisplay];
    [dayOfMonthPickerView setNeedsDisplay];
    
    
}


-(void)scheduleNotification:(FTReminderData*)reminder {
    if (reminder!=nil) {
        FTNotification* notification = nil;
        if (reminder.frequency!=TIME_FREQUENCY_NONE) {
            //load notification
            notification = [currentSection nextLocalNotificationWithGoal:reminder.goalType withDateType:reminder.frequency withLast:-1];
        }
        else {
            //empty notification
            notification = [[FTNotification alloc] init];
        }
        if (notification!=nil) {
            notification.section =  (int)[currentSection sectionType];
            notification.goal = reminder.goalType;
            [FTNotificationManager scheduleNotification:notification withReminder:reminder];
        }
    }
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
