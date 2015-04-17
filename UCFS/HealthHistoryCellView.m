//
//  HealthHistoryCellView.m
//  FitHeart
//
//  Created by Bitgears on 09/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

static float INFO_WIDTH = 78.0;
static float MAX_BAR_WIDTH = 242.0;


#import "HealthHistoryCellView.h"
#import "UCFSUtil.h"
#import "HealthSection.h"

@implementation HealthHistoryCellView

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withLogData:(FTLogData*)logData withMinValue:(int)minvalue withMaxValue:(int)maxvalue withGoalType:(int)goal {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        currentSection = section;
        minValue = minvalue;
        maxValue = maxvalue;
        goalType = goal;
        
        bkgImageView = [[UIImageView alloc] initWithFrame:frame];
        [bkgImageView setImage:[UIImage imageNamed:@"mood_history_cell_bkg"]];
        bkgImageView.tag = 1;
        
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, INFO_WIDTH, frame.size.height/2)];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment =  NSTextAlignmentCenter;
        dateLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
        
        valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2, INFO_WIDTH, frame.size.height/2)];
        valueLabel.textColor = [UIColor blackColor];
        valueLabel.backgroundColor = [UIColor clearColor];
        valueLabel.textAlignment =  NSTextAlignmentCenter;
        valueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
        [valueLabel setIsAccessibilityElement:NO];
        
        [self addSubview:bkgImageView];
        [self addSubview:dateLabel];
        [self addSubview:valueLabel];

        if (goalType==HEALTH_GOAL_PRESSURE) {
            bar2ImageView = [[UIImageView alloc] initWithFrame:CGRectMake(INFO_WIDTH, 11, 0, 20)];
            bar2ImageView.backgroundColor = [UIColor colorWithRed:197.0/255.0 green:139.0/255.0 blue:167.0/255.0 alpha:0.6];
            barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(INFO_WIDTH, 31, 0, 20)];
            barImageView.backgroundColor = [UIColor colorWithRed:166.0/255.0 green:96.0/255.0 blue:130.0/255.0 alpha:0.6];
            [self addSubview:barImageView];
            [self addSubview:bar2ImageView];
        }
        else {
            barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(INFO_WIDTH, 11, 0, 40)];
            barImageView.backgroundColor = [UIColor colorWithRed:166.0/255.0 green:96.0/255.0 blue:130.0/255.0 alpha:0.6];
            [self addSubview:barImageView];
        }
        
        [self setIsAccessibilityElement:YES];
        [self setAccessibilityLabel:@"log"];
        
        [self updateWithLogData:logData withMinValue:minvalue withMaxValue:maxvalue];
        
    }
    return self;
}

- (void)updateWithLogData:(FTLogData*)logData withMinValue:(int)minvalue withMaxValue:(int)maxvalue {
    currentLogData = logData;
    minValue = minvalue;
    maxValue = maxvalue;
    
    dateLabel.text = [UCFSUtil formatDate:logData.insertDate withFormat:@"MMM dd"];
    
    float barPerc = 100;
    float bar2Perc = 100;
    if (goalType==HEALTH_GOAL_PRESSURE) {
        if ( (maxvalue-minvalue)>0 ) {
            barPerc = ((float)(logData.logValue-minvalue) / (float)(maxvalue-minvalue)) * 100;
            bar2Perc = ((float)(logData.logValue2-minvalue) / (float)(maxvalue-minvalue)) * 100;
        }
        
        float bar2Width = MAX_BAR_WIDTH * ( (float)bar2Perc / (float)100);
        bar2ImageView.frame = CGRectMake(INFO_WIDTH, 11, bar2Width, 20);
        
        float barWidth = MAX_BAR_WIDTH * ( (float)barPerc / (float)100);
        barImageView.frame = CGRectMake(INFO_WIDTH, 31, barWidth, 20);
        [self setAccessibilityValue:[NSString stringWithFormat:@"systolic value %i diastolyc value %i date %@ ", (int)logData.logValue, (int)logData.logValue2, dateLabel.text ]];
        
        valueLabel.text = [NSString stringWithFormat:@"%i / %i ", (int)logData.logValue, (int)logData.logValue2 ];
    }
    else {
        
        if ( (maxvalue-minvalue)>0 )
            barPerc = ((float)(logData.logValue-minvalue) / (float)(maxvalue-minvalue)) * 100;
        
        float barWidth = MAX_BAR_WIDTH * ( (float)barPerc / (float)100);
        barImageView.frame = CGRectMake(INFO_WIDTH, 11, barWidth, 40);
        [self setAccessibilityValue:[NSString stringWithFormat:@"value %i date %@ ", (int)logData.logValue, dateLabel.text ]];
        
        valueLabel.text = [NSString stringWithFormat:@"%i", (int)logData.logValue ];

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
