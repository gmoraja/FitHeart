//
//  FTCircularView.m
//  FitHeart
//
//  Created by Bitgears on 27/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//



#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

#import "FTCircularView.h"
#import "UITextArc.h"
#import "FTEntriesGraph.h"
#import "FTLogGroupedData.h"
#import "UCFSUtil.h"

@interface FTCircularView() {
    Class<FTSection> currentSection;
    
    UIImage *circleInfoImage;
    UIImage *circleDoubleInfoImage;
    UIImageView *circleArrowImageView;
    UIImageView *circleImageView;
    UIButton *circleInfoButton;
    UILabel *circleArrowLabel;
    UILabel *circleInfoLabel;
    UIButton *infoButton;
    UIButton *listButton;
    UITextArc *textTopLeftLabel;
    UITextArc *textTopRightLabel;
    UITextArc *textBottomLeftLabel;
    UITextArc *textBottomRightLabel;
    UITextArc *textBottomCenterLabel;
    UIButton *textBottomLeftButton;
    UIButton *textBottomRightButton;
    UIButton *textBottomCenterButton;
    UIColor *textBottomColor;
    FTEntriesGraph *entriesGraph;
    UILabel *circleStartActivityLabel;

    float currentNormalizedGoalValue1;
    float currentNormalizedGoalValue2;
    CGRect circleInfoLabelRect;
    CGRect circleDoubleInfoLabelRect;
    
    BOOL isDouble;
}


@end



@implementation FTCircularView

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
        currentDateType = 1;
        currentSelectedEntry = 0;
        //isDouble = asDouble;
        currentSection = section;

        float x_center = 0;
        float y_center = 0;
        textTopLeftLabel = nil;
        textTopRightLabel = nil;

        UIImage *circleImage = [UIImage imageNamed:[section circularImageFilename]];
        circleImageView = [[UIImageView alloc] initWithImage:circleImage];
        x_center = (frame.size.width - circleImage.size.width) / 2;
        circleImageView.frame = CGRectMake(x_center,10, circleImage.size.width, circleImage.size.height);
        circleImageView.userInteractionEnabled = NO;
        
        circleInfoImage = [UIImage imageNamed:[section circularInfoImageFilename]];
        circleDoubleInfoImage = [UIImage imageNamed:[section circularDoubleInfoImageFilename]];
        x_center = (frame.size.width - circleInfoImage.size.width) / 2;
        circleInfoButton = [[UIButton alloc] initWithFrame:CGRectMake(x_center,0, circleInfoImage.size.width, circleInfoImage.size.height)];
        [circleInfoButton setBackgroundImage:circleInfoImage forState:UIControlStateNormal];
        [circleInfoButton addTarget:self action:@selector(circularInfoTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *infoImage = [UIImage imageNamed:@"info_icon"];
        x_center = frame.size.width - (infoImage.size.width / 2) - 30;
        y_center = frame.size.height - infoImage.size.height - 10;
        infoButton = [[UIButton alloc] initWithFrame:CGRectMake(x_center,y_center, infoImage.size.width, infoImage.size.height)];
        [infoButton setBackgroundImage:infoImage forState:UIControlStateNormal];
        [infoButton addTarget:self action:@selector(buttonInfoTouch:) forControlEvents:UIControlEventTouchUpInside];
  
        UIImage *listImage = [UIImage imageNamed:@"list_icon"];
        x_center = frame.size.width - (listImage.size.width / 2) - 30;
        y_center = 20;
        listButton = [[UIButton alloc] initWithFrame:CGRectMake(x_center,y_center, listImage.size.width, listImage.size.height)];
        [listButton setBackgroundImage:listImage forState:UIControlStateNormal];
        [listButton addTarget:self action:@selector(buttonListTouch:) forControlEvents:UIControlEventTouchUpInside];

        UIImage *circleArrowImage = [UIImage imageNamed:@"circle_arrow.png"];
        circleArrowImageView = [[UIImageView alloc] initWithImage:circleArrowImage];
        x_center = (frame.size.width - circleArrowImage.size.width) / 2;
        circleArrowImageView.frame = CGRectMake(x_center,204, circleArrowImage.size.width, circleArrowImage.size.height);

        x_center = (frame.size.width - 120) / 2;
        y_center = circleArrowImageView.frame.origin.y+10;
        circleArrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(x_center,y_center, 120, 21)];
        circleArrowLabel.textColor = [section circularArrowTextColor];
        circleArrowLabel.backgroundColor = [UIColor clearColor];
        circleArrowLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:(14.0)];
        circleArrowLabel.textAlignment =  ALIGN_CENTER;
        circleArrowLabel.text = @"TODAY";
        
        x_center = (frame.size.width - 48) / 2;
        circleInfoLabelRect = CGRectMake(x_center,circleInfoButton.frame.origin.y+4, 48, 54);
        circleDoubleInfoLabelRect = CGRectMake(x_center,circleInfoButton.frame.origin.y+6, 48, 54);
        circleInfoLabel = [[UILabel alloc] initWithFrame:circleInfoLabelRect];
        circleInfoLabel.textColor = [UIColor whiteColor];
        circleInfoLabel.backgroundColor = [UIColor clearColor];
        circleInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:(17.0)];
        circleInfoLabel.textAlignment =  ALIGN_CENTER;
        circleInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        circleInfoLabel.numberOfLines = 0;
        circleInfoLabel.text = @"SET GOAL";

        x_center = (frame.size.width - 140) / 2;
        y_center = (frame.size.height - 64) / 2;
        circleStartActivityLabel = [[UILabel alloc] initWithFrame:CGRectMake(x_center,y_center, 140, 64)];
        circleStartActivityLabel.textColor = [UIColor grayColor];
        circleStartActivityLabel.backgroundColor = [UIColor clearColor];
        circleStartActivityLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:(18.0)];
        circleStartActivityLabel.textAlignment =  ALIGN_CENTER;
        circleStartActivityLabel.text = @"TAP + BUTTON TOP RIGHT TO LOG ACTIVITY";
        circleStartActivityLabel.lineBreakMode = NSLineBreakByWordWrapping;
        circleStartActivityLabel.numberOfLines = 2;

        CGRect tempRect = CGRectMake(circleImageView.frame.origin.x, circleImageView.frame.origin.y, circleImageView.frame.size.width, circleImageView.frame.size.height);
        
        textTopLeftLabel = [[UITextArc alloc] initWithFrame:tempRect withFontName:@"Futura-CondensedMedium" withFontSize:22.0f];
        textTopLeftLabel.angle = 1.95;
        textTopLeftLabel.radius = 106;
        textTopLeftLabel.textAlignment = TEXTARC_ALIGN_RIGHT;
        
        textTopRightLabel = [[UITextArc alloc] initWithFrame:tempRect withFontName:@"Futura-CondensedMedium" withFontSize:22.0f];
        textTopRightLabel.angle = 1.2;
        textTopRightLabel.radius = 106;
        textTopRightLabel.textAlignment = TEXTARC_ALIGN_LEFT;
        
        textBottomColor = [section circularBottomTextColor];
        
        textBottomLeftLabel = [[UITextArc alloc] initWithFrame:tempRect withFontName:@"Futura-CondensedMedium" withFontSize:22.0f];
        textBottomLeftLabel.angle = 4.48;
        textBottomLeftLabel.radius = 132;
        textBottomLeftLabel.textAlignment = TEXTARC_ALIGN_RIGHT;
        textBottomLeftLabel.text = @"DAY";
        textBottomLeftLabel.color = [UIColor whiteColor];
        textBottomLeftLabel.textOrientation = TEXTARC_ORIEN_INTERNAL;
        textBottomLeftLabel.userInteractionEnabled = NO;

        textBottomCenterLabel  = [[UITextArc alloc] initWithFrame:tempRect withFontName:@"Futura-CondensedMedium" withFontSize:22.0f];
        textBottomCenterLabel.angle = 4.73;
        textBottomCenterLabel.radius = 132;
        textBottomCenterLabel.textAlignment = TEXTARC_ALIGN_CENTER;
        textBottomCenterLabel.text = @"WEEK";
        textBottomCenterLabel.color = [UIColor whiteColor];
        textBottomCenterLabel.textOrientation = TEXTARC_ORIEN_INTERNAL;
        textBottomCenterLabel.userInteractionEnabled = NO;

        textBottomRightLabel  = [[UITextArc alloc] initWithFrame:tempRect withFontName:@"Futura-CondensedMedium" withFontSize:22.0f];
        textBottomRightLabel.angle = 4.97;
        textBottomRightLabel.radius = 132;
        textBottomRightLabel.textAlignment = TEXTARC_ALIGN_LEFT;
        textBottomRightLabel.text = @"MONTH";
        textBottomRightLabel.color = [UIColor whiteColor];
        textBottomRightLabel.textOrientation = TEXTARC_ORIEN_INTERNAL;
        textBottomRightLabel.userInteractionEnabled = NO;

        textBottomLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(102,242, 36, 33)];
        textBottomCenterButton = [[UIButton alloc] initWithFrame:CGRectMake(140,247, 42, 37)];
        textBottomRightButton = [[UIButton alloc] initWithFrame:CGRectMake(188,235, 48, 40)];
        textBottomLeftButton.tag = 0;
        textBottomCenterButton.tag = 1;
        textBottomRightButton.tag = 2;
        [textBottomLeftButton addTarget:self action:@selector(bottomButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [textBottomCenterButton addTarget:self action:@selector(bottomButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [textBottomRightButton addTarget:self action:@selector(bottomButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        float w = 204;
        float h = 143;
        //x_center = circleImageView.frame.origin.x+37;
        //y_center = circleImageView.frame.origin.y+37;

        x_center = (frame.size.width - w) / 2;
        y_center = circleImageView.frame.origin.y + (circleImageView.frame.size.height / 2) - (h/2);
        CGRect entriesGraphFrame = CGRectMake(x_center, y_center, w, h);
        entriesGraph = [[FTEntriesGraph alloc] initWithFrame:entriesGraphFrame
                                                withBarWidth:32
                                           withMaxLimitImage:[section circularMaxLimitImageFilename]
                                             withTopFixImage:[section circularTopFixImageFilename]
                                  withTopFixNonTappableImage:[section circularTopFixNotTappableImageFilename]
                        
                        ];
        entriesGraph.barColor = [UIColor lightGrayColor];
        entriesGraph.bar2Color = [UIColor grayColor];
        entriesGraph.hidden = YES;
        entriesGraph.delegate = self;
        [entriesGraph addTarget:self action:@selector(selectedEntry:) forControlEvents:UIControlEventValueChanged];

        
        [self addSubview:circleStartActivityLabel];
        [self addSubview:circleImageView];

        [self addSubview:textTopLeftLabel];
        [self addSubview:textTopRightLabel];
        [self addSubview:textBottomLeftLabel];
        [self addSubview:textBottomCenterLabel];
        [self addSubview:textBottomRightLabel];
        [self addSubview:textBottomLeftButton];
        [self addSubview:textBottomCenterButton];
        [self addSubview:textBottomRightButton];
        
        [self addSubview:entriesGraph];
        [self addSubview:circleArrowImageView];
        [self addSubview:circleArrowLabel];

        [self addSubview:circleInfoButton];
        [self addSubview:listButton];
        [self addSubview:infoButton];
        [self addSubview:circleInfoLabel];
        
        [self updateBottomLabelByDateType:1];


    }
    return self;
}

- (void)updateBottomLabelByDateType:(int)dateType {
    switch(dateType) {
        case 0: //day
            textBottomLeftLabel.color = textBottomColor;
            textBottomCenterLabel.color = [UIColor whiteColor];
            textBottomRightLabel.color = [UIColor whiteColor];
            break;
        case 1: //week
            textBottomLeftLabel.color = [UIColor whiteColor];
            textBottomCenterLabel.color = textBottomColor;
            textBottomRightLabel.color = [UIColor whiteColor];
            break;
        case 2: //month
            textBottomLeftLabel.color = [UIColor whiteColor];
            textBottomCenterLabel.color = [UIColor whiteColor];
            textBottomRightLabel.color = textBottomColor;
            break;
    }
    [textBottomLeftLabel setNeedsDisplay];
    [textBottomCenterLabel setNeedsDisplay];
    [textBottomRightLabel setNeedsDisplay];
}

- (IBAction)bottomButtonTouchUpInside:(UIButton*)sender {
    //[self updateBottomLabelByDateType:sender.tag];
    [self.delegate buttonDateTypeTouch:sender.tag];
}

- (void)setGoalText:(NSString*)text textColor:(UIColor*)color {
    textTopLeftLabel.text = text;
    textTopLeftLabel.color = color;

    [textTopLeftLabel setNeedsDisplay];

}

- (void)setUnitText:(NSString*)text textColor:(UIColor*)color {
    textTopRightLabel.text = text;
    textTopRightLabel.color = color;

    [textTopRightLabel setNeedsDisplay];

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

-(float)normalizedValue:(float)value withDateType:(int)dateType {
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

- (void)updateGoalData:(FTGoalData*)goalData withEntries:(NSMutableArray*)items withDateType:(int)dateType withLastLog:(FTLogData*)lastLogData {
    
    currentGoalData = goalData;
    FTHeaderConf* conf = [currentSection headerConfWithGoalType:goalData.dataType.goaltypeId];
    if (lastLogData==nil && currentGoalData==nil) {
        textBottomLeftLabel.hidden = YES;
        textBottomCenterLabel.hidden = YES;
        textBottomRightLabel.hidden = YES;
        entriesGraph.hidden = YES;
        circleStartActivityLabel.hidden = NO;
        circleInfoLabel.text = @"SET GOAL";
        circleArrowLabel.text = @"TODAY";
        [circleInfoButton setBackgroundImage:circleInfoImage forState:UIControlStateNormal];
        circleInfoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        circleInfoLabel.numberOfLines = 0;
        circleInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:(17.0)];
        circleInfoLabel.frame = circleInfoLabelRect;
        listButton.hidden = YES;
    }
    else {
        if (currentDateType!=dateType) {
            currentDateType = dateType;
            currentSelectedEntry = 0;
        }
        //show date label
        textBottomLeftLabel.hidden = NO;
        textBottomCenterLabel.hidden = NO;
        textBottomRightLabel.hidden = NO;
        //show normalized goal
        if (currentGoalData!=nil) {
            
            //check if is double
            NSString* value1Str;
            NSString* value2Str;
            if (conf.normalizeValue)
                currentNormalizedGoalValue1 = [self normalizedValue:currentGoalData.goalValue withDateType:dateType];
            else
                currentNormalizedGoalValue1 = currentGoalData.goalValue;
            value1Str = [UCFSUtil stringWithValue:currentNormalizedGoalValue1 formatAsFloat:conf.valueIsFloat formatAsCompact:conf.compactValue];

            circleInfoLabel.numberOfLines = 1;
            circleInfoLabel.adjustsFontSizeToFitWidth = true;
            circleInfoLabel.minimumFontSize = 16.0;
            circleInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:(24.0)];
            circleInfoLabel.text = value1Str;
            circleInfoLabel.frame = circleInfoLabelRect;

            [circleInfoButton setBackgroundImage:circleInfoImage forState:UIControlStateNormal];
            
            circleArrowLabel.text = @"TODAY";
            entriesGraph.goalValueImageVisible = TRUE;
            entriesGraph.maxValue = currentNormalizedGoalValue1 * 100 / 70;
        }
        else {
            circleInfoLabel.text = @"SET GOAL";
            circleInfoLabel.lineBreakMode = UILineBreakModeWordWrap;
            circleInfoLabel.numberOfLines = 0;
            circleInfoLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:(17.0)];
            [circleInfoButton setBackgroundImage:circleInfoImage forState:UIControlStateNormal];
            entriesGraph.goalValueImageVisible = FALSE;
        }
        //show items
        if (lastLogData!=nil && items!=nil && ([items count]>0) ) {
            circleStartActivityLabel.hidden = YES;
            entriesGraph.hidden = NO;
            entriesGraph.items = items;
            entriesGraph.selectedIndex = currentSelectedEntry;
            entriesGraph.formatValueAsFloat = conf.valueIsFloat;
            entriesGraph.formatValueAsCompact = conf.compactValue;
            entriesGraph.isTappable = (dateType==0);
            [entriesGraph setNeedsDisplay];
            listButton.hidden = NO;
            FTLogGroupedData* item = [entriesGraph.items objectAtIndex:entriesGraph.selectedIndex];
            circleArrowLabel.text = [UCFSUtil formatLogDate:item];
        }
        else {
            circleStartActivityLabel.hidden = NO;
            entriesGraph.hidden = YES;
            circleArrowLabel.text = @"TODAY";
            listButton.hidden = YES;

        }
        
        [self updateBottomLabelByDateType:dateType];
    }

    
}


-(IBAction)selectedEntry:(id)sender {
    FTLogGroupedData* item = [entriesGraph.items objectAtIndex:entriesGraph.selectedIndex];
    if (item!=nil) {
        currentSelectedEntry = entriesGraph.selectedIndex;
        circleArrowLabel.text = [UCFSUtil formatLogDate:item];
    }
    else
        NSLog(@"ERRRORRR");
}

- (void)tappedSelectedEntry {
    if (currentDateType==0) { //DAY
        FTLogGroupedData* item = [entriesGraph.items objectAtIndex:entriesGraph.selectedIndex];
        [self.delegate buttonEntryTouchWithDate:item.dateValue];
    }
}



-(void)dealloc {
    currentGoalData = nil;
    entriesGraph = nil;
    textTopLeftLabel = nil;
    textTopRightLabel = nil;
    textBottomLeftLabel = nil;
    textBottomRightLabel = nil;
    textBottomCenterLabel = nil;
}


@end
