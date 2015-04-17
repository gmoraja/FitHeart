//
//  HealthSelectorItemView.m
//  FitHeart
//
//  Created by Bitgears on 09/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "HealthSelectorItemView.h"
#import "UCFSUtil.h"

@interface HealthSelectorItemView(){
    UILabel* titleLabel;
    UILabel* valueLabel;
    UILabel* dateLabel;
    UILabel* unitLabel;
}

@end

@implementation HealthSelectorItemView

- (id)initWithFrame:(CGRect)frame withDataType:(int)goalType
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        dataType = goalType;
        
        [self setIsAccessibilityElement:YES];

        UIImage* iconImage = nil;
        NSString* textLabel = nil;
        NSString* unit = nil;
        switch (dataType) {
            case HEALTH_GOAL_WEIGHT:
                iconImage = [UIImage imageNamed:@"health_weight_icon"];
                textLabel = @"Weight";
                unit = @"lbs";
                break;
            case HEALTH_GOAL_HEARTRATE:
                iconImage = [UIImage imageNamed:@"health_heart_rate_icon"];
                textLabel = @"Heart Rate";
                unit = @"bpm";
                break;
            case HEALTH_GOAL_PRESSURE:
                iconImage = [UIImage imageNamed:@"health_blood_icon"];
                textLabel = @"Blood Pressure";
                unit = @"mmHg";
                break;
            case HEALTH_GOAL_GLUCOSE:
                iconImage = [UIImage imageNamed:@"health_glucose_icon"];
                textLabel = @"Glucose";
                unit = @"mg/dL";
                break;
            case HEALTH_GOAL_CHOLESTEROL_LDL:
                iconImage = [UIImage imageNamed:@"health_cholesterol_icon"];
                textLabel = @"LDL Cholesterol";
                unit = @"mg/dL";
                break;
                
        }
        
        
        
        UIImageView* iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, (frame.size.height-iconImage.size.height)/2, iconImage.size.width, iconImage.size.height)];
        [iconImageView setImage:iconImage];
        iconImageView.userInteractionEnabled = NO;
        
        
        float labelY = 28;
        if ([UCFSUtil deviceIs3inch])
            labelY = 19;
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, labelY, 140, 26)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:(18.0)];
        titleLabel.textAlignment =  NSTextAlignmentLeft;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 1;
        titleLabel.text = textLabel;

        
        labelY = 28;
        if ([UCFSUtil deviceIs3inch])
            labelY = 19;
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(204, labelY, 96, 30)];
        valueLabel.textColor = [HealthSection mainColor:0];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.font = [UIFont fontWithName:@"SourceSansPro-SemiBold" size:(28.0)];
        valueLabel.textAlignment =  NSTextAlignmentRight;
        valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
        valueLabel.numberOfLines = 1;
        [valueLabel setIsAccessibilityElement:NO];
        valueLabel.userInteractionEnabled = NO;

        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, titleLabel.frame.origin.y+titleLabel.frame.size.height, 140, 20)];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:(14.0)];
        dateLabel.textAlignment =  NSTextAlignmentLeft;
        dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
        dateLabel.numberOfLines = 1;
        [dateLabel setIsAccessibilityElement:NO];
        dateLabel.userInteractionEnabled = NO;

        
        unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(204, valueLabel.frame.origin.y+valueLabel.frame.size.height, 96, 20)];
        unitLabel.textColor = [UIColor blackColor];
        unitLabel.backgroundColor = [UIColor clearColor];
        unitLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:(16.0)];
        unitLabel.textAlignment =  NSTextAlignmentRight;
        unitLabel.lineBreakMode = NSLineBreakByWordWrapping;
        unitLabel.numberOfLines = 1;
        unitLabel.text = unit;
        [unitLabel setIsAccessibilityElement:NO];
        unitLabel.userInteractionEnabled = NO;
        
        UIView* contentViewBorder = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1.5, 320, 1.5)];
        contentViewBorder.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0];
        
        [self addSubview:iconImageView];
        [self addSubview:titleLabel];
        [self addSubview:valueLabel];
        [self addSubview:dateLabel];
        [self addSubview:unitLabel];
        if (dataType!=HEALTH_GOAL_CHOLESTEROL_LDL)
            [self addSubview:contentViewBorder];
        
        
    }
    return self;
}


- (void)updateWithLog:(FTLogData*)logData {
    currentLogData = logData;
    
        if (logData==nil) {
            if (dataType==HEALTH_GOAL_PRESSURE) {
                valueLabel.text = @"--/--";
            }
            else {
                valueLabel.text = @"--";
            }
            dateLabel.text = @"Never entered";
            [self setAccessibilityLabel:[NSString stringWithFormat:@"%@ button", titleLabel.text] ];
            [self setAccessibilityValue:@"value never entered" ];
        }
        else {
            if (dataType==HEALTH_GOAL_PRESSURE) {
                valueLabel.text = [NSString stringWithFormat:@"%i/%i", (int)(logData.logValue), (int)(logData.logValue2) ];
            }
            else {
                valueLabel.text = [NSString stringWithFormat:@"%i", (int)(logData.logValue) ];
            }
            dateLabel.text = [UCFSUtil formatDate:logData.insertDate withFormat:@"EEE, MMM dd"];
            [self setAccessibilityLabel:[NSString stringWithFormat:@"%@ button", titleLabel.text] ];
            [self setAccessibilityValue:[NSString stringWithFormat:@"last value %@ %@ on %@", valueLabel.text, unitLabel.text, dateLabel.text ]];
        }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
