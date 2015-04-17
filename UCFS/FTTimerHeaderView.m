//
//  FTTimerHeaderView.m
//  FitHeart
//
//  Created by Bitgears on 13/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTTimerHeaderView.h"

@implementation FTTimerHeaderView

@synthesize valueMinuteLabel;
@synthesize valueMinuteText;
@synthesize minuteLabel;
@synthesize valueSecondsLabel;
@synthesize valueSecondsText;
@synthesize secondsLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initValueMinuteText];
        [self initMinuteLabel];
        [self initValueSecondsText];
        [self initSecondsLabel];
        
        [self editMode:NO withValueIndex:0];
        [self editMode:NO withValueIndex:1];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withConf:(FTHeaderConf*)headerConf {
    arrowType = 1;
    self = [super initWithFrame:frame withConf:headerConf];
    if (self) {
        // Initialization code
        valueTextHeight = 50;
        valueTextWidth = 80;
        
        CGRect rect = CGRectMake(0, 0, frame.size.width, frame.size.height);
        containerView = [[UIView alloc] initWithFrame:rect];
        containerView.backgroundColor = [UIColor clearColor];
        
        
        [self initValueMinuteText];
        [self initMinuteLabel];
        [self initValueSecondsText];
        [self initSecondsLabel];
        
        [containerView addSubview:valueMinuteLabel];
        [containerView addSubview:valueMinuteText];
        [containerView addSubview:minuteLabel];
        [containerView addSubview:valueSecondsLabel];
        [containerView addSubview:valueSecondsText];
        [containerView addSubview:secondsLabel];
        
        [self addSubview:containerView];
        
        [self updateUIWithHours:0 withMinutes:0 withSeconds:0];
        
        [self editMode:NO withValueIndex:0];
        [self editMode:NO withValueIndex:1];
    }
    return self;
}



- (void)initValueMinuteText {
    
    //float offset_x = hourLabel.frame.origin.x+hourLabel.frame.size.width;
    float offset_x = 80;
    float offset_y = 10;
    CGRect valueTextFrame = CGRectMake(offset_x, offset_y, valueTextWidth, valueTextHeight);
    
    valueMinuteLabel = [[UILabel alloc] initWithFrame:valueTextFrame];
    valueMinuteLabel.textColor = conf.value2TextColor;
    valueMinuteLabel.backgroundColor = [UIColor clearColor];
    valueMinuteLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:(60.0)];
    valueMinuteLabel.textAlignment =  ALIGN_CENTER;
    valueMinuteLabel.numberOfLines = 1;
    valueMinuteLabel.text = @"00";
    
    valueMinuteText = [[UITextField alloc] initWithFrame:valueTextFrame];
    valueMinuteText.borderStyle = UITextBorderStyleNone;
    valueMinuteText.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:(60.0)];
    valueMinuteText.textColor = conf.value2TextColor;
    valueMinuteText.autocorrectionType = UITextAutocorrectionTypeNo;
    valueMinuteText.keyboardType = UIKeyboardTypeNumberPad;
    valueMinuteText.returnKeyType = UIReturnKeyDone;
    valueMinuteText.clearButtonMode = UITextFieldViewModeNever;
    valueMinuteText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    valueMinuteText.textAlignment = ALIGN_CENTER;
    valueMinuteText.text = @"00";
    valueMinuteText.tag = 1;
}

- (void)initMinuteLabel {
    
    float offset_x = valueMinuteLabel.frame.origin.x;
    float offset_y = valueMinuteLabel.frame.origin.y+valueMinuteLabel.frame.size.height;
    CGRect labelFrame = CGRectMake(offset_x, offset_y, valueTextWidth, 20);
    minuteLabel = [[UILabel alloc] initWithFrame:labelFrame];
    minuteLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1];
    minuteLabel.backgroundColor = [UIColor clearColor];
    minuteLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(16.0)];
    minuteLabel.textAlignment =  ALIGN_CENTER;
    minuteLabel.numberOfLines = 1;
    minuteLabel.text = @"mins";
    [minuteLabel setIsAccessibilityElement:NO];
    minuteLabel.userInteractionEnabled=NO;
    
}





- (void)initValueSecondsText {
    
    float offset_x = minuteLabel.frame.origin.x + minuteLabel.frame.size.width;
    float offset_y = 10;
    CGRect labelFrame = CGRectMake(offset_x, offset_y, valueTextWidth, valueTextHeight);
    valueSecondsLabel = [[UILabel alloc] initWithFrame:labelFrame];
    valueSecondsLabel.textColor = [UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1.0];
    valueSecondsLabel.backgroundColor = [UIColor clearColor];
    valueSecondsLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:(60.0)];
    valueSecondsLabel.textAlignment =  ALIGN_CENTER;
    valueSecondsLabel.numberOfLines = 1;
    valueSecondsLabel.text = @"00";
    
    valueSecondsText = [[UITextField alloc] initWithFrame:labelFrame];
    valueSecondsText.borderStyle = UITextBorderStyleNone;
    valueSecondsText.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:(60.0)];
    valueSecondsText.textColor = conf.valueTextColor;
    valueSecondsText.autocorrectionType = UITextAutocorrectionTypeNo;
    valueSecondsText.keyboardType = UIKeyboardTypeNumberPad;
    valueSecondsText.returnKeyType = UIReturnKeyDone;
    valueSecondsText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    valueSecondsText.textAlignment = ALIGN_CENTER;
    valueSecondsText.text = @"0";
    valueSecondsText.tag = 2;
}



- (void)initSecondsLabel {
    float offset_x = valueSecondsLabel.frame.origin.x;
    float offset_y = valueSecondsLabel.frame.origin.y+valueSecondsLabel.frame.size.height;
    CGRect labelFrame = CGRectMake(offset_x, offset_y, valueTextWidth, 20);
    secondsLabel = [[UILabel alloc] initWithFrame:labelFrame];
    secondsLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1];
    secondsLabel.backgroundColor = [UIColor clearColor];
    secondsLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(16.0)];
    secondsLabel.textAlignment =  ALIGN_CENTER;
    secondsLabel.numberOfLines = 1;
    secondsLabel.text = @"secs";
    [secondsLabel setIsAccessibilityElement:NO];
    secondsLabel.userInteractionEnabled=NO;

}



-(void)updateHeaderWithTime:(int)time {
    int minutes = trunc(time / 60);
    int seconds = time - (minutes*60);
    if (minutes<10)
        valueMinuteLabel.text = [NSString stringWithFormat:@" %i", minutes];
    else
        valueMinuteLabel.text = [NSString stringWithFormat:@" %i", minutes];
    [valueMinuteLabel setAccessibilityLabel:[NSString stringWithFormat:@" %i minutes", minutes]];
    
    if (seconds<10)
        valueSecondsLabel.text = [NSString stringWithFormat:@"0%i", seconds];
    else
        valueSecondsLabel.text = [NSString stringWithFormat:@"%i", seconds];
    [valueSecondsLabel setAccessibilityLabel:[NSString stringWithFormat:@" %i seconds", seconds]];
}

- (void)updateUIWithHours:(int)hours withMinutes:(int)minutes withSeconds:(int)seconds {
    //update header
    if (minutes<10) {
        valueMinuteText.text = [NSString stringWithFormat:@"0%d", minutes];
        valueMinuteLabel.text = [NSString stringWithFormat:@"0%d", minutes];
    }
    else {
        valueMinuteText.text = [NSString stringWithFormat:@"%d", minutes];
        valueMinuteLabel.text = [NSString stringWithFormat:@"%d", minutes];
    }
    [valueMinuteLabel setAccessibilityLabel:[NSString stringWithFormat:@"%i minutes", minutes]];
   
     if (seconds<10)
        valueSecondsLabel.text = [NSString stringWithFormat:@"0%d", seconds];
     else
        valueSecondsLabel.text = [NSString stringWithFormat:@"%d", seconds];
    [valueSecondsLabel setAccessibilityLabel:[NSString stringWithFormat:@"%i seconds", seconds]];
    
}




- (void)editText {
    [valueMinuteText becomeFirstResponder];
}

-(void)editMode:(BOOL)edit withValueIndex:(int)activeValue {
    [super editMode:edit withValueIndex:0];
    
    valueSecondsLabel.hidden = edit;
    valueSecondsText.hidden = !edit;
    valueMinuteLabel.hidden = edit;
    valueMinuteText.hidden = !edit;
}


@end
