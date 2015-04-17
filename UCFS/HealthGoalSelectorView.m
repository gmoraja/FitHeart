//
//  HealthGoalSelectorView.m
//  FitHeart
//
//  Created by Bitgears on 02/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//



#import "HealthGoalSelectorView.h"
#import "HealthSection.h"
#import "UCFSUtil.h"
#import "HealthSelectorItemView.h"


@interface HealthGoalSelectorView() {
    HealthSelectorItemView* weightView;
    HealthSelectorItemView* heartrateView;
    HealthSelectorItemView* pressureView;
    HealthSelectorItemView* glucoseView;
    HealthSelectorItemView* cholesterolView;
}

@end

@implementation HealthGoalSelectorView

@synthesize delegate;
@synthesize selectedGoal;

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        for (int i=0; i<5; i++) {
            HealthSelectorItemView* itemView = [self createItem:i];
            [self addSubview:itemView];
        }
        
    }
    return self;
}

- (HealthSelectorItemView*)createItem:(int)dataType {
    float h = 102;
    if ([UCFSUtil deviceIs3inch])
        h = 82;
    float y = dataType*h;
    CGRect viewframe = CGRectMake(0, y, 320, h);
  
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    
    HealthSelectorItemView* itemView;
    
    switch (dataType) {
        case HEALTH_GOAL_WEIGHT:
            weightView = [[HealthSelectorItemView alloc] initWithFrame:viewframe withDataType:dataType];
            itemView = weightView;
            break;
        case HEALTH_GOAL_HEARTRATE:
            heartrateView = [[HealthSelectorItemView alloc] initWithFrame:viewframe withDataType:dataType];
            itemView = heartrateView;
            break;
        case HEALTH_GOAL_PRESSURE:
            pressureView = [[HealthSelectorItemView alloc] initWithFrame:viewframe withDataType:dataType];
            itemView = pressureView;
            break;
        case HEALTH_GOAL_GLUCOSE:
            glucoseView = [[HealthSelectorItemView alloc] initWithFrame:viewframe withDataType:dataType];
            itemView = glucoseView;
            break;
        case HEALTH_GOAL_CHOLESTEROL_LDL:
            cholesterolView = [[HealthSelectorItemView alloc] initWithFrame:viewframe withDataType:dataType];
            itemView = cholesterolView;
            break;
    }
    
    itemView.tag = dataType;
    [itemView addGestureRecognizer:tapRecognizer];
    
    return itemView;
    
}

- (void)updateWithLog:(FTLogData*)logData withDataType:(int)dataType {
    //if (logData!=nil) {
        switch (dataType) {
            case HEALTH_GOAL_WEIGHT:
                [weightView updateWithLog:logData];
                break;
            case HEALTH_GOAL_HEARTRATE:
                [heartrateView updateWithLog:logData];
                break;
            case HEALTH_GOAL_PRESSURE:
                [pressureView updateWithLog:logData];
                break;
            case HEALTH_GOAL_GLUCOSE:
                [glucoseView updateWithLog:logData];
                break;
            case HEALTH_GOAL_CHOLESTEROL_LDL:
                [cholesterolView updateWithLog:logData];
                break;
        }
    //}
}


- (IBAction)handleTap:(UITapGestureRecognizer*)sender {
    int goal = (int)(sender.view.tag);

    selectedGoal = goal;
    [self.delegate changeGoal:selectedGoal ];
}



@end
