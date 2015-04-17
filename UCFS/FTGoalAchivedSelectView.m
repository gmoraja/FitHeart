//
//  FTGoalAchivedSelectView.m
//  FitHeart
//
//  Created by Bitgears on 10/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTGoalAchivedSelectView.h"
#import "UCFSUtil.h"
#import "FTFrequencySlider.h"

static float sliderHeight = 70;
static float rowHeight = 37;
static float pickerHeight = 0;
static float timeMonthsPickerWidth = 50;
static float timeHoursPickerWidth = 50;
static float timeMinutesPickerWidth = 50;
static NSArray *timeFrequencies = nil;

@interface FTGoalAchivedSelectView() {
    
    FTFrequencySlider *frequencySlider;
    UIView* pickerContentView;
    UIFont *pickerFont;
    AFPickerView *dayPickerView;
    AFPickerView *monthPickerView;
    AFPickerView *yearPickerView;
    Class<FTSection> currentSection;
    UIImageView *pickerMaskImage;
    UIView *pickerBkgView;
    
    int selectedDay;
    int selectedMonth;
    int selectedYear;
   
}

@end

@implementation FTGoalAchivedSelectView

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

        
        currentAchivedType = 0;
        currentAchivedDate = [NSDate date];
        
        int goal = [currentSection getCurrentGoal];
        [self initSlider:goal];
        [self initPickers:goal];
        [self setLabel:@"ACHIEVE GOAL BY"];
        [self setText:@"" withColor:[currentSection mainColor:goal]];
    
        pickerContentView.hidden = YES;
        
    }
    return self;
}

-(void)initSlider:(int)goal  {
    
    timeFrequencies = [[NSArray alloc] initWithObjects:
                       @"30 DAYS",
                       @"1 YEAR",
                       @"Pick a date",
                       nil
                       ];
    
    CGRect reminderSliderRect = CGRectMake(0, 0, self.frame.size.width, sliderHeight);
    frequencySlider = [UCFSUtil createFrequencySliderWithFrame:reminderSliderRect withSection:currentSection withPositions:timeFrequencies];
    frequencySlider.delegate = self;
    
    [contentView addSubview:frequencySlider];
}


-(void)initPickers:(int)goal {
    pickerHeight = rowHeight*5;
    
    float offset_y = frequencySlider.frame.origin.y + frequencySlider.frame.size.height + 10;
    pickerContentView = [[UIView alloc] initWithFrame:CGRectMake(0, offset_y, 320, pickerHeight)];
    
    offset_y = 0;
    // background
    pickerBkgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, offset_y+(pickerHeight-rowHeight)/2, 320, rowHeight)];
    pickerBkgView.backgroundColor = [currentSection mainColor:goal];
    
    //background mask
    UIImage *picker_mask = [UIImage imageNamed:@"picker_mask"];
    pickerMaskImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, offset_y, picker_mask.size.width, picker_mask.size.height)];
    pickerMaskImage.image = picker_mask;
    
    CGRect monthPickerRect = CGRectMake(88, offset_y, timeMonthsPickerWidth, pickerHeight);
    CGRect dayPickerRect = CGRectMake(monthPickerRect.origin.x+monthPickerRect.size.width, offset_y, timeHoursPickerWidth, pickerHeight);
    CGRect yearPickerRect = CGRectMake(dayPickerRect.origin.x+dayPickerRect.size.width, offset_y, timeMinutesPickerWidth, pickerHeight);
    
    float sepPadding = 20;
    
    UIView *sep1View = [[UIView alloc] initWithFrame:CGRectMake(monthPickerRect.origin.x, offset_y+sepPadding, 1, pickerHeight-sepPadding*2)];
    sep1View.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.8];
    
    monthPickerView = [UCFSUtil initPickerWithFrame:monthPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:2 withTag:100 ];
    [monthPickerView reloadData];
    
    UIView *sep2View = [[UIView alloc] initWithFrame:CGRectMake(dayPickerRect.origin.x, offset_y+sepPadding, 1, pickerHeight-sepPadding*2)];
    sep2View.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.8];
    
    dayPickerView = [UCFSUtil initPickerWithFrame:dayPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:0 withTag:101 ];
    [dayPickerView reloadData];
    
    UIView *sep3View = [[UIView alloc] initWithFrame:CGRectMake(yearPickerRect.origin.x, offset_y+sepPadding, 1, pickerHeight-sepPadding*2)];
    sep3View.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.8];
    
    yearPickerView = [UCFSUtil initPickerWithFrame:yearPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:0 withTag:102 ];
    yearPickerView.selectedRow=0;
    [yearPickerView reloadData];
    
    UIView *sep4View = [[UIView alloc] initWithFrame:CGRectMake(yearPickerRect.origin.x+yearPickerRect.size.width, offset_y+sepPadding, 1, pickerHeight-sepPadding*2)];
    sep4View.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:0.8];
    
    [pickerContentView addSubview:pickerBkgView];
    [pickerContentView addSubview:sep1View];
    [pickerContentView addSubview:monthPickerView];
    [pickerContentView addSubview:sep2View];
    [pickerContentView addSubview:dayPickerView];
    [pickerContentView addSubview:sep3View];
    [pickerContentView addSubview:yearPickerView];
    [pickerContentView addSubview:sep4View];
    [pickerContentView addSubview:pickerMaskImage];
    
    [contentView addSubview:pickerContentView];
    
}


- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView
{
    if (pickerView!=nil) {
        switch (pickerView.tag) {
            case 100:
                return [UCFSUtil numMonthWithYear:selectedYear];
                break;
            case 101:
                return [UCFSUtil numDaysWithMonth:selectedMonth withYear:selectedYear];
                break;
            case 102:
                return 4;
                break;
        }
    }
    return 0;
}


- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row
{
    if (pickerView!=nil) {
        NSInteger currentYear = [[UCFSUtil dateComp] year];
        switch (pickerView.tag) {
            case 100:
                if ((row+1)<10)
                    return [NSString stringWithFormat:@"0%i", row+1];
                else
                    return [NSString stringWithFormat:@"%i", row+1];
                
                break;
            case 101:
                if ((row+1)<10)
                    return [NSString stringWithFormat:@"0%i", row+1];
                else
                    return [NSString stringWithFormat:@"%i", row+1];
                break;
            case 102:
                
                return [NSString stringWithFormat:@"%i", currentYear + row];
                break;
                
        }
    }
    
    
    return [NSString stringWithFormat:@"%i", row];
}


- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row
{
    NSInteger currentYear = [[UCFSUtil dateComp] year];
    
    if (pickerView!=nil) {
        switch (pickerView.tag) {
            case 100:
                selectedMonth = row+1;
                break;
            case 101:
                selectedDay = row+1;
                break;
            case 102:
                selectedYear = currentYear + row;
                
                [dayPickerView reloadData];
                dayPickerView.selectedRow = selectedDay-1;
                break;
        }
    }
    NSString *dateStr = [NSString stringWithFormat:@"%i/%i/%i", selectedMonth, selectedDay, selectedYear];
    [self setText:dateStr];
}

- (void)frequencyChanged:(int)frequency {
    
    currentAchivedType = frequency;
    [self updateUI];
}

-(void)updateUI {
    NSString *title;
    if (currentAchivedType==2) { //date
        pickerContentView.hidden = NO;
        [self updatePickersWithDate:currentAchivedDate];
    }
    else {
        pickerContentView.hidden = YES;
        title = [timeFrequencies objectAtIndex:currentAchivedType];
        [self setText:title withColor:[currentSection mainColor:-1]];
    }
}

-(void)updatePickersWithDate:(NSDate*)date {
    if (date==nil)
        date = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps =  [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger currentYear = [[UCFSUtil dateComp] year];
    selectedYear = [comps year];
    selectedMonth = [comps month];
    selectedDay = [comps day];
    
    
    dayPickerView.selectedRow = selectedDay-1;
    monthPickerView.selectedRow = selectedMonth-1;
    yearPickerView.selectedRow = (currentYear-selectedYear);
    [dayPickerView setNeedsDisplay];
    [monthPickerView setNeedsDisplay];
    [yearPickerView setNeedsDisplay];
    NSString *dateStr = [NSString stringWithFormat:@"%i/%i/%i", selectedMonth, selectedDay, selectedYear];
    [self setText:dateStr];
}

- (void)updateAchivedType:(int)achivedType withDate:(NSDate*)achivedDate {
    currentAchivedDate = achivedDate;
    currentAchivedType = achivedType;
    frequencySlider.position = achivedType;
    if (achivedType==2) {
        [self updatePickersWithDate:achivedDate];
    }
    [self updateUI];
    
}

- (int)getAchivedType {
    return currentAchivedType;
}

- (NSDate*)getAchivedDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    
    //set date components
    [comps setDay:selectedDay];
    [comps setMonth:selectedMonth];
    [comps setYear:selectedYear];
    
    //save date relative from date
    return [calendar dateFromComponents:comps];
}



@end
