//
//  FTGoalHistoryCellView.m
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTGoalHistoryCellView.h"
#import "UCFSUtil.h"

static float INFO_WIDTH = 78.0;
static float MAX_BAR_WIDTH = 242.0;

@implementation FTGoalHistoryCellView

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withData:(FTGoalGroupedData*)goalGroupedData withBarPerc:(int)barPerc {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        currentSection = section;
        currentGoalGroupedData = goalGroupedData;
        [self setIsAccessibilityElement:YES];
        [self setAccessibilityLabel:@"goal"];
        
        goalStatusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 7, 30, 30)];
        if (goalGroupedData.goalData.reached)
            [goalStatusImageView setImage:[UIImage imageNamed:@"goalreached_small"]];
        else
            [goalStatusImageView setImage:[UIImage imageNamed:@"goalnotreached_small"]];
        goalStatusImageView.tag = 1;
        
        
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 37, INFO_WIDTH, 23)];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.text = [UCFSUtil formatDate:goalGroupedData.goalData.startDate withFormat:@"MMM dd"];
        dateLabel.textAlignment =  NSTextAlignmentCenter;
        dateLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
        
        float barWidth = MAX_BAR_WIDTH * ( (float)barPerc / (float)100);
        goalBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(INFO_WIDTH, 11, barWidth, 40)];
        //goalBarImageView.backgroundColor = [currentSection mainColor:0];
        goalBarImageView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:136.0/255.0 alpha:0.6];
        
        [self addSubview:goalStatusImageView];
        [self addSubview:dateLabel];
        [self addSubview:goalBarImageView];
        
    }
    return self;
}

- (void)updateWithData:(FTGoalGroupedData*)goalGroupedData withBarPerc:(int)barPerc {
    currentGoalGroupedData = goalGroupedData;
    NSString* goalReachedStr = @"";
    if (goalGroupedData.goalData.reached) {
        [goalStatusImageView setImage:[UIImage imageNamed:@"goalreached_small"]];
        goalReachedStr = @"goal reached";
    }
    else {
        [goalStatusImageView setImage:[UIImage imageNamed:@"goalnotreached_small"]];
        goalReachedStr = @"goal not reached";
    }
    
    dateLabel.text = [UCFSUtil formatDate:goalGroupedData.goalData.startDate withFormat:@"MMM dd"];
    
    [self setAccessibilityValue:[NSString stringWithFormat:@"value %i date %@ %@", (int)goalGroupedData.totalValue, dateLabel.text, goalReachedStr ]];
    
    float barWidth = MAX_BAR_WIDTH * ( (float)barPerc / (float)100);
    goalBarImageView.frame = CGRectMake(INFO_WIDTH, 11, barWidth, 40);
    

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
