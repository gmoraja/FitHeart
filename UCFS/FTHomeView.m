//
//  FTHomeView.m
//  FitHeart
//
//  Created by Bitgears on 05/02/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

#import "FTHomeView.h"
#import "FTEntriesGraph.h"
#import "FTLogGroupedData.h"
#import "UCFSUtil.h"
#import "FTHomeDatetypeSelectView.h"
#import "FTCircularEntriesGraph.h"

static float DATE_LABEL_HEIGHT = 28;


@interface FTHomeView() {
    Class<FTSection> currentSection;
    
    UIButton* historyButton;
    UILabel *goalLabel;
    UILabel *unitLabel;
    FTEntriesGraph *entriesGraph;

    UILabel *dateLabel;
    UILabel *goalLeftLabel;
    FTCircularEntriesGraph *circularEntriesGraph;
    UILabel *circleStartActivityLabel;
    FTHomeDatetypeSelectView* datetypeSelectView;
    UIImageView* plusGrayIconView;
    
    float currentNormalizedGoalValue1;
    float currentNormalizedGoalValue2;
    CGRect circleInfoLabelRect;
    CGRect circleDoubleInfoLabelRect;
    
    BOOL isDouble;
}


@end


@implementation FTHomeView

@synthesize delegate;
@synthesize currentDateType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section

{
    self = [super initWithFrame:frame];
    if (self) {
        currentDateType = -1;
        currentSelectedEntry = 0;
        //isDouble = asDouble;
        currentSection = section;
        
        float x_center = 0;
        float y_center = 0;


        
        float w = frame.size.width;
        //float h = frame.size.height-DATE_LABEL_HEIGHT-DATETYPE_HEIGHT+DATETYPE_OFFSET_Y;
        float h = 290;
        w = 186;
        h = 186;
        float space_y = 40;
        if ([UCFSUtil deviceIs3inch])
            space_y = 20;



        CGRect circularEntriesGraphFrame = CGRectMake((frame.size.width-w)/2, (frame.size.height-h)/2, w, h);
        
        //CGRect circularEntriesGraphFrame = CGRectMake((frame.size.width-w)/2, dateLabel.frame.origin.y+dateLabel.frame.size.height+space_y, w, h);
        circularEntriesGraph = [[FTCircularEntriesGraph alloc] initWithFrame:circularEntriesGraphFrame
                                                                  withRadius:89
                                                                    withSize:24
                                ];
        circularEntriesGraph.wheelForegroundColor = [section mainColor:-1];
        circularEntriesGraph.wheelBackgroundColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0];
        [circularEntriesGraph resetWithProgress:0 withValue:0 withUnit:@""];
        
        [circularEntriesGraph addTarget:self action:@selector(tappedSelectedEntry:) forControlEvents:UIControlEventTouchUpInside];
        if ([currentSection sectionType]==SECTION_FITNESS)
            [circularEntriesGraph setAccessibilityHint:@"Tap to open week's logs"];
        


        
        x_center = 0;
        y_center = (circularEntriesGraphFrame.origin.y-DATE_LABEL_HEIGHT) / 2;
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y_center, 320, DATE_LABEL_HEIGHT)];
        dateLabel.textColor = [currentSection mainColor:0];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(24.0)];
        dateLabel.textAlignment =  ALIGN_CENTER;
        dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
        dateLabel.numberOfLines = 1;
        dateLabel.text = @"";
        
        x_center = 0;
        y_center = 10;
        if ([UCFSUtil deviceIs3inch])
            y_center = 5;
        
        historyButton = [[UIButton alloc] initWithFrame:CGRectMake(20, y_center, 280, DATE_LABEL_HEIGHT)];
        [historyButton setTitle:@"History" forState:UIControlStateNormal];
        [historyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [historyButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        historyButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:20.0];
        historyButton.userInteractionEnabled = YES;
        [historyButton setAccessibilityLabel:@"History" ];
        [historyButton setAccessibilityHint:@"Tap to open history" ];
        [historyButton addTarget:self action:@selector(historyButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        
        y_center = circularEntriesGraphFrame.origin.y + circularEntriesGraphFrame.size.height + (frame.size.height-circularEntriesGraphFrame.origin.y-circularEntriesGraphFrame.size.height-44) / 2;
        x_center = 0;
        goalLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(x_center, y_center, 320, 24)];
        goalLeftLabel.textColor = [UIColor blackColor];
        goalLeftLabel.backgroundColor = [UIColor clearColor];
        goalLeftLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:(22.0)];
        goalLeftLabel.textAlignment =  ALIGN_CENTER;
        goalLeftLabel.lineBreakMode = NSLineBreakByWordWrapping;
        goalLeftLabel.numberOfLines = 1;
        goalLeftLabel.text = @"";

        x_center = 0;
        goalLabel = [[UILabel alloc] initWithFrame:CGRectMake(x_center, goalLeftLabel.frame.origin.y+goalLeftLabel.frame.size.height, 320, 20)];
        goalLabel.textColor = [UIColor blackColor];
        goalLabel.backgroundColor = [UIColor clearColor];
        goalLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:(16.0)];
        goalLabel.textAlignment =  ALIGN_CENTER;
        goalLabel.lineBreakMode = NSLineBreakByWordWrapping;
        goalLabel.numberOfLines = 1;
        goalLabel.text = @"";
        
        

        if (UIAccessibilityIsVoiceOverRunning())
            [self addSubview:historyButton];
        [self addSubview:dateLabel];
        [self addSubview:circularEntriesGraph];
        [self addSubview:goalLeftLabel];
        [self addSubview:goalLabel];

        
    }
    
    return self;
}

- (float)calculteProgress:(NSMutableArray*)items {
    if (items!=nil) {
        float total = 0;
        for (int i=0; i<[items count]; i++) {
            FTLogData* logData = (FTLogData*)[items objectAtIndex:i];
            total += logData.logValue;
        }
        return total;
    }
    
    return 0;
}

- (void)updateGoalData:(FTGoalData*)goalData withEntries:(NSMutableArray*)items withDateType:(int)dateType withLastLog:(FTLogData*)lastLogData {
    
    currentGoalData = goalData;
    FTHeaderConf* conf = [currentSection headerConfWithGoalType:goalData.dataType.goaltypeId];
    if (currentGoalData!=nil) {
        dateLabel.text = [self formatGoalDate:goalData];
        goalLabel.text = [NSString stringWithFormat:@"(Goal %i)", (int)(trunc(goalData.goalValue))  ];
        float progress = [self calculteProgress:items];
        float diff = goalData.goalValue - progress;
        if (diff>=0) {
            goalLeftLabel.text = [NSString stringWithFormat:@"%i %@ left", (int)(trunc(diff)), conf.unit ];
            
        }
        else
            
            goalLeftLabel.text = [NSString stringWithFormat:@"0 %@ left", conf.unit ];
        [circularEntriesGraph resetWithProgress:progress withValue:goalData.goalValue withUnit:conf.unit];
        [circularEntriesGraph setNeedsDisplay];
    }
    

    
}

- (NSString*)formatGoalDate:(FTGoalData*)goalData {
    NSString* result;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"MMM dd"];
    NSDate *weekStartDate = goalData.startDate;
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 6;
    NSDate *weekEndDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:goalData.startDate options:0];
    
    [dateFormatter setDateFormat:@"MMM dd"];
    result = [dateFormatter stringFromDate:weekStartDate];
    result = [result stringByAppendingString:@" - " ];
    result = [result stringByAppendingString:[dateFormatter stringFromDate:weekEndDate] ];

    return result;
}



- (void)bottomButtonTouchUpInside:(int)dateType {
    //[self updateBottomLabelByDateType:sender.tag];
    [self.delegate buttonDateTypeTouch:dateType];
}


- (IBAction)circularInfoTouch:(UIButton*)sender {
    [self.delegate buttonGoalTouch];
    
}

- (IBAction)buttonInfoTouch:(UIButton*)sender {
    [self.delegate buttonInfoTouch];
    
}

- (IBAction)buttonListTouch:(UIButton*)sender {
    [self.delegate buttonListTouch];
    
}

-(IBAction)historyButtonAction:(id)sender {
    [self.delegate buttonHistoryTouch];
}

- (void)setGoalText:(NSString*)text textColor:(UIColor*)color {
    //goalLabel.textColor = color;
    //goalLabel.text = text;
}

- (void)setUnitText:(NSString*)text textColor:(UIColor*)color {
    //unitLabel.textColor = color;
    unitLabel.text = text;
   
}

-(float)normalizedToDayValue:(float)value withDateType:(int)dateType {
    switch(dateType) {
        case 0:
            return value;
            break;
        case 1:
            return value;
            break;
        case 2:
            return value;
            break;
    }
    return  0;
}


-(float)normalizedToWeekValue:(float)value withDateType:(int)dateType {
    switch(dateType) {
        case 0:
            return value / 7;
            break;
        case 1:
            return value;
            break;
        case 2:
            return value * 4;
            break;
    }
    return  0;
}

-(IBAction)selectedEntry:(id)sender {
    FTLogGroupedData* item = [entriesGraph.items objectAtIndex:entriesGraph.selectedIndex];
    if (item!=nil) {
        currentSelectedEntry = entriesGraph.selectedIndex;
        
    }
    else
        NSLog(@"ERRRORRR");
}

- (IBAction)tappedSelectedEntry:(id)sender {
    if (delegate!=nil)
        [self.delegate buttonEntryTouchWithDate:currentGoalData];
}


-(void)dealloc {
    currentGoalData = nil;
    entriesGraph = nil;
}

- (void)onTappedSelectedEntry {
    
}

@end
