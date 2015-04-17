//
//  FitnessLogData.m
//  FitHeart
//
//  Created by Bitgears on 05/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTLogData.h"

@implementation FTLogData

@synthesize uniqueId;
@synthesize section;
@synthesize logValue;
@synthesize logValue2;
@synthesize insertDate;
@synthesize activity;
@synthesize effort;
@synthesize meal;
@synthesize goalType;
@synthesize uploadedToServer;
@synthesize goalId;
@synthesize deleted;

- (id)initWithGoal:(FTGoalData*)goal {
    self = [super init];
    if (self) {
        uniqueId = 0;
        logValue = 0;
        logValue2 = 0;
        activity = 1;
        effort = 0;
        meal = 0;
        goalId = goal.goalId;
        section = goal.section;
        goalType = goal.dataType.goaltypeId;
        uploadedToServer = false;
        deleted = false;
        
    }
    return self;
   
}



@end
