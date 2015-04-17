//
//  FTReminderSelectView.m
//  FitHeart
//
//  Created by Bitgears on 02/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTReminderSelectView.h"
#import "UCFSUtil.h"
#import "FTFrequencySlider.h"

static float sliderHeight = 70;
static float rowHeight = 37;
static float pickerHeight = 0;
static float dayOfWeekPickerWidth = 138;
static float dayOfMonthPickerWidth = 138;
static float timeHoursPickerWidth = 50;
static float timeMinutesPickerWidth = 50;
static float timeAmPmPickerWidth = 50;
static NSArray *dayOfWeek = nil;
static NSArray *timeFrequencies = nil;
static NSArray *amPm = nil;

@interface FTReminderSelectView() {

    FTFrequencySlider *reminderSlider;
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
    Class<FTSection> currentSection;
    
}

@end


@implementation FTReminderSelectView

@synthesize reminderData;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withFont:(NSString*)fontName withFontSize:(float)fontSize  {
    CGRect contentFrame = CGRectMake(0, frame.size.height, frame.size.width, 280);
    self = [super initWithFrame:frame withContentFrame:contentFrame];
    if (self) {
        // Initialization code
        currentSection = section;
        pickerFont = [UIFont fontWithName:fontName size:fontSize];

        int goal = [currentSection getCurrentGoal];
        [self initSlider:goal];
        [self initPickers:goal];
        [self setLabel:@"REMINDER"];
        [self setText:@"" withColor:[currentSection mainColor:goal]];
    }
    return self;
}



-(void)initSlider:(int)goal  {
    
    timeFrequencies = [[NSArray alloc] initWithObjects:
                        @"NONE",
                        @"DAILY",
                        @"WEEKLY",
                        @"MONTHLY",
                       nil
                       ];
    
    CGRect reminderSliderRect = CGRectMake(0, 0, self.frame.size.width, sliderHeight);
    reminderSlider = [UCFSUtil createFrequencySliderWithFrame:reminderSliderRect withSection:currentSection withPositions:timeFrequencies];
    reminderSlider.delegate = self;
    
    [contentView addSubview:reminderSlider];
}

-(void)initPickers:(int)goal {
    
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
    
    pickerHeight = rowHeight*5;
    
    float offset_y = reminderSlider.frame.origin.y + reminderSlider.frame.size.height + 10;
    
    // background
    pickerBkgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, offset_y+(pickerHeight-rowHeight)/2, 320, rowHeight)];
    pickerBkgView.backgroundColor = [currentSection mainColor:goal];
    
    //background mask
    UIImage *picker_mask = [UIImage imageNamed:@"picker_mask"];
    pickerMaskImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, offset_y, picker_mask.size.width, picker_mask.size.height)];
    pickerMaskImage.image = picker_mask;
    
    CGRect dayOfWeekPickerRect = CGRectMake(0, offset_y, dayOfWeekPickerWidth, pickerHeight);
    CGRect dayOfMonthPickerRect = CGRectMake(0, offset_y, dayOfMonthPickerWidth, pickerHeight);
    CGRect timeHoursPickerRect = CGRectMake(dayOfWeekPickerRect.origin.x+dayOfWeekPickerRect.size.width, offset_y, timeHoursPickerWidth, pickerHeight);
    CGRect timeMinutesPickerRect = CGRectMake(timeHoursPickerRect.origin.x+timeHoursPickerRect.size.width, offset_y, timeMinutesPickerWidth, pickerHeight);
    CGRect timeAmPmPickerRect = CGRectMake(timeMinutesPickerRect.origin.x+timeMinutesPickerRect.size.width, offset_y, timeAmPmPickerWidth, pickerHeight);
    
    
    dayOfWeekPickerView = [UCFSUtil initPickerWithFrame:dayOfWeekPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:2 withTag:100 ];
    [dayOfWeekPickerView reloadData];
   
    dayOfMonthPickerView = [UCFSUtil initPickerWithFrame:dayOfMonthPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:2 withTag:104 ];
    [dayOfMonthPickerView reloadData];
    
    
    float sepPadding = 20;
    
    sep1View = [[UIView alloc] initWithFrame:CGRectMake(timeHoursPickerRect.origin.x, offset_y+sepPadding, 1, pickerHeight-sepPadding*2)];
    sep1View.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.8];
    
    timeHoursPickerView = [UCFSUtil initPickerWithFrame:timeHoursPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:0 withTag:101 ];
    [timeHoursPickerView reloadData];

    sep2View = [[UIView alloc] initWithFrame:CGRectMake(timeMinutesPickerRect.origin.x, offset_y+sepPadding, 1, pickerHeight-sepPadding*2)];
    sep2View.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.8];
    
    timeMinutesPickerView = [UCFSUtil initPickerWithFrame:timeMinutesPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:0 withTag:102 ];
    [timeMinutesPickerView reloadData];

    sep3View = [[UIView alloc] initWithFrame:CGRectMake(timeAmPmPickerRect.origin.x, offset_y+sepPadding, 1, pickerHeight-sepPadding*2)];
    sep3View.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.8];
    
    timeAmPmPickerView = [UCFSUtil initPickerWithFrame:timeAmPmPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:0 withTag:103];
    [timeAmPmPickerView reloadData];

    [contentView addSubview:pickerBkgView];
    [contentView addSubview:dayOfWeekPickerView];
    [contentView addSubview:dayOfMonthPickerView];
    [contentView addSubview:sep1View];
    [contentView addSubview:timeHoursPickerView];
    [contentView addSubview:sep2View];
    [contentView addSubview:timeMinutesPickerView];
    [contentView addSubview:sep3View];
    [contentView addSubview:timeAmPmPickerView];
    [contentView addSubview:pickerMaskImage];
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
                value = row*5;
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
                if ((row+1)<10)
                    return [NSString stringWithFormat:@"0%i", (row+1)];
                else
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
                reminderData.dayOfWeek = row+1;
                break;
            case 101:
                reminderData.hours = row+1;
                break;
            case 102:
                reminderData.minutes = row*5;
                break;
            case 103:
                reminderData.amPm = row;
                break;
            case 104:
                reminderData.dayOfMonth = row+1;
                break;
        }
    }
    NSString *title = [self frequencyLabel:reminderData.frequency];
    [self setText:title];
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
    NSString *title = [self frequencyLabel:reminderData.frequency];
    [self setText:title];
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
        if (reminderData.dayOfMonth<10) dayOfMonth = [NSString stringWithFormat:@"0%i", reminderData.dayOfMonth];
        
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
        case TIME_FREQUENCY_MONTHLY:
            str = [NSString stringWithFormat:@"MONTHLY %@th %@:%@ %@", dayOfMonth, hours, minutes, ampm ];
            break;
    }
    
    
    return  str;
}


-(void)setDayOfWeekPickerVisible:(BOOL)visible {
    dayOfWeekPickerView.hidden = !visible;
}

-(void)setDayOfMonthPickerVisible:(BOOL)visible {
    dayOfMonthPickerView.hidden = !visible;
}

-(void)setTimePickerVisible:(BOOL)visible {
    timeHoursPickerView.hidden = !visible;
    timeMinutesPickerView.hidden = !visible;
    timeAmPmPickerView.hidden = !visible;
}

-(void)updateReminder:(FTReminderData*)reminder {
    reminderData = reminder;
    [reminderSlider updatePosition:reminderData.frequency];

    if (reminderData.dayOfMonth==0 || reminderData.dayOfMonth>31)
        reminderData.dayOfMonth = 1;
    
    dayOfMonthPickerView.selectedRow = reminderData.dayOfMonth-1;
    dayOfWeekPickerView.selectedRow = reminderData.dayOfWeek-1;
    timeHoursPickerView.selectedRow = reminderData.hours-1;
    timeMinutesPickerView.selectedRow = reminderData.minutes;
    timeAmPmPickerView.selectedRow = reminderData.amPm;
    [self frequencyChanged:reminderData.frequency];
    
    [dayOfWeekPickerView setNeedsDisplay];
    [timeHoursPickerView setNeedsDisplay];
    [timeMinutesPickerView setNeedsDisplay];
    [timeAmPmPickerView setNeedsDisplay];
    [dayOfMonthPickerView setNeedsDisplay];

    
}




@end
