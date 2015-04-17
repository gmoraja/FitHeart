//
//  FTLogContainerView.m
//  FitHeart
//
//  Created by Bitgears on 13/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTLogContainerView.h"
#import "FTSection.h"
#import "FTDoubleHeaderView.h"
#import "FitnessSection.h"
#import "FTLogData.h"
#import "HealthSection.h"


static float sliderSize = 290;
static float sliderHeight = 290;


@interface FTLogContainerView() {

    
    UIButton *dateButton;
    UIButton *activityButton;
    UIButton *effortButton;
    
    UIButton* timerButton;
    
    UIImage* bottomButtonNormalImage;
    UIImage* bottomButtonHighlightedImage;
    
    int currentActiveValue;
    
    BOOL glucoseFirstWarning;
    BOOL systolicFirstWarning;
    BOOL diastolicFirstWarning;
    BOOL firstWarning;
}

@end



@implementation FTLogContainerView

@synthesize headerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        useTimer = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        glucoseFirstWarning = YES;
        systolicFirstWarning = YES;
        diastolicFirstWarning = YES;
        firstWarning = YES;
        useTimer = NO;
        currentSection = section;
        currentGoalData = goalData;
        currentLogData = logData;
        conf = [currentSection headerConfForLogWithGoalType:currentGoalData.dataType.goaltypeId];
        keypadImage = [UIImage imageNamed:@"circle_keypad"];
        infoImage = [UIImage imageNamed:@"info_icon"];
        
        [self initHeader];
        [self initBody];
        [self initBottomButtons];
        [self refreshBottomButtonsWithGoal:currentGoalData withLog:currentLogData];

        
        [self addSubview:bodyContainerView];
        [self addSubview:headerView];
        
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}

- (void)initHeader {
    
    CGRect headerRect = CGRectMake(0, 0, 320, conf.headerHeight);
    switch(conf.uiType) {
        case 0:
        case 1:
            headerView = [[FTSingleHeaderView alloc] initWithFrame:headerRect withConf:conf ];
            [headerView editMode:true withValueIndex:0];
            [headerView.valueText addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];

            break;
        case 2:
            headerView = [[FTDoubleHeaderView alloc] initWithFrame:headerRect withConf:conf ];
            [headerView.valueText addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            FTDoubleHeaderView* doubleHeaderView = (FTDoubleHeaderView*)headerView;
            NSArray *fields = @[ doubleHeaderView.valueText, doubleHeaderView.value2Text];
            doubleHeaderView.value2Text.delegate = self;
            [doubleHeaderView.value2Text addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            doubleHeaderView.delegate = self;
            keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
            if ([UCFSUtil deviceSystemIOS7]) {
                keyboardControls.doneTintColor = [UIColor whiteColor];
                keyboardControls.tintColor = [UIColor whiteColor];
            }
            keyboardControls.delegate = self;
            [doubleHeaderView editMode:true withValueIndex:1];
            break;
    }
    headerView.valueText.delegate = self;
}

- (void)initBody {
    bodyContainerHeight = [UCFSUtil contentAreaHeight]-conf.headerHeight;
    CGRect bodyContainerRect = CGRectMake(0, conf.headerHeight, 320, bodyContainerHeight);
    bodyContainerView = [[UIView alloc] initWithFrame:bodyContainerRect];
    

    [self initMainContainer];
    //[self initOptions];

    
    //mask view
    [self createMask];
    [mainContainerView addSubview:maskView];
    
    [bodyContainerView addSubview:mainContainerView];
    if ([currentSection sectionType]==SECTION_FITNESS && currentGoalData.dataType.goaltypeId==0) {
        [self initTimerButton];
        [bodyContainerView addSubview:timerButton];
    }
    //[bodyContainerView addSubview:optionView];
    
    if (optionView!=nil)
        optionView.slidableView = mainContainerView;
    
    
    
}


- (void)createKeypadButtonWithRect:(CGRect)rect {
    keypadButton = [[UIButton alloc] initWithFrame:rect];
    [keypadButton setBackgroundImage:keypadImage forState:UIControlStateNormal];
    [keypadButton addTarget:self action:@selector(keypadButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)createInfoButtonWithRect:(CGRect)rect {
    infoButton = [[UIButton alloc] initWithFrame:rect];
    [infoButton setBackgroundImage:infoImage forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)createMask {
    CGRect maskViewframe = CGRectMake(0, 0, 320, bodyContainerHeight);
    maskView = [[UIView alloc] initWithFrame:maskViewframe];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.8;
    maskView.userInteractionEnabled = YES;
    maskView.hidden = YES;
    
    UITapGestureRecognizer *tap2Recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskAction:)];
    [tap2Recognizer setNumberOfTapsRequired:1];
    [maskView addGestureRecognizer:tap2Recognizer];
    
    
}

-(IBAction)maskAction:(id)sender {
    [self dismissKeyboard];
}


-(void)initMainContainer {
    float totalHeight = 0;
    float y = 40;
    if ([UCFSUtil deviceIs3inch])
        y = 0;
    CGRect sliderRect = CGRectMake((320-sliderSize) / 2, y, sliderSize, sliderSize);
    
    slider = [UCFSUtil createCircularSliderWithFrame:sliderRect
                                         withSection:currentSection
                                          withTarget:self
                                              action:@selector(newSliderValue:)
                                            asDouble:false
              ];
    slider.increment = [currentSection sliderIncrementByGoal:currentGoalData.dataType.goaltypeId  ];
    slider.stepValue = conf.wheelStepValue;
    [slider setIsAccessibilityElement:NO];
    totalHeight += (sliderSize+y);
   
    
    //create the keypad button
    CGRect keypadButtonRect = CGRectMake((self.frame.size.width - keypadImage.size.width) / 2, slider.frame.origin.y+(slider.frame.size.height-keypadImage.size.height)/2, keypadImage.size.width, keypadImage.size.height);
    [self createKeypadButtonWithRect:keypadButtonRect];
    
    //create the info button
    CGRect infoButtonRect = CGRectMake((self.frame.size.width - infoImage.size.width) / 2, keypadButtonRect.origin.x+keypadButtonRect.size.height+20, infoImage.size.width, infoImage.size.height);
    [self createInfoButtonWithRect:infoButtonRect];
    
    mainContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, totalHeight)];
    [mainContainerView addSubview:slider];
    //[mainContainerView addSubview:keypadButton];
    //[mainContainerView addSubview:infoButton];
    
    
}

-(void)initOptions {
    NSMutableArray *allviews = [[NSMutableArray alloc] init];
    
    CGRect dateRect = CGRectMake(0, 0, 320, 50);
    dateSelect = [[FTDateSelectView alloc] initWithFrame:dateRect
                                             withSection:currentSection
                                                withFont:@"SourceSansPro-Regular"
                                            withFontSize:18.0
                  ];
    //[allviews addObject:dateSelect];
    
    
    if ([currentSection sectionType]==SECTION_FITNESS) {
        
        CGRect activityRect = CGRectMake(0, dateRect.origin.y+dateRect.size.height, 320, 50);
        activitySelect = [[FTActivitySelectView alloc] initWithFrame:activityRect
                                                     withSection:currentSection
                                                        withFont:@"SourceSansPro-Regular"
                                                    withFontSize:18.0
                          ];
        //[allviews addObject:activitySelect];
    
        CGRect effortRect = CGRectMake(0, activityRect.origin.y+activityRect.size.height, 320, 50);
        effortSelect = [[FTEffortSelectView alloc] initWithFrame:effortRect
                                                 withSection:currentSection
                                                    withFont:@"SourceSansPro-Regular"
                                                withFontSize:18.0
                        ];
        //[allviews addObject:effortSelect];
    }

    if ([currentSection sectionType]==SECTION_HEALTH && [currentSection getCurrentGoal]==3) {
        CGRect glucoseRect = CGRectMake(0, dateRect.origin.y+dateRect.size.height, 320, 50);
        glucoseSelect = [[FTGlucoseSelectView alloc] initWithFrame:glucoseRect
                                                 withSection:currentSection
                                                    withFont:@"SourceSansPro-Regular"
                                                withFontSize:18.0
                      ];
        //[allviews addObject:glucoseSelect];
    }

    

    float pos = 0;
    float viewsSpace = [allviews count]*50;
    float contentAreaHeight =[UCFSUtil contentAreaHeight];
    float availableSpace = contentAreaHeight-headerView.frame.size.height - sliderHeight;
    if (availableSpace<viewsSpace) {
        //pos = 430-viewsSpace;
        //if ([UCFSUtil deviceIs3inch]==FALSE) pos = 440-viewsSpace;
        pos = sliderHeight;
    }
    else {
        pos = contentAreaHeight-headerView.frame.size.height-viewsSpace;
    }

    //if ([UCFSUtil deviceIs3inch]==FALSE) pos = 440-viewsSpace;
    
    optionView = [[FTOptionGroupView alloc] initWithFrame:CGRectMake(0, pos, 320, viewsSpace)
                                                withViews:allviews
                  ];
    

    
    if (dateSelect!=nil) dateSelect.delegate = optionView;
    if (activitySelect!=nil) activitySelect.delegate = optionView;
    if (effortSelect!=nil) effortSelect.delegate = optionView;
    if (mealSelect!=nil) mealSelect.delegate = optionView;
    if (glucoseSelect!=nil) glucoseSelect.delegate = optionView;
    
}

-(void)initTimerButton {
    //create the timer button
    if ([currentSection sectionType]==SECTION_FITNESS) {
        UIImage* timerImage = nil;
            timerImage = [UIImage imageNamed:@"timer_btn"];
        
        float optionsHeight = 62;
        CGRect rect = CGRectMake(320-timerImage.size.width-12, bodyContainerHeight-timerImage.size.height-12-optionsHeight, timerImage.size.width, timerImage.size.height);
        
        timerButton = [[UIButton alloc] initWithFrame:rect];
        [timerButton setAccessibilityHint:@"Tap to switch to timer mode"];
        [timerButton setAccessibilityLabel:@"Timer mode"];
        [timerButton setBackgroundImage:timerImage forState:UIControlStateNormal];
        [timerButton addTarget:self action:@selector(switchMode:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)updateTimeButton:(BOOL)asTimer {
    useTimer = asTimer;
    if (useTimer) {
        [timerButton setBackgroundImage:[UIImage imageNamed:@"manual_btn"] forState:UIControlStateNormal];
        [timerButton setAccessibilityHint:@"Tap to switch to manual mode"];
        [timerButton setAccessibilityLabel:@"Manual mode"];
    }
    else {
        [timerButton setAccessibilityHint:@"Tap to switch to timer mode"];
        [timerButton setAccessibilityLabel:@"Timer mode"];
        [timerButton setBackgroundImage:[UIImage imageNamed:@"timer_btn"] forState:UIControlStateNormal];
    }
}


- (IBAction)switchMode:(id)sender {
    if (self.delegate!=nil) {
        if (useTimer) {
             [self.delegate switchToManual];
        }
        else {
             [self.delegate switchToTimer];
        }
    }
    
}





//#################### BOTTOM BUTTON

-(NSMutableAttributedString*)bottomButtonTextWithValue:(NSString*)valueStr withLabel:(NSString*)label {
    // Setup the string
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", valueStr, label]];
    
    [titleText addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0], NSFontAttributeName,
                              [currentSection mainColor:0], NSForegroundColorAttributeName,
                              paragraphStyle, NSParagraphStyleAttributeName,
                              nil]
                       range:NSMakeRange(0, [valueStr length])
     ];
    
    [titleText addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont fontWithName:@"SourceSansPro-Light" size:14.0], NSFontAttributeName,
                              [UIColor blackColor], NSForegroundColorAttributeName,
                              paragraphStyle, NSParagraphStyleAttributeName,
                              nil]
                       range:NSMakeRange([valueStr length]+1, [label length])
     ];
    
    return titleText;
}

-(void) initBottomButtons {
    
    float button_width = 106;
    float button_height = 60;
    float top = bodyContainerView.frame.size.height-button_height;
    float left = 0;
    
    bottomButtonNormalImage = [UCFSUtil imageWithColor:[UIColor whiteColor]];
    bottomButtonHighlightedImage = [UCFSUtil imageWithColor:[UIColor grayColor]];
    
    //DATE BUTTON
    dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([currentSection sectionType]==SECTION_FITNESS)
        dateButton.frame = CGRectMake(left, top, button_width, button_height);
    else
        dateButton.frame = CGRectMake(0, top, 320, button_height);
    dateButton.backgroundColor = [UIColor whiteColor];
    [dateButton setBackgroundImage:bottomButtonHighlightedImage forState:UIControlStateHighlighted];
    [[dateButton titleLabel] setNumberOfLines:2];

    dateButton.userInteractionEnabled = YES;
    [dateButton addTarget:self action:@selector(dateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //ACTIVITY BUTTON
    left = dateButton.frame.origin.x+button_width+1;
    activityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    activityButton.frame = CGRectMake(left, top, button_width, button_height);
    activityButton.backgroundColor = [UIColor whiteColor];
    [activityButton setBackgroundImage:bottomButtonHighlightedImage forState:UIControlStateHighlighted];
    [[activityButton titleLabel] setNumberOfLines:2];
    activityButton.userInteractionEnabled = YES;
    [activityButton addTarget:self action:@selector(activityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //EFFORT BUTTON
    left = activityButton.frame.origin.x+button_width+1;
    effortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    effortButton.frame = CGRectMake(left, top, button_width, button_height);
    effortButton.backgroundColor = [UIColor whiteColor];
    [effortButton setBackgroundImage:bottomButtonHighlightedImage forState:UIControlStateHighlighted];
    [[effortButton titleLabel] setNumberOfLines:2];
    effortButton.userInteractionEnabled = YES;
    [effortButton addTarget:self action:@selector(efforButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bodyContainerView addSubview:dateButton];
    if ([currentSection sectionType]==SECTION_FITNESS) {
        [bodyContainerView addSubview:activityButton];
        [bodyContainerView addSubview:effortButton];
    }
    
}

-(IBAction)dateButtonAction:(id)sender {
    [self.delegate bottomButtonTouched:0];
}

-(IBAction)activityButtonAction:(id)sender {
    [self.delegate bottomButtonTouched:1];
}

-(IBAction)efforButtonAction:(id)sender {
    [self.delegate bottomButtonTouched:2];
}

- (void)refreshBottomButtonsWithGoal:(FTGoalData*)goalData withLog:(FTLogData*)logData {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMM dd"];
    if (logData.insertDate==nil) logData.insertDate = [NSDate date];
    NSString* dateStr = [dateFormatter stringFromDate:logData.insertDate];
    NSMutableAttributedString *dateTitleText = [self bottomButtonTextWithValue:dateStr withLabel:@"DATE"];
    [dateButton setAttributedTitle:dateTitleText forState:UIControlStateNormal];
    
    NSString* activityStr = [[FitnessSection getActivities] objectAtIndex:logData.activity ];
    NSMutableAttributedString* activityTitleText = [self bottomButtonTextWithValue:activityStr withLabel:@"ACTIVITY"];
    [activityButton setAttributedTitle:activityTitleText forState:UIControlStateNormal];

    
    NSString* effortStr = [[FitnessSection getEfforts] objectAtIndex:logData.effort ];
    if (logData.effort==3)
        effortStr = @"S. Easy";
    else
        if (logData.effort==4)
            effortStr = @"S. Hard";
    
    NSMutableAttributedString* effortTitleText = [self bottomButtonTextWithValue:effortStr withLabel:@"EFFORT"];
    [effortButton setAttributedTitle:effortTitleText forState:UIControlStateNormal];
    
}

- (void)refreshBottomButtons {
    [self refreshBottomButtonsWithGoal:currentGoalData withLog:currentLogData];

    
}

//####################


-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if ([self isSliding]==NO) {
        CGRect newTempRect;
        if([recognizer direction] == UISwipeGestureRecognizerDirectionUp) {
            if (bodyContainerView.frame.origin.y>=minY)
                newTempRect = topRect;
        }
        else {
            if (bodyContainerView.frame.origin.y<=maxY)
                newTempRect = bottomRect;
        }
        
        [UIView animateWithDuration:0.2f animations:^{
            bodyContainerView.frame = newTempRect;
        } completion:^(BOOL finished) {
        }];
    }

}




-(void)newSliderValue:(TBCircularSlider*)sender {
    //check values
    BOOL isValue2 = (currentActiveValue!=0);
    BOOL performChanges = true;
    float current = [sender getCurrentValueWithIncrement:YES];
    @try {
        if ([currentSection sectionType]==SECTION_HEALTH) {
            float value = (isValue2 ? currentLogData.logValue : current);
            float value2 = (isValue2 ? current : currentLogData.logValue2);
            [HealthSection checkValueChangesWithGoal:currentGoalData.dataType.goaltypeId
                                           withValue:value
                                          withValue2:value2
                                            asValue2:isValue2
             ];
        }
    }
    @catch (NSException *exception) {
        NSDictionary* dict = exception.userInfo;
        performChanges = [[dict objectForKey:@"performChanges"] boolValue];
        if (performChanges==NO) {
            [self showMessage:exception.reason];
            float logValue = [[dict objectForKey:@"logValue"] floatValue];
            current = logValue;
            [sender setCurrentValue:current];
            firstWarning = YES;
        }
        else {
            if (firstWarning) {
                [self showMessage:exception.reason];
                firstWarning = NO;
            }
        }

    }
    @finally {
        
    }
    

    //if (performChanges) {
        if (currentActiveValue==1) {
            FTDoubleHeaderView* doubleHeaderView = (FTDoubleHeaderView*)headerView;
            
            doubleHeaderView.value2Text.text = [UCFSUtil stringWithValue:current
                                                           formatAsFloat:headerView.conf.valueIsFloat
                                                         formatAsCompact:NO
                                                ];
            
            doubleHeaderView.value2Label.text = [UCFSUtil stringWithValue:current
                                                            formatAsFloat:headerView.conf.valueIsFloat
                                                          formatAsCompact:headerView.conf.compactValue
                                                 ];
            currentLogData.logValue2 = current;
            
        }
        else {
            headerView.valueText.text = [UCFSUtil stringWithValue:current
                                                    formatAsFloat:headerView.conf.valueIsFloat
                                                  formatAsCompact:NO
                                         ];
            
            headerView.valueLabel.text = [UCFSUtil stringWithValue:current
                                                     formatAsFloat:headerView.conf.valueIsFloat
                                                   formatAsCompact:headerView.conf.compactValue
                                          ];
            currentLogData.logValue = current;
            
        }
    //}

    
}



- (IBAction)keypadButtonAction:(id)sender {
    [headerView editMode:TRUE withValueIndex:0];
    [headerView editMode:TRUE withValueIndex:1];
    [headerView editText];
    maskView.hidden = NO;
}

- (IBAction)infoButtonAction:(id)sender {
    if (self.delegate!=nil)
        [self.delegate infoTouched];
}



- (void)updateWithGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData withActiveValue:(int)activeValue {
    currentLogData = logData;
    currentActiveValue = activeValue;
    
    if ([currentSection sectionType]==SECTION_FITNESS && goalData!=nil) {
        currentGoalData = goalData;
        conf = [currentSection headerConfWithGoalType:currentGoalData.dataType.goaltypeId];
    }
    else {
        conf = [currentSection headerConfForLogWithGoalType:logData.goalType];
    }
    
    float logValue = 0;
    if (activeValue==0) {
        logValue = logData.logValue;
    }
    else  {
        logValue = logData.logValue2;
    }


    [slider setupUnitWithStart:conf.minValueLimit
                       withEnd:conf.maxValueLimit
                   withDefault:logValue
                      withStep:conf.wheelStepValue
                withCenterText:conf.unit
     
     ];
    slider.increment = [currentSection sliderIncrementByGoal:goalData.dataType.goaltypeId  ];
    
    headerView.valueText.text = [UCFSUtil stringWithValue:logData.logValue
                                            formatAsFloat:headerView.conf.valueIsFloat
                                          formatAsCompact:NO
                                 ];
    [headerView.valueText setAccessibilityValue:[self logValueAsString:(int)logData.logValue asValue2:NO]];
    
    headerView.valueLabel.text = [UCFSUtil stringWithValue:logData.logValue
                                             formatAsFloat:headerView.conf.valueIsFloat
                                           formatAsCompact:headerView.conf.compactValue
                                  ];
    [headerView.valueLabel setAccessibilityValue:[self logValueAsString:(int)logData.logValue asValue2:NO]];
    
    if (conf.uiType==2) {
        FTDoubleHeaderView* doubleHeaderView = (FTDoubleHeaderView*)headerView;
        doubleHeaderView.value2Text.text = [UCFSUtil stringWithValue:logData.logValue2
                                                 formatAsFloat:headerView.conf.valueIsFloat
                                               formatAsCompact:NO
                                      ];
        [doubleHeaderView.value2Text setAccessibilityValue:[self logValueAsString:(int)logData.logValue2 asValue2:YES]];
        
        doubleHeaderView.value2Label.text = [UCFSUtil stringWithValue:logData.logValue2
                                                  formatAsFloat:headerView.conf.valueIsFloat
                                                formatAsCompact:headerView.conf.compactValue
                                       ];
        [doubleHeaderView.value2Label setAccessibilityValue:[self logValueAsString:(int)logData.logValue2 asValue2:YES]];
    }
    

  
    
    [slider setNeedsDisplay];
    
    [self refreshBottomButtonsWithGoal:goalData withLog:logData];


}


- (FTLogData*)getLogData {
    if (currentLogData==nil)
        currentLogData = [[FTLogData alloc] init];
    float value1 = [headerView.valueText.text floatValue];
    
    if (headerView.conf.valueIsFloat==NO) {
        value1 = round(value1);
    }

    currentLogData.logValue = value1;

    
    return currentLogData;
}


-(BOOL)isSliding {
    if (slider!=nil)
        return [slider isSliding];
    
    return false;
}

- (void)activeValue:(int)valueType {
    [self dismissKeyboard];
    [self updateWithGoalData:currentGoalData withLogData:currentLogData withActiveValue:valueType];
}

//#################### KEYBOARD BEHAVIOUR

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (keyboardControls!=nil)
        [keyboardControls setActiveField:textField];
    maskView.hidden = NO;
    
    [headerView showPencil:FALSE withValueIndex:0];
    [headerView showPencil:FALSE withValueIndex:1];

    if (self.delegate!=nil)
        [self.delegate startEditingValue];
    
}



- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = textField.text;
    //NSLog(@"%li",(long)textField.tag);

    //check values
    BOOL isValue2 = (textField.tag!=0);
    BOOL performChanges = true;
    float value = [text floatValue];

    @try {
        if ([currentSection sectionType]==SECTION_HEALTH) {
            float tmpvalue = (isValue2 ? currentLogData.logValue : value);
            float tmpvalue2 = (isValue2 ? value : currentLogData.logValue2);
            [HealthSection checkValueChangesWithGoal:currentGoalData.dataType.goaltypeId
                                           withValue:tmpvalue
                                          withValue2:tmpvalue2
                                            asValue2:isValue2
             ];
        }
    }
    @catch (NSException *exception) {
        NSDictionary* dict = exception.userInfo;
        performChanges = [[dict objectForKey:@"performChanges"] boolValue];
        if (performChanges==NO) {
            [self showMessage:exception.reason];
            float logValue = [[dict objectForKey:@"logValue"] floatValue];
            value = logValue;
            firstWarning = YES;
        }
        else {
            if (firstWarning) {
                [self showMessage:exception.reason];
                firstWarning = NO;
            }
        }
    }
    @finally {
        
    }

    
    if (performChanges) {
        
        if (isValue2==NO) {
            headerView.valueLabel.text = [UCFSUtil stringWithValue:value
                                                     formatAsFloat:headerView.conf.valueIsFloat
                                                   formatAsCompact:headerView.conf.compactValue
                                          ];
            
            [headerView.valueLabel setAccessibilityValue:[self logValueAsString:(int)value asValue2:NO]];
            [headerView.valueText setAccessibilityValue:[self logValueAsString:(int)value asValue2:NO]];
            currentLogData.logValue = value;
            [headerView editMode:TRUE withValueIndex:0];

        }
        else {
            FTDoubleHeaderView* doubleHeaderView = (FTDoubleHeaderView*)headerView;
            doubleHeaderView.value2Label.text = [UCFSUtil stringWithValue:value
                                                            formatAsFloat:headerView.conf.valueIsFloat
                                                          formatAsCompact:headerView.conf.compactValue
                                                 ];
            [doubleHeaderView.value2Label setAccessibilityValue:[self logValueAsString:(int)value asValue2:YES]];
            [doubleHeaderView.value2Text setAccessibilityValue:[self logValueAsString:(int)value asValue2:YES]];
            [headerView editMode:TRUE withValueIndex:1];
            
            currentLogData.logValue2 = value;
        }

    
        [slider setCurrentValue: [text floatValue] ];
        [slider setNeedsDisplay];
        
        
    }
    else {
        textField.text = [NSString stringWithFormat:@"%i", (int)value];
    }

    [headerView showPencil:TRUE withValueIndex:0];
    [headerView showPencil:TRUE withValueIndex:1];

    if (self.delegate!=nil)
        [self.delegate finishEditingValue];
    
    
}

- (IBAction)showMessage:(NSString*)text {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"FitHeart"
                                                      message:text
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *valueString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    float value = 0;
    if ([valueString length]>0) {
        value = [valueString floatValue];
        if (value>slider.endValue)
            return NO;

    }

    
    return YES;
}

-(void)textChanged:(UITextField *)textField
{
    //accessibility
    NSString* hint = @"new value ";
    BOOL notify = NO;
    if (textField==headerView.valueText) {
        notify = YES;
        int newvalue = [headerView.valueText.text intValue];
        NSString* accValue = [self logValueAsString:newvalue asValue2:NO];
        hint = [hint stringByAppendingString:accValue];
        [headerView.valueLabel setAccessibilityValue:accValue];
        [headerView.valueText setAccessibilityValue:accValue];

    }
    else {
        if ([headerView isKindOfClass:[FTDoubleHeaderView class]]) {
            FTDoubleHeaderView* doubleHeaderView = (FTDoubleHeaderView*)headerView;
            if (textField==doubleHeaderView.value2Text) {
                notify = YES;
                int newvalue = [textField.text intValue];
                NSString* accValue = [self logValueAsString:newvalue asValue2:YES];
                hint = [hint stringByAppendingString:accValue];
                [doubleHeaderView.value2Label setAccessibilityValue:accValue];
                [doubleHeaderView.value2Text setAccessibilityValue:accValue];

            }
        }
    }
    
    if (notify) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, hint);
        });
    }
}

-(NSString*)logValueAsString:(float)value asValue2:(BOOL)isValue2 {
    NSString* result = @"";
    if ([currentSection sectionType]==SECTION_HEALTH) {
        if (currentGoalData!=nil && currentGoalData.dataType.goaltypeId==HEALTH_GOAL_PRESSURE) {
            if (isValue2==NO)
                result = [NSString stringWithFormat:@"%i %@ systolic pressure", (int)value, headerView.conf.unit ];
            else
                result = [NSString stringWithFormat:@"%i %@ diastolic pressure", (int)value, headerView.conf.unit2 ];
        }
        else {
            result = [NSString stringWithFormat:@"%i %@", (int)value, headerView.conf.unit ];
        }
    }
    else {
        result = [NSString stringWithFormat:@"%i %@", (int)value, headerView.conf.unit ];
    }
    
    return result;
}



/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (maskView.hidden==NO) {
        [self dismissKeyboard];
        [super touchesBegan:touches withEvent:event];
        
    }
}
 */



- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    if ([headerView isKindOfClass:[FTDoubleHeaderView class]]) {
        FTDoubleHeaderView* doubleHeaderView = (FTDoubleHeaderView*)headerView;
        if (direction==BSKeyboardControlsDirectionNext) {
            [doubleHeaderView switchWithActiveValue:1];
            [headerView editMode:TRUE withValueIndex:1];
        }
        else
            if (direction==BSKeyboardControlsDirectionPrevious) {
                [doubleHeaderView switchWithActiveValue:0];
                [headerView editMode:TRUE withValueIndex:0];
            
            }
    }
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self dismissKeyboard];
}

-(void)dismissKeyboard {
    maskView.hidden = YES;
    [self endEditing:YES];
    [headerView editMode:TRUE withValueIndex:0];
    [headerView editMode:TRUE withValueIndex:1];
}


-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    //[optionView close];

}




@end
