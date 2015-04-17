//
//  FTGoalContainerView.m
//  FitHeart
//
//  Created by Bitgears on 12/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTGoalContainerView.h"
#import "FTSection.h"
#import "FTHeaderView.h"
#import "FTSingleHeaderView.h"
#import "FTDoubleHeaderView.h"


static float sliderSize = 290;
static float sliderHeight = 290;

@interface FTGoalContainerView() {

    
}

@end


@implementation FTGoalContainerView

@synthesize headerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isEditingMaxValue = NO;

        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withGoalData:(FTGoalData*)goalData {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentGoalData = goalData;
        isEditingMaxValue = NO;
        currentSection = section;
        conf = [currentSection headerConfWithGoalType:currentGoalData.dataType.goaltypeId];
        [self initHeader];
        [self initBody];
        
        [self addSubview:bodyContainerView];
        [self addSubview:headerView];

        
        //self.userInteractionEnabled = YES;
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
            [headerView.valueText addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            break;
        case 2:
            headerView = [[FTDoubleHeaderView alloc] initWithFrame:headerRect withConf:conf ];
            FTDoubleHeaderView* doubleHeaderView = (FTDoubleHeaderView*)headerView;
            NSArray *fields = @[ doubleHeaderView.valueText, doubleHeaderView.value2Text];
            doubleHeaderView.value2Text.delegate = self;
            keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
            if ([UCFSUtil deviceSystemIOS7]) {
                keyboardControls.doneTintColor = [UIColor whiteColor];
                keyboardControls.tintColor = [UIColor whiteColor];
            }
            keyboardControls.delegate = self;
            [doubleHeaderView editMode:TRUE withValueIndex:1];

            break;
    }
    //[headerView.valueText setReturnKeyType:UIReturnKeyDone];
    headerView.valueText.delegate = self;
    [headerView editMode:TRUE withValueIndex:0];


}

- (void)initBody {
    
    bodyContainerHeight = [UCFSUtil contentAreaHeight]-conf.headerHeight;
    CGRect bodyContainerRect = CGRectMake(0, conf.headerHeight, 320, bodyContainerHeight);
    bodyContainerView = [[UIView alloc] initWithFrame:bodyContainerRect];
    
    [self initMainContainer];
    [self initOptions];

    //body height depends on options position
    /*
    if (optionView!=nil)
        bodyContainerHeight = optionView.frame.origin.y+optionView.frame.size.height;
    else
        bodyContainerHeight = 0;
    CGRect bodyContainerRect = CGRectMake(0, conf.headerHeight, 320, bodyContainerHeight);
    bodyContainerView = [[UIView alloc] initWithFrame:bodyContainerRect];
     */
    
    //mask view
    CGRect maskViewframe = CGRectMake(0, 0, 320, bodyContainerHeight);
    maskView = [[UIView alloc] initWithFrame:maskViewframe];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.8;
    maskView.hidden = YES;
    
    
    [bodyContainerView addSubview:mainContainerView];
    [bodyContainerView addSubview:maskView];
    [bodyContainerView addSubview:optionView];
    
    optionView.slidableView = mainContainerView;
}

-(void)initMainContainer {
    float totalHeight = 0;
    float y = 40;
    if ([UCFSUtil deviceIs3inch])
        y = 0;
    CGRect sliderRect = CGRectMake((320-sliderSize) / 2, y, sliderSize, sliderSize);

    /*
    float totalHeight = 0;
    CGRect sliderRect = CGRectMake(0, 0, sliderSize, sliderSize);
     */
    slider = [UCFSUtil createCircularSliderWithFrame:sliderRect
                                         withSection:currentSection
                                          withTarget:self
                                              action:@selector(newSliderValue:)
                                            asDouble:false
              ];

    slider.increment = [currentSection sliderIncrementByGoal:[currentSection getCurrentGoal]  ];
    slider.stepValue = conf.wheelStepValue;
    [slider setIsAccessibilityElement:NO];
     totalHeight += sliderSize;
    
    
    //create the keypad button
    UIImage *keypadImage = [UIImage imageNamed:@"circle_keypad"];
    float x_center = (self.frame.size.width - keypadImage.size.width) / 2;
    float y_center = sliderRect.origin.y+(sliderRect.size.height-keypadImage.size.height)/2;
    keypadButton = [[UIButton alloc] initWithFrame:CGRectMake(x_center,y_center, keypadImage.size.width, keypadImage.size.height)];
    [keypadButton setBackgroundImage:keypadImage forState:UIControlStateNormal];
    [keypadButton addTarget:self action:@selector(keypadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //create the info button
    UIImage *infoImage = [UIImage imageNamed:@"info_icon"];
    x_center = sliderRect.origin.y+(sliderRect.size.height-infoImage.size.height)/2;
    infoButton = [[UIButton alloc] initWithFrame:CGRectMake(x_center,y_center+108, infoImage.size.width, infoImage.size.height)];
    [infoButton setBackgroundImage:infoImage forState:UIControlStateNormal];
    [infoButton addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    mainContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, totalHeight)];
    [mainContainerView addSubview:slider];
    //[mainContainerView addSubview:keypadButton];
    //[mainContainerView addSubview:infoButton];
    
}

-(void)initOptions {
    NSMutableArray *allviews = [[NSMutableArray alloc] init];
    
    
    //reminder
    CGRect reminderRect = CGRectMake(0, 0, 320, 50);
    if (goalAchivedBySelect!=nil)
        reminderRect = CGRectMake(0, goalAchivedBySelect.frame.origin.y+goalAchivedBySelect.frame.size.height, 320, 50);
    reminderSelect = [[FTReminderSelectView alloc] initWithFrame:reminderRect
                                                     withSection:currentSection
                                                        withFont:@"SourceSansPro-Regular"
                                                    withFontSize:18.0
                      ];
    
    //[allviews addObject:reminderSelect];
   
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
/*
    float pos = 300;
    if ([UCFSUtil deviceIs3inch]==FALSE) pos = 390;
*/
    optionView = [[FTOptionGroupView alloc] initWithFrame:CGRectMake(0, pos, 320, viewsSpace)
                                                withViews:allviews
                  ];

    if (goalAchivedBySelect!=nil) goalAchivedBySelect.delegate = optionView;
    if (reminderSelect!=nil) reminderSelect.delegate = optionView;
    
    
}

- (void)initPanrecognizer {
    
    if ([UCFSUtil deviceIs3inch]) {
        
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        swipeUp.cancelsTouchesInView = NO;
        [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
        [bodyContainerView addGestureRecognizer:swipeUp];
        
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        swipeDown.cancelsTouchesInView = NO;
        [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
        [bodyContainerView addGestureRecognizer:swipeDown];
        minY = bodyContainerView.frame.origin.y;
        maxY = bodyContainerView.frame.origin.y;
        topRect = CGRectMake(bodyContainerView.frame.origin.x, minY, bodyContainerView.frame.size.width, bodyContainerView.frame.size.height);
        bottomRect = CGRectMake(bodyContainerView.frame.origin.x, maxY, bodyContainerView.frame.size.width, bodyContainerView.frame.size.height);

    }
    
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    if([recognizer direction] == UISwipeGestureRecognizerDirectionDown) {

    }
    
}

-(BOOL)isSliding {
    if (slider!=nil)
        return [slider isSliding];
    
    return false;
}


-(void)newSliderValue:(TBCircularSlider*)sender {
    float current = [sender getCurrentValueWithIncrement:YES];
    headerView.valueText.text = [UCFSUtil stringWithValue:current
                                            formatAsFloat:headerView.conf.valueIsFloat
                                          formatAsCompact:NO
                                 ];
    
    headerView.valueLabel.text = [UCFSUtil stringWithValue:current
                                             formatAsFloat:headerView.conf.valueIsFloat
                                           formatAsCompact:headerView.conf.compactValue
                                  ];
    

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

-(void)updateWithGoalData:(FTGoalData*)goalData {
    currentGoalData = goalData;
    conf = [currentSection headerConfWithGoalType:currentGoalData.dataType.goaltypeId];
    [headerView updateConf:conf];

    float goalDataValue = goalData.goalValue;
    if (goalDataValue>conf.maxValueLimit)
        goalDataValue = conf.minValueLimit;
    /*
    if (headerView.conf.dateType==0)
        goalDataValue = goalDataValue / 7;
     */
    
    [slider setupUnitWithStart:conf.minValueLimit
                       withEnd:conf.maxValueLimit
                   withDefault:goalDataValue
                      withStep:conf.wheelStepValue
                withCenterText:conf.rightText
     
     ];
    slider.increment = [currentSection sliderIncrementByGoal:[currentSection getCurrentGoal]  ];
    
    headerView.valueText.text = [UCFSUtil stringWithValue:goalDataValue
                                            formatAsFloat:headerView.conf.valueIsFloat
                                          formatAsCompact:NO
                                 ];
    [headerView.valueText setAccessibilityValue:[NSString stringWithFormat:@"%i %@", (int)goalDataValue, headerView.conf.unit ]];

    headerView.valueLabel.text = [UCFSUtil stringWithValue:goalDataValue
                                             formatAsFloat:headerView.conf.valueIsFloat
                                           formatAsCompact:headerView.conf.compactValue
                                  ];
    [headerView.valueLabel setAccessibilityValue:[NSString stringWithFormat:@"%i %@", (int)goalDataValue, headerView.conf.unit ]];
    


    [slider setNeedsDisplay];
    
    FTReminderData* reminder = [currentSection loadReminderWithGoal:currentGoalData.dataType.goaltypeId];
    [reminderSelect updateReminder:reminder];
    
}

- (FTGoalData*)getGoalData {
    float value1 = [headerView.valueText.text floatValue];
    
    if (headerView.conf.valueIsFloat==NO) {
        value1 = round(value1);
    }
    
    //normalize to datetype week
    /*
    if (headerView.conf.dateType==0) {
        value1 = value1 * 7;
        value2 = value2 * 7;
    }
     */
    
    currentGoalData.goalValue = value1;
    
    return currentGoalData;
}



-(BOOL)maxValueIsValid:(NSString*)valueString {
    if ([valueString length]>0) {
        float value = [valueString floatValue];
        if (value>=headerView.conf.minValueLimit && value<=headerView.conf.maxValueLimit )
            return YES;
        else
            return NO;
    }
    
    return YES;
}

-(BOOL)valueIsValid:(NSString*)valueString {
    if ([valueString length]>0) {
        float value = [valueString floatValue];
        if (value>=0)
            return YES;
        else
            return NO;
    }
    
    return YES;
}


-(void)processNewMaxValue:(float)value {
    //CHECK LIMITS
    if (value>0) {
        
    }
    else
        value = 1;
    
    //NORMALIZE
    float maxValue = round(value);
    float current = [slider getCurrentValueWithIncrement:FALSE];
    if (current>maxValue) current = maxValue;
    
    //SAVE
    [currentSection saveGoalData:currentGoalData];
    
    //UPDATE UI
    [slider setupUnitWithStart:0 withEnd:maxValue withDefault:current withStep:conf.wheelStepValue withCenterText:conf.rightText];
    isEditingMaxValue = NO;
    headerView.valueLabel.text = [UCFSUtil stringWithValue:current
                                            formatAsFloat:headerView.conf.valueIsFloat
                                          formatAsCompact:headerView.conf.compactValue
                                 ];
    [headerView.valueText setAccessibilityValue:[NSString stringWithFormat:@"%i %@", (int)current, headerView.conf.unit ]];

    headerView.valueText.text = [UCFSUtil stringWithValue:current
                                             formatAsFloat:headerView.conf.valueIsFloat
                                           formatAsCompact:headerView.conf.compactValue
                                  ];
    [headerView.valueText setAccessibilityValue:[NSString stringWithFormat:@"%i %@", (int)current, headerView.conf.unit ]];
    
    [slider setNeedsDisplay];
    
    
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
    if (isEditingMaxValue) {
        NSString *text = headerView.valueText.text;
        [self processNewMaxValue:[text floatValue]];
        
    }
    else {
        NSString *text = headerView.valueText.text;
        [slider setCurrentValue: [text floatValue] ];
        headerView.valueLabel.text = [UCFSUtil stringWithValue:[text floatValue]
                                                 formatAsFloat:headerView.conf.valueIsFloat
                                               formatAsCompact:headerView.conf.compactValue
                                      ];
        [headerView.valueLabel setAccessibilityValue:[NSString stringWithFormat:@"%i %@", [text intValue], headerView.conf.unit ]];
        [headerView.valueText setAccessibilityValue:[NSString stringWithFormat:@"%i %@", [text intValue], headerView.conf.unit ]];

    }
    
    //[headerView editMode:FALSE];
    [slider setNeedsDisplay];

    [headerView showPencil:TRUE withValueIndex:0];
    [headerView showPencil:TRUE withValueIndex:1];

    if (self.delegate!=nil)
        [self.delegate finishEditingValue];
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *valueString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (isEditingMaxValue) {
        return [self maxValueIsValid:valueString];
    }
    else {
        return [self valueIsValid:valueString];
    }
    
    return NO;
}


-(void)textChanged:(UITextField *)textField
{
    //accessibility
    NSString* hint = [NSString stringWithFormat:@"new value %i %@", [textField.text intValue], headerView.conf.unit ];
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, hint);
        });
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self dismissKeyboard];
    [super touchesBegan:touches withEvent:event];
}


- (void)keyboardControls:(BSKeyboardControls *)keyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
    [headerView editMode:TRUE withValueIndex:0];
}

-(void)dismissKeyboard {
    maskView.hidden = YES;
    [self endEditing:YES];
    //[headerView editMode:FALSE];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)keyboardControls
{
    [self dismissKeyboard];
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    [optionView close];
    
}





@end
