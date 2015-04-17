//
//  FitnessSection.h
//  FitHeart
//
//  Created by Bitgears on 11/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTSection.h"
#import "FTGoalData.h"

extern NSString     *const UCFS_FitnessView_NavBar_Title;
extern NSString     *const UCFS_FitnessGoalView_NavBar_Title;
extern NSString     *const UCFS_FitnessView_NavBar_Bkg;
extern NSString     *const UCFS_FitnessLogView_NavBar_Title;


enum {
    FITNESS_GOAL_TIME            = 0,
    FITNESS_GOAL_STEPS           = 1
}; typedef NSUInteger FitnessGoal;

@interface FitnessSection : NSObject <FTSection> {
    
}
+ (FTHeaderConf*)headerConfForLogTimer;
+ (NSArray*)getActivities;
+ (NSArray*)getEfforts;
+ (BOOL)checkWeekIsOver:(FTGoalData*)goalData;
+ (BOOL)checkWeekIsOverWithStartDate:(NSDate*)startDate;


@end
