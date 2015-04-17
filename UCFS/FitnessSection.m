//
//  FitnessSection.m
//  FitHeart
//
//  Created by Bitgears on 11/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FitnessSection.h"
#import "FTDatabase.h"
#import "UCFSUtil.h"


NSString    *const UCFS_FitnessView_NavBar_Title = @"FITNESS";
NSString    *const UCFS_FitnessGoalView_NavBar_Title = @"FITNESS GOAL";
NSString    *const UCFS_FitnessLogView_NavBar_Title = @"FITNESS LOG";
NSString    *const UCFS_FitnessView_NavBar_Bkg = @"fitness_navbar_bkg";

@implementation FitnessSection



static FitnessSection *instance =nil;
static FitnessGoal currentGoal = FITNESS_GOAL_TIME;
static FTGoalData* goalData = nil;

static FTHeaderConf* headerConfGoalTime = nil;
static FTHeaderConf* headerConfGoalSteps = nil;
static FTHeaderConf* headerConfLogTime = nil;
static FTHeaderConf* headerConfLogSteps = nil;

static NSMutableArray* bannerNotifications = nil;
static BOOL extractNotificationRandomly = FALSE;
static int lastNotificationIndex = 0;
static NSMutableArray* localNotifications = nil;

static NSArray *activities = nil;
static NSArray *efforts = nil;


+(FitnessSection *)getInstance {
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [FitnessSection new];
        }
    }
    return instance;
}

+ (SectionType) sectionType {
    return SECTION_FITNESS;
}

+ (NSString*) title {
    return UCFS_FitnessView_NavBar_Title;
}

+ (NSString*) goalTitle:(int)goal {
    return UCFS_FitnessGoalView_NavBar_Title;
}

+ (NSString*) logTitle:(int)goal {
    return UCFS_FitnessLogView_NavBar_Title;
}

+ (UIColor*) mainColor:(int)goal {
    return [UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:136.0/255.0 alpha:1.0];
}

+ (UIColor*) lightColor:(int)goal {
    return [UIColor colorWithRed:191.0/255.0 green:214.0/255.0 blue:215.0/255.0 alpha:1.0];
}

+ (UIColor*) highLightColor:(int)goal {
    return [UIColor colorWithRed:149.0/255.0 green:233.0/255.0 blue:236.0/255.0 alpha:1.0];
}

+ (UIColor*) darkColor:(int)goal {
    return [UIColor colorWithRed:51.0/255.0 green:151.0/255.0 blue:155.0/255.0 alpha:1.0];
}

+ (UIColor*) footerColor:(int)goal {
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
}


+ (NSString*) navBarBkg:(int)goal {
    return UCFS_FitnessView_NavBar_Bkg;
}

+ (UIColor*) navBarTextColor:(int)goal {
    return [UIColor whiteColor];
}

+ (NSString*) bannerReloadImageFilename {
    return @"fitness_reload";
}

+ (NSString*) circularImageFilename {
    return @"fitness_home_circle";
}

+ (NSString*) circularInfoImageFilename {
    return @"fitness_home_circle_info2";
}

+ (NSString*) circularDoubleInfoImageFilename {
    return @"fitness_home_circle_info2";
}

+ (NSString*) circularMaxLimitImageFilename {
    return @"fitness_max_limit2";
}

+ (UIColor*) circularOverlayTextColor {
    return [UIColor colorWithRed:222.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
}

+ (UIColor*) circularArrowTextColor {
    return [UIColor colorWithRed:138.0/255.0 green:214.0/255.0 blue:218.0/255.0 alpha:1.0];
}

+ (UIColor*) circularBottomTextColor {
    return [UIColor colorWithRed:47.0/255.0 green:164.0/255.0 blue:169.0/255.0 alpha:1.0];
}

+ (NSString*) verticalDottedLineImageFilename {
        return @"fitness_dotted_line_vertical";
}

+ (NSString*) circularTopFixImageFilename {
    return @"top_fix_fitness";
}

+ (NSString*) circularTopFixNotTappableImageFilename {
    return @"top_fix_fitness_ne";
}

+ (NSString*) rightFixImageFilename {
    return @"right_fix_fitness";
}


+ (NSString*)unitByGoalType:(int)goalType {
    NSString* unit = @"";
    switch (goalType) {
        case FITNESS_GOAL_TIME: unit = @"minutes"; break;
        case FITNESS_GOAL_STEPS: unit = @"steps"; break;
    }
    return unit;
}

//GOAL
+ (FTHeaderConf*)headerConfWithGoalType:(int)goalType {

    FTHeaderConf *sectionGoal = nil;
    
    switch (goalType) {
        case FITNESS_GOAL_TIME:
            if (headerConfGoalTime==nil) {
                headerConfGoalTime = [[FTHeaderConf alloc] initAsSingleValue];
                headerConfGoalTime.leftText = @"TIME";
                headerConfGoalTime.rightText = @"minutes/week";
                headerConfGoalTime.unit = @"minutes";
                headerConfGoalTime.minValueLimit = 0;
                headerConfGoalTime.maxValueLimit = 999;
                headerConfGoalTime.wheelStepValue = 60;
            }
            sectionGoal = headerConfGoalTime;
            break;

        case FITNESS_GOAL_STEPS:
            if (headerConfGoalSteps==nil) {
                headerConfGoalSteps = [[FTHeaderConf alloc] initAsSingleValue];
                headerConfGoalSteps.leftText = @"STEPS";
                headerConfGoalSteps.rightText = @"steps/week";
                headerConfGoalSteps.compactValue = NO;
                headerConfGoalSteps.unit = @"steps";
                headerConfGoalSteps.maxValueLimit = 200000;
                headerConfGoalSteps.wheelStepValue = 10000;
            }
            sectionGoal = headerConfGoalSteps;
            break;
    }
    
    sectionGoal.valueTextColor = [self mainColor:0];
    return sectionGoal;
    
}


+ (int)getCurrentGoal {
    return (int)currentGoal;
}

+ (void)setCurrentGoal:(int)goal {
    currentGoal = goal;
}

+ (FTGoalData*)defaultGoalDataWithType:(int)goalType {
    
    FTGoalData* goalData = [[FTGoalData alloc] init];
    
    goalData.section = SECTION_FITNESS;
    goalData.valueIsFloat = NO;
    
    switch (goalType) {
        case FITNESS_GOAL_TIME:
//            goalData.minGoalValue = 0;
            goalData.goalValue = 150;
//            goalData.maxGoalValue = 300;
            break;

        case FITNESS_GOAL_STEPS:
//            goalData.minGoalValue = 0;
            goalData.goalValue = 30000;
//            goalData.maxGoalValue = 20000;
            break;
    }
    
    goalData.dataType = [[FTDataType alloc] init];
    goalData.dataType.goaltypeId = goalType;
  
    return goalData;
    
}

+ (void)loadGoals {
    goalData = nil;
    FTDatabase *db = [FTDatabase getInstance];
    
    goalData = [db selectLastGoalWithSection:SECTION_FITNESS ];

}

+ (void)setGoalData:(FTGoalData*)goalDataObj {
    goalData = goalDataObj;
}

+ (FTGoalData*)goalDataWithType:(int)goalType {
    return goalData;
}


+ (void)saveGoalData:(FTGoalData*)goalData {
    FTDatabase *db = [FTDatabase getInstance];
    [db insertGoal:goalData];
}

+ (void)updateGoalData:(FTGoalData*)goalData {
    FTDatabase *db = [FTDatabase getInstance];
    [db updateGoal:goalData];
}

+ (FTGoalData*)lastGoalData {
    
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectLastGoalWithSection:SECTION_FITNESS];
}

//REMINDER
+ (void)saveReminder:(FTReminderData*)reminder {
    FTDatabase *db = [FTDatabase getInstance];
    [db insertReminder:reminder];
}


+(FTReminderData*)defaultReminderWithGoal:(int)goal {
    FTReminderData* result = [[FTReminderData alloc] initWithSection:SECTION_FITNESS withGoal:goal asDaily:TRUE];
    //8PM Thursday
    result.dayOfWeek = 5;
    result.hours = 8;
    result.amPm = 1;
    
    return result;
    
}

+ (FTReminderData*)loadReminderWithGoal:(int)goal {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectReminderWithSection:SECTION_FITNESS withGoal:goal];
}

+ (void)saveReminderData:(FTReminderData*)reminderData {
    FTDatabase *db = [FTDatabase getInstance];
    [db insertReminder:reminderData];
}

+ (NSString*)infoOverlayScreenText:(int)goal {
    switch (goal) {
        case FITNESS_GOAL_TIME: return @"Most people should work up to at least 30 minutes of physical activity, 5 days per week (150 minutes/week)."; break;
        case FITNESS_GOAL_STEPS: return @"Increase your steps goal each week and work up to 10,000 steps/day (70,000 steps/week)."; break;
    }
    return nil;
}

+ (NSMutableArray*)goalEntries {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectGoalGroupedDataWithSection:SECTION_FITNESS];
}

//LOG
+ (FTHeaderConf*)headerConfForLogWithGoalType:(int)goalType {
    
    FTHeaderConf *sectionGoal = nil;
    
    switch (goalType) {
        case FITNESS_GOAL_TIME:
            if (headerConfLogTime==nil) {
                headerConfLogTime = [[FTHeaderConf alloc] initAsSingleValue];
                //headerConfLogTime = [[FTHeaderConf alloc] initAsTimerValue];
                headerConfLogTime.leftText = @"TIME";
                headerConfLogTime.valueTextColor = [self mainColor:FITNESS_GOAL_TIME];
                headerConfLogTime.value2TextColor = [self mainColor:FITNESS_GOAL_TIME];
                headerConfLogTime.minValueLimit = 0;
                headerConfLogTime.unit = @"minutes";
                //headerConfLogTime.maxValueLimit = 999;
                //headerConfLogTime.wheelStepValue = 60;
            }
            sectionGoal = headerConfLogTime;
            break;
        case FITNESS_GOAL_STEPS:
            if (headerConfLogSteps==nil) {
                headerConfLogSteps = [[FTHeaderConf alloc] initAsSingleValue];
                headerConfLogSteps.leftText = @"STEPS";
                headerConfLogSteps.rightText = @"";
                headerConfLogSteps.valueTextColor = [self mainColor:FITNESS_GOAL_STEPS];
                headerConfLogSteps.unit = @"steps";
                
            }
            sectionGoal = headerConfLogSteps;
            break;
        case 2:
            if (headerConfLogTime==nil) {
                headerConfLogTime = [[FTHeaderConf alloc] initAsTimerValue];
                headerConfLogTime.leftText = @"TIME";
                headerConfLogTime.valueTextColor = [self mainColor:FITNESS_GOAL_TIME];
                headerConfLogTime.value2TextColor = [self mainColor:FITNESS_GOAL_TIME];
            }
            sectionGoal = headerConfLogTime;
            break;
    }
    
    
    return sectionGoal;
    
}

+ (FTHeaderConf*)headerConfForLogTimer {
    FTHeaderConf* conf = nil;
    conf = [[FTHeaderConf alloc] initAsTimerValue];
    conf.leftText = @"TIME";
    conf.valueTextColor = [self mainColor:FITNESS_GOAL_TIME];
    conf.value2TextColor = [self mainColor:FITNESS_GOAL_TIME];
    
    return conf;

}




+ (FTLogData*)defaultLogDataWithGoalType:(int)goalType {
    
    FTLogData* logData = [[FTLogData alloc] init];
    logData.goalType = goalType;
    logData.section = SECTION_FITNESS;
    logData.activity = 0;
    switch (goalType) {
        case FITNESS_GOAL_TIME:
            logData.logValue = 30;

            break;
        case FITNESS_GOAL_STEPS:
            logData.logValue = 10000;
            break;
    }
    
    logData.insertDate = [NSDate date];

    return logData;
    
}

+ (FTLogData*)lastLogDataWithGoalType:(int)goalType {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectLastLogWithSection:SECTION_FITNESS withGoal:goalType];
}

+ (void)saveLogData:(FTLogData*)logData {
    FTDatabase *db = [FTDatabase getInstance];
    [db insertLog:logData];
    
}

+ (void)deleteLog:(int)logId {
    FTDatabase *db = [FTDatabase getInstance];
    [db deleteLog:logId];
    
}

+ (NSMutableArray*)loadEntries:(int)dateType withGoalData:(FTGoalData*)goalData  {
    FTDatabase *db = [FTDatabase getInstance];
    if (dateType>=0)
        return [db selectLogGroupedByDate:dateType withGoal:0 withSection:SECTION_FITNESS withAggregation:DB_AGGREGATION_SUM];
    else
        return [db selectAllLogsWithGoal:goalData];
}

+ (NSMutableArray*)loadEntriesWithGoalData:(FTGoalData*)goalData {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectLogsGroupedDataWithGoal:goalData];
}


+ (FTLogData*)logDataWithGoalType:(int)goalType withDate:(NSString*)dateValue {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectLogWithSection:SECTION_FITNESS withGoal:goalType withDate:dateValue];
}


+ (int)sliderIncrementByGoal:(int)goal {
    switch (goal) {
        case FITNESS_GOAL_TIME: return 1; break;
        case FITNESS_GOAL_STEPS: return 100; break;
        default: return 1;
    }
}

+ (float)maxLogValueWithGoal:(int)goal {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectMaxLogValueWithSection:SECTION_FITNESS withGoal:goal onValue2:NO];
    
}

+ (float)minLogValueWithGoal:(int)goal {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectMaxLogValueWithSection:SECTION_FITNESS withGoal:goal onValue2:NO];
    
}
+ (float)maxLogValue2WithGoal:(int)goal { return 0; }
+ (float)minLogValue2WithGoal:(int)goal { return 0; }

//NOTIFICATION

+ (FTNotification*)nextBannerNotification {
    FTNotification* nextNotification = nil;
    
    if (bannerNotifications==nil) {
        bannerNotifications = [UCFSUtil notificationsFromJson:@"fitness_banner_notifications"];
    }
    
    if (bannerNotifications!=nil && [bannerNotifications count]>0 ) {
        if (extractNotificationRandomly==FALSE && lastNotificationIndex<[bannerNotifications count] ) {
            //extract ord
            nextNotification = (FTNotification*)[bannerNotifications objectAtIndex:lastNotificationIndex];
            lastNotificationIndex++;
            if (lastNotificationIndex==[bannerNotifications count])
                extractNotificationRandomly = TRUE;
        }
        else {
            //extract random
            int index = arc4random() % [bannerNotifications count];
            nextNotification = (FTNotification*)[bannerNotifications objectAtIndex:index];
        }
    }
    
    return nextNotification;
}

+ (FTNotification*)nextLocalNotificationWithGoal:(int)goal withDateType:(int)dateType  withLast:(int)lastLocalNot {
    FTNotification* nextNotification = nil;

    @synchronized(self) {
        if (localNotifications==nil) {
            localNotifications = [UCFSUtil notificationsFromJson:@"fitness_local_notifications"];
        }
    }
    
    if (localNotifications!=nil && [localNotifications count]>0 ) {
        NSMutableArray* tempGoalNotifications = [[NSMutableArray alloc] init];
        int normalizedGoal = goal;
        if (goal==FITNESS_GOAL_TIME || goal==FITNESS_GOAL_STEPS )
            normalizedGoal = FITNESS_GOAL_TIME;
        
        for (int i=0; i<[localNotifications count]; i++ ) {
            FTNotification* notification = (FTNotification*)[localNotifications objectAtIndex:i];
            if ((notification.goal==-1 || notification.goal==normalizedGoal) && (notification.datetype==dateType) )
                [tempGoalNotifications addObject:notification];
        }
        
        if (lastLocalNot>=0 && lastLocalNot<([tempGoalNotifications count]-1))
            lastLocalNot++;
        else
            lastLocalNot = 0;
        
        if (lastLocalNot<[tempGoalNotifications count])
            nextNotification = (FTNotification*)[tempGoalNotifications objectAtIndex:lastLocalNot];
    }
    
    return nextNotification;
}

//INFO

+ (NSString*) infoHomeImageFilename {
    if ([UCFSUtil deviceIs3inch])
        return @"overlay_fitness";
    else
        return @"overlay_fitness-568h@2x";
}

+ (NSString*) infoGoalImageFilename {
    if ([UCFSUtil deviceIs3inch])
        return @"info_log_fitness";
    else
        return @"info_log_fitness-568h@2x.png";
}

+ (NSString*) infoLogImageFilename {
    if ([UCFSUtil deviceIs3inch])
        return @"info_log_fitness";
    else
        return @"info_log_fitness-568h@2x.png";
}

+ (NSArray*)getActivities {
    if (activities==nil) {
        activities = [[NSArray alloc] initWithObjects:
                      @"Not selected",
                      @"Walking",
                      @"Running",
                      @"Cycling",
                      @"Swimming",
                      @"Dancing",
                      @"Tennis",
                      @"Hiking",
                      @"Gym",
                      @"Housework",
                      @"Gardening",
                      @"Golf",
                      @"Yoga",
                      @"Rowing",
                      @"Stairs",
                      @"Sports",
                      @"Other",
                      nil
                      ];
    }

    return activities;
}

+ (NSArray*)getEfforts {
    if (efforts==nil) {
        efforts = [[NSArray alloc] initWithObjects:
                        @"Not selected",
                        @"Very Easy",
                        @"Easy",
                        @"Somewhat Easy",
                        @"Somewhat Hard",
                        @"Hard",
                        @"Very Hard",
                        nil
                      ];
    }
    
    return efforts;
}

+ (BOOL)checkWeekIsOver:(FTGoalData*)goalData {
    if (goalData!=nil) {
        return [self checkWeekIsOverWithStartDate:goalData.startDate];
    }
    
    return FALSE;
}

+ (BOOL)checkWeekIsOverWithStartDate:(NSDate*)startDate {
    if (startDate!=nil) {
        NSDate* normStartDate = [UCFSUtil setTimeWithDate:startDate withHours:0 withMinutes:0 withSeconds:0];
        NSDate* endDate = [UCFSUtil getDate:normStartDate addDays:6];
        NSDate* normEndDate = [UCFSUtil setTimeWithDate:endDate withHours:23 withMinutes:59 withSeconds:59];
        NSDate* now = [NSDate date];
        BOOL result = ([now compare:normEndDate]==NSOrderedDescending);
        NSLog(@"checkWeekIsOver=%i",result);
        return result;
    }
    
    return FALSE;
}


@end
