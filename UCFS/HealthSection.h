//
//  HealthSection.h
//  FitHeart
//
//  Created by Bitgears on 01/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTSection.h"

extern NSString     *const UCFS_HealthView_NavBar_Title;

extern NSString     *const UCFS_HealthGoalHeartRateView_NavBar_Title;
extern NSString     *const UCFS_HealthGoalPressureView_NavBar_Title;
extern NSString     *const UCFS_HealthGoalGlucoseView_NavBar_Title;
extern NSString     *const UCFS_HealthGoalCholesterolView_NavBar_Title;

extern NSString     *const UCFS_HealthLogHeartRateView_NavBar_Title;
extern NSString     *const UCFS_HealthLogPressureView_NavBar_Title;
extern NSString     *const UCFS_HealthLogGlucoseView_NavBar_Title;
extern NSString     *const UCFS_HealthLogCholesterolView_NavBar_Title;

extern NSString     *const UCFS_HealthView_NavBar_Bkg;
extern NSString     *const UCFS_HealthHeartRateView_NavBar_Bkg;
extern NSString     *const UCFS_HealthPressureView_NavBar_Bkg;
extern NSString     *const UCFS_HealthGlucoseView_NavBar_Bkg;
extern NSString     *const UCFS_HealthCholesterolView_NavBar_Bkg;


enum {
    HEALTH_GOAL_WEIGHT                      = 0,
    HEALTH_GOAL_HEARTRATE                   = 1,
    HEALTH_GOAL_PRESSURE                    = 2,
    HEALTH_GOAL_GLUCOSE                     = 3,
    HEALTH_GOAL_CHOLESTEROL_LDL             = 4
    
    
}; typedef NSUInteger HealthGoal;


@interface HealthSection : NSObject <FTSection> {
    
}

+ (NSArray*)getGlucoseTimes;
+(NSMutableArray*)loadEntries:(int)dateType withGoalType:(int)goalType;

+(void)checkValueChangesWithGoal:(int)goal withValue:(float)value withValue2:(float)value2 asValue2:(BOOL)isValue2;

@end
