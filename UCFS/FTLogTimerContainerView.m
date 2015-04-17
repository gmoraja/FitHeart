//
//  FTLogTimerContainerView.m
//  FitHeart
//
//  Created by Bitgears on 17/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTLogTimerContainerView.h"
#import "FTTimerHeaderView.h"
#import "BSKeyboardControls.h"
#import "FitnessSection.h"
#import "FTCircularEntriesGraph.h"

static float timerSliderHeight = 290;
static float graphRadius = 186;


@interface FTLogTimerContainerView() {
    
    NSTimer* timer;
    NSTimeInterval timerStartInterval;
    NSTimeInterval timerPausedInterval;
    UIButton *timerPlayButton;
    UIButton *timerPauseButton;
    int automaticButtonState;  //0=start, 1=play, 2=pause

    FTCircularEntriesGraph*  circularGraph;
    
    
    UIImage *timerPlayButtonImage;
    UIImage *timerPauseButtonImage;
}

@end



@implementation FTLogTimerContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}


- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData {
    self = [super initWithFrame:frame withSection:section withGoalData:goalData withLogData:logData ];
    if (self) {
        useTimer = YES;
        keypadButton.hidden = YES;
        timerPlayButtonImage = [UIImage imageNamed:@"play_btn"];
        timerPauseButtonImage = [UIImage imageNamed:@"pause_btn"];
        
        [self createTimerPlayButton];
        [self createTimerPauseButton];
    }
    return self;
}

- (void)initHeader {
    conf = [FitnessSection headerConfForLogTimer];
    
    CGRect headerRect = CGRectMake(0, 0, 320, conf.headerHeight);
    headerView = [[FTTimerHeaderView alloc] initWithFrame:headerRect withConf:conf ];
    FTTimerHeaderView *timerHeaderView = (FTTimerHeaderView*)headerView;
    timerHeaderView.valueSecondsLabel.textColor = [currentSection mainColor:-1];
    [timerHeaderView editMode:FALSE withValueIndex:0];
    [timerHeaderView editMode:FALSE withValueIndex:1];
    //timerHeaderView.valueHourText.delegate = self;
    //timerHeaderView.valueMinuteText.delegate = self;
    //timerHeaderView.v

    //NSArray *fields = @[ timerHeaderView.valueHourText, timerHeaderView.valueMinuteText];
    
    /*
    keyboardControls = [[BSKeyboardControls alloc] initWithFields:fields];
    if ([UCFSUtil deviceSystemIOS7]) {
        keyboardControls.doneTintColor = [UIColor whiteColor];
        keyboardControls.tintColor = [UIColor whiteColor];
    }
    keyboardControls.delegate = self;
    */
    
}






-(void)initMainContainer {
    
    mainContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, timerSliderHeight)];
    
    float offset_y = 14;
  
    float h = graphRadius;
    float w = graphRadius;
    
    CGRect circularEntriesGraphFrame = CGRectMake((mainContainerView.frame.size.width-w)/2, (mainContainerView.frame.size.height-h)/2+offset_y, w, h);
    circularGraph = [[FTCircularEntriesGraph alloc] initWithFrame:circularEntriesGraphFrame
                                                       withRadius:65
                                                         withSize:12
                     ];
    circularGraph.wheelForegroundColor = [UIColor colorWithRed:245.0/255.0 green:166.0/255.0 blue:35.0/255.0 alpha:1.0];
    circularGraph.wheelBackgroundColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0];
    [circularGraph resetWithProgress:0 withValue:0 withUnit:@""];
    
    
    NSString* endStr = [UCFSUtil stringWithValueAsTime:110];
    [circularGraph resetWithProgress:0 withValue:0 withUnit:@""];
    [circularGraph setIsAccessibilityElement:NO];
    
    [mainContainerView addSubview:circularGraph];
    
 
}


- (void)createTimerPlayButton{
    
    float offset_y = 14;
    
    CGRect rect = CGRectMake((mainContainerView.frame.size.width-timerPlayButtonImage.size.width)/2, (mainContainerView.frame.size.height-timerPlayButtonImage.size.height)/2+offset_y, timerPlayButtonImage.size.width, timerPlayButtonImage.size.height);
    
    timerPlayButton = [[UIButton alloc] initWithFrame:rect];
    [timerPlayButton setBackgroundImage:timerPlayButtonImage forState:UIControlStateNormal];
    [timerPlayButton addTarget:self action:@selector(playTimer:) forControlEvents:UIControlEventTouchUpInside];
    timerPlayButton.hidden = NO;
    [timerPlayButton setAccessibilityLabel:@"Play"];
    [timerPlayButton setAccessibilityHint:@"Tap to start timer"];
    
    [mainContainerView addSubview:timerPlayButton];
    
}

- (void)createTimerPauseButton{
  
    float offset_y = 14;
    
    CGRect rect = CGRectMake((mainContainerView.frame.size.width-timerPauseButtonImage.size.width)/2, (mainContainerView.frame.size.height-timerPauseButtonImage.size.height)/2+offset_y, timerPauseButtonImage.size.width, timerPauseButtonImage.size.height);

    timerPauseButton = [[UIButton alloc] initWithFrame:rect];
    [timerPauseButton setBackgroundImage:timerPauseButtonImage forState:UIControlStateNormal];
    [timerPauseButton addTarget:self action:@selector(pauseTimer:) forControlEvents:UIControlEventTouchUpInside];
    timerPauseButton.hidden = YES;
    [timerPauseButton setAccessibilityLabel:@"Pause"];
    [timerPauseButton setAccessibilityHint:@"Tap to pause timer"];
    
    [mainContainerView addSubview:timerPauseButton ];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    FTTimerHeaderView *timerHeaderView = (FTTimerHeaderView*)headerView;
    switch (textField.tag) {
        case 1: //minutes
            //[timerSlider setCurrentMinutes:[textField.text intValue] ];
            timerHeaderView.valueMinuteLabel.text = textField.text;
            break;
        case 2: //seconds
            //[timerSlider setCurrentHour:[textField.text intValue] ];
            timerHeaderView.valueSecondsLabel.text = textField.text;
            break;
                    
    }
    [headerView editMode:FALSE withValueIndex:0];
    [headerView editMode:FALSE withValueIndex:1];
    
    if (self.delegate!=nil)
        [self.delegate finishEditingValue];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *valueString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    float value = 0;
    if ([valueString length]>0) {
        switch (textField.tag) {
            case 1: //minutes
                value = [valueString intValue];
                if (value>59)
                        return NO;
                break;
                
            case 2: //hour
                if ([valueString length]>1)
                     return NO;
                value = [valueString intValue];
                if (value>9)
                    return NO;
                break;
                        
        }
    }
    
    return YES;
}






- (void)updateWithGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData {
    currentLogData = logData;

    int hours = trunc(logData.logValue / 60);
    int minutes = ((logData.logValue / 60) - hours) * 60;
    
    FTTimerHeaderView *timerHeaderView = ((FTTimerHeaderView*)headerView);
    [timerHeaderView updateUIWithHours:hours withMinutes:minutes withSeconds:0];
    
}

- (FTLogData*)getLogData {
    if (currentLogData==nil)
        currentLogData = [[FTLogData alloc] init];
    
    FTTimerHeaderView *timerHeaderView = ((FTTimerHeaderView*)headerView);
    NSString* minutesStr = timerHeaderView.valueMinuteLabel.text;
    NSString* secondsStr = timerHeaderView.valueSecondsLabel.text;
    
    int minutes = [minutesStr intValue];
    int seconds = [secondsStr intValue];
    currentLogData.logValue = minutes;
    
    currentLogData.insertDate = [dateSelect getDate];
    currentLogData.activity = [activitySelect getActivity];
    currentLogData.effort = [effortSelect getEffort];
    
    return currentLogData;
}



//TIMER FUNCTIONS

- (IBAction)switchTimerType:(id)sender {

        //SWITCH TO MANUAL
        if (timer!=nil && [timer isValid]) {
            UIAlertView *switchToManual=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Switching to the manual entry will reset the timer. Do you want to leave this screen?" delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES",nil];
            switchToManual.delegate = self;
            [switchToManual show];
        }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}



- (IBAction)timerAutomaticButtonAction:(id)sender {
    switch (automaticButtonState) {
        case 0: //ready to start
            [self startTimer:sender];
            break;
        case 1: //playing
            [self pauseTimer:sender];
            break;
        case 2: //paused
            [self playTimer:sender];
            break;
        default:
            break;
    }
}




- (void)timerFireMethod:(NSTimer *)timer {
    NSTimeInterval timerCurrentInterval = [[NSDate date] timeIntervalSince1970];
    double diff = timerCurrentInterval - timerStartInterval;
    int hours = floor(diff/3600);
    int minutes = floor(diff / 60);
    int seconds = round(diff - minutes * 60);
    if (seconds==60) {
        seconds=0;
        minutes++;
    }
    if (minutes>=60) {
        minutes = (minutes % 60);
    }

    
    if (hours>=5)
        [self stopTimer:self];
    else {
        FTTimerHeaderView *timerHeaderView = ((FTTimerHeaderView*)headerView);
        [timerHeaderView updateUIWithHours:hours withMinutes:minutes withSeconds:seconds];
    }

}

- (IBAction)startTimer:(id)sender {
    FTTimerHeaderView *timerHeaderView = ((FTTimerHeaderView*)headerView);
    [timerHeaderView updateUIWithHours:0 withMinutes:0 withSeconds:0];
    
    automaticButtonState = 1; //playing
    timerStartInterval = [[NSDate date] timeIntervalSince1970];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    timerPauseButton.hidden = NO;
    timerPlayButton.hidden = YES;
    
}

- (IBAction)stopTimer:(id)sender {
    if (timer!=nil && [timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
    timerPauseButton.hidden = YES;
    timerPlayButton.hidden = NO;
    automaticButtonState = 0;

}

- (IBAction)pauseTimer:(id)sender {
    if ([timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
    timerPausedInterval = [[NSDate date] timeIntervalSince1970]-timerStartInterval;
    automaticButtonState = 2; //paused
    timerPauseButton.hidden = YES;
    timerPlayButton.hidden = NO;
}

- (IBAction)playTimer:(id)sender {
    automaticButtonState = 1; //playing
    timerStartInterval = [[NSDate date] timeIntervalSince1970]-timerPausedInterval;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    timerPauseButton.hidden = NO;
    timerPlayButton.hidden = YES;
}

//override
-(BOOL)isSliding {
    return false;
}




@end
