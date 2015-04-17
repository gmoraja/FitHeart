//
//  HealthSection.m
//  FitHeart
//
//  Created by Bitgears on 01/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "HealthSection.h"
#import "UCFSUtil.h"
#import "FTDatabase.h"

NSString     *const UCFS_HealthView_NavBar_Title = @"HEALTH";
NSString     *const UCFS_HealthWeightView_NavBar_Title = @"WEIGHT";
NSString     *const UCFS_HealthHeartRateView_NavBar_Title = @"HEART RATE";
NSString     *const UCFS_HealthPressureView_NavBar_Title = @"BLOOD PRESSURE";
NSString     *const UCFS_HealthGlucoseView_NavBar_Title = @"GLUCOSE";
NSString     *const UCFS_HealthCholesterolView_NavBar_Title = @"LDL CHOLESTEROL";
NSString     *const UCFS_HealthCholesterolView_NavBar_LogTitle = @"CHOLESTEROL";

NSString     *const UCFS_HealthView_NavBar_Bkg = @"health_navbar_bkg";


@implementation HealthSection

static HealthSection *instance =nil;
static HealthGoal currentGoal = HEALTH_GOAL_WEIGHT;

static FTHeaderConf* headerConfLogWeight = nil;
static FTHeaderConf* headerConfLogHeartRate = nil;
static FTHeaderConf* headerConfLogPressure = nil;
static FTHeaderConf* headerConfLogGlucose = nil;
static FTHeaderConf* headerConfLogCholesterolLdl = nil;

static NSMutableArray* bannerNotifications = nil;
static BOOL extractNotificationRandomly = FALSE;
static int lastNotificationIndex = 0;
static NSMutableArray* localNotifications = nil;

static NSArray *glucoseTimes = nil;


+(HealthSection *)getInstance {
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [HealthSection new];
        }
    }
    return instance;
}

+ (SectionType) sectionType {
    return SECTION_HEALTH;
}

+ (NSString*) title {
    return UCFS_HealthView_NavBar_Title;
}

+ (NSString*) goalTitle:(int)goal {
    switch (goal) {
        case HEALTH_GOAL_WEIGHT:
            return UCFS_HealthWeightView_NavBar_Title;
        case HEALTH_GOAL_HEARTRATE:
            return UCFS_HealthHeartRateView_NavBar_Title;
            break;
        case HEALTH_GOAL_PRESSURE:
            return UCFS_HealthPressureView_NavBar_Title;
            break;
        case HEALTH_GOAL_GLUCOSE:
            return UCFS_HealthGlucoseView_NavBar_Title;
            break;
        case HEALTH_GOAL_CHOLESTEROL_LDL:
            return UCFS_HealthCholesterolView_NavBar_Title;
            break;
            
    }
    return nil;
}

+ (NSString*) logTitle:(int)goal {
    switch (goal) {
        case HEALTH_GOAL_WEIGHT:
            return UCFS_HealthWeightView_NavBar_Title;
        case HEALTH_GOAL_HEARTRATE:
            return UCFS_HealthHeartRateView_NavBar_Title;
            break;
        case HEALTH_GOAL_PRESSURE:
            return UCFS_HealthPressureView_NavBar_Title;
            break;
        case HEALTH_GOAL_GLUCOSE:
            return UCFS_HealthGlucoseView_NavBar_Title;
            break;
        case HEALTH_GOAL_CHOLESTEROL_LDL:
            return UCFS_HealthCholesterolView_NavBar_LogTitle;
            break;
            
    }
    return nil;
}

+ (UIColor*) mainColor:(int)goal {
    return [UIColor colorWithRed:166.0/255.0 green:96.0/255.0 blue:130.0/255.0 alpha:1.0];
}

+ (UIColor*) lightColor:(int)goal {

    return [UIColor colorWithRed:215.0/255.0 green:199.0/255.0 blue:207.0/255.0 alpha:1.0];
}

+ (UIColor*) highLightColor:(int)goal {

    return [UIColor colorWithRed:181.0/255.0 green:160.0/255.0 blue:171.0/255.0 alpha:1.0];
}

+ (UIColor*) darkColor:(int)goal {

    return [UIColor colorWithRed:166.0/255.0 green:118.0/255.0 blue:141.0/255.0 alpha:1.0];
}

+ (UIColor*) footerColor:(int)goal {
    return [UIColor colorWithRed:197.0/255.0 green:139.0/255.0 blue:167.0/255.0 alpha:1.0];
}

+ (NSString*) navBarBkg:(int)goal {
    return UCFS_HealthView_NavBar_Bkg;
}

+ (UIColor*) navBarTextColor:(int)goal {
    return [UIColor whiteColor];
}

+ (NSString*) bannerReloadImageFilename {
    return @"health_reload";
}

+ (NSString*) circularImageFilename {
    return @"health_home_circle";
}

+ (NSString*) circularInfoImageFilename {
    return @"health_home_circle_info2";
}

+ (NSString*) circularDoubleInfoImageFilename {
    return @"health_home_circle_info_double2";
}

+ (NSString*) circularMaxLimitImageFilename {
    return @"health_max_limit2";
}

+ (UIColor*) circularOverlayTextColor {
    return [UIColor colorWithRed:238.0/255.0 green:228.0/255.0 blue:233.0/255.0 alpha:1.0];
}

+ (UIColor*) circularArrowTextColor {
    return [UIColor colorWithRed:203.0/255.0 green:158.0/255.0 blue:180.0/255.0 alpha:1.0];
}

+ (UIColor*) circularBottomTextColor {
    return [UIColor colorWithRed:148.0/255.0 green:104.0/255.0 blue:126.0/255.0 alpha:1.0];
}

+ (NSString*) verticalDottedLineImageFilename {
    return @"health_dotted_line_vertical";
}

+ (NSString*) circularTopFixImageFilename {
    return @"top_fix_health";
}

+ (NSString*) circularTopFixNotTappableImageFilename {
    return @"top_fix_health_ne";
}

+ (NSString*) rightFixImageFilename {
    return @"right_fix_health";
}


+ (int)getCurrentGoal {
    return currentGoal;
}

+ (void)setCurrentGoal:(int)goal {
    currentGoal = goal;
}

+ (FTGoalData*)defaultGoalDataWithType:(int)goalType {
    
    return nil;
    
}

+ (FTHeaderConf*)headerConfWithGoalType:(int)goalType {
    return nil;
}

+ (void)loadGoals {

}

+ (FTGoalData*)goalDataWithType:(int)goalType {
    return nil;
}

+ (void)updateGoalData:(FTGoalData*)goalData {
    
}

+ (void)saveGoalData:(FTGoalData*)goalData {
}

+ (FTGoalData*)lastGoalData {
    return nil;
}

+ (NSString*)infoOverlayScreenText:(int)goal {
    return nil;
}

+ (NSMutableArray*)goalEntries {
    return nil;
}

+ (NSMutableArray*)loadEntriesWithGoalData:(FTGoalData*)goalData {
    return nil;
}

+ (NSMutableArray*)loadEntries:(int)dateType withGoalData:(FTGoalData*)goalData {
    return nil;
}

+ (NSString*)unitByGoalType:(int)goalType {
    NSString* unit = @"";
    switch (goalType) {
        case HEALTH_GOAL_WEIGHT: unit = @"lbs"; break;
        case HEALTH_GOAL_HEARTRATE: unit = @"bpm"; break;
        case HEALTH_GOAL_PRESSURE: unit = @"mmHg"; break;
        case HEALTH_GOAL_GLUCOSE: unit = @"mg/Dl"; break;
        case HEALTH_GOAL_CHOLESTEROL_LDL: unit = @"mg/Dl"; break;
    }
    return unit;
}

//LOG
+ (FTHeaderConf*)headerConfForLogWithGoalType:(int)goalType {
    
    FTHeaderConf *sectionGoal = nil;
    
    switch (goalType) {
        case HEALTH_GOAL_WEIGHT:
            if (headerConfLogWeight==nil) {
                headerConfLogWeight = [[FTHeaderConf alloc] initAsSingleValue];
                headerConfLogWeight.leftText = @"";
                headerConfLogWeight.rightText = @"lbs";
                headerConfLogWeight.valueTextColor = [self mainColor:goalType];
                headerConfLogWeight.leftTextColor = [UIColor blackColor];
                headerConfLogWeight.wheelStepValue = 5;
                headerConfLogWeight.unit = @"lbs";
            }
            sectionGoal = headerConfLogWeight;
            break;
        case HEALTH_GOAL_HEARTRATE:
            if (headerConfLogHeartRate==nil) {
                headerConfLogHeartRate = [[FTHeaderConf alloc] initAsSingleValue];
                headerConfLogHeartRate.leftText = @"";
                headerConfLogHeartRate.rightText = @"bpm";
                headerConfLogHeartRate.valueTextColor = [self mainColor:goalType];
                headerConfLogHeartRate.leftTextColor = [UIColor blackColor];
                headerConfLogHeartRate.wheelStepValue = 20;
                headerConfLogHeartRate.unit = @"bpm";
            }
            sectionGoal = headerConfLogHeartRate;
            break;
        case HEALTH_GOAL_PRESSURE:
            if (headerConfLogPressure==nil) {
                headerConfLogPressure = [[FTHeaderConf alloc] initAsDoubleValue];
                headerConfLogPressure.leftText = @"";
                headerConfLogPressure.rightText = @"mmHg";
                headerConfLogPressure.valueTextColor = [self mainColor:goalType];
                headerConfLogPressure.value2TextColor = [self mainColor:goalType];
                headerConfLogPressure.normalizeValue = FALSE;
                headerConfLogPressure.wheelStepValue = 20;
                headerConfLogPressure.valueTextWidth = 150;
                headerConfLogPressure.unit = @"mmHg";
                headerConfLogPressure.unit2 = @"mmHg";
            }
            sectionGoal = headerConfLogPressure;
            break;
        case HEALTH_GOAL_GLUCOSE:
            if (headerConfLogGlucose==nil) {
                headerConfLogGlucose = [[FTHeaderConf alloc] initAsSingleValue];
                headerConfLogGlucose.leftText = @"GLUCOSE";
                headerConfLogGlucose.rightText = @"mg/Dl";
                headerConfLogGlucose.valueTextColor = [self mainColor:goalType];
                headerConfLogGlucose.leftTextColor = [UIColor blackColor];
                headerConfLogGlucose.wheelStepValue = 20;
                headerConfLogGlucose.unit = @"mg/Dl";
            }
            sectionGoal = headerConfLogGlucose;
            break;
        case HEALTH_GOAL_CHOLESTEROL_LDL:
            if (headerConfLogCholesterolLdl==nil) {
                headerConfLogCholesterolLdl = [[FTHeaderConf alloc] initAsSingleValue];
                headerConfLogCholesterolLdl.leftText = @"LDL (BAD)";
                headerConfLogCholesterolLdl.rightText = @"mg/Dl";
                headerConfLogCholesterolLdl.valueTextColor = [self mainColor:goalType];
                headerConfLogCholesterolLdl.leftTextColor = [UIColor blackColor];
                headerConfLogCholesterolLdl.wheelStepValue = 20;
                headerConfLogCholesterolLdl.unit = @"mg/Dl";
            }
            sectionGoal = headerConfLogCholesterolLdl;
            break;
    }
    
    
    return sectionGoal;
    
}

+ (FTLogData*)defaultLogDataWithGoalType:(int)goalType {
    
    FTLogData* logData = [[FTLogData alloc] init];
    logData.goalType = goalType;
    logData.section = SECTION_HEALTH;
    logData.insertDate = [NSDate date];
    
    switch (goalType) {
        case HEALTH_GOAL_WEIGHT:
            logData.logValue = 200;
            break;
        case HEALTH_GOAL_HEARTRATE:
            logData.logValue = 100;
            break;
        case HEALTH_GOAL_PRESSURE:
            logData.logValue = 140;
            logData.logValue2 = 90;
            break;
        case HEALTH_GOAL_GLUCOSE:
            logData.logValue = 100;
            break;
        case HEALTH_GOAL_CHOLESTEROL_LDL:
            logData.logValue = 70;
            break;
    }
    
    return logData;
}

+ (FTLogData*)lastLogDataWithGoalType:(int)goalType {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectLastLogWithSection:SECTION_HEALTH withGoal:goalType];
}

+ (void)saveLogData:(FTLogData*)logData {
    FTDatabase *db = [FTDatabase getInstance];
    [db insertLog:logData];
    
}

+ (void)deleteLog:(int)logId {
    FTDatabase *db = [FTDatabase getInstance];
    [db deleteLog:logId];
    
}

//REMINDER
+ (void)saveReminder:(FTReminderData*)reminder {
    FTDatabase *db = [FTDatabase getInstance];
    [db insertReminder:reminder];
}

+ (FTReminderData*)defaultReminderWithGoal:(int)goal {
    FTReminderData* result = [[FTReminderData alloc] initWithSection:SECTION_HEALTH withGoal:goal asDaily:FALSE];
    //9AM tuesday
    result.frequency = TIME_FREQUENCY_NONE;
    result.dayOfWeek = 2;
    result.hours = 9;
    result.amPm = 0;
    
    return result;
    
}

+ (FTReminderData*)loadReminderWithGoal:(int)goal {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectReminderWithSection:SECTION_HEALTH withGoal:goal];
}


+(NSMutableArray*)loadEntries:(int)dateType withGoalType:(int)goalType {
    FTDatabase *db = [FTDatabase getInstance];
    /*
    if (dateType>=0) {
        if (goalType==HEALTH_GOAL_CHOLESTEROL_HDL || goalType==HEALTH_GOAL_CHOLESTEROL_LDL || goalType==HEALTH_GOAL_CHOLESTEROL_TRIG) {
            return [db selectLogGroupedByDate:dateType withGoal:goalType withSection:SECTION_HEALTH withAggregation:DB_AGGREGATION_NONE];
        }
        else
            return [db selectLogGroupedByDate:dateType withGoal:goalType withSection:SECTION_HEALTH withAggregation:DB_AGGREGATION_AVERAGE];
    }
    else
     */
        return [db selectAllLogWithSection:SECTION_HEALTH withGoal:goalType];

}

+ (FTLogData*)logDataWithGoalType:(int)goalType withDate:(NSString*)dateValue {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectLogWithSection:SECTION_HEALTH withGoal:goalType withDate:dateValue];
}

+ (float)maxLogValueWithGoal:(int)goal {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectMaxLogValueWithSection:SECTION_HEALTH withGoal:goal onValue2:NO];
}

+ (float)minLogValueWithGoal:(int)goal {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectMinLogValueWithSection:SECTION_HEALTH withGoal:goal onValue2:NO];
}

+ (float)maxLogValue2WithGoal:(int)goal {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectMaxLogValueWithSection:SECTION_HEALTH withGoal:goal onValue2:YES];
}

+ (float)minLogValue2WithGoal:(int)goal {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectMinLogValueWithSection:SECTION_HEALTH withGoal:goal onValue2:YES];
}

+ (int)sliderIncrementByGoal:(int)goal {
    switch (goal) {
        case HEALTH_GOAL_WEIGHT:            return 1; break;
        case HEALTH_GOAL_HEARTRATE:         return 1; break;
        case HEALTH_GOAL_PRESSURE:          return 1; break;
        case HEALTH_GOAL_GLUCOSE:           return 1; break;
        case HEALTH_GOAL_CHOLESTEROL_LDL:   return 1; break;
        default: return 1;
    }
}


+ (FTNotification*)nextBannerNotification {
    FTNotification* nextNotification = nil;
    
    if (bannerNotifications==nil) {
        bannerNotifications = [UCFSUtil notificationsFromJson:@"health_banner_notifications"];
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

+ (FTNotification*)nextLocalNotificationWithGoal:(int)goal withDateType:(int)dateType withLast:(int)lastLocalNot {
    FTNotification* nextNotification = nil;
    
    if (localNotifications==nil) {
        localNotifications = [UCFSUtil notificationsFromJson:@"health_local_notifications"];
    }
    
    if (localNotifications!=nil && [localNotifications count]>0 ) {
        NSMutableArray* tempGoalNotifications = [[NSMutableArray alloc] init];
        int normalizedGoal = goal;
 
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

+ (NSString*) infoHomeImageFilename {
    if ([UCFSUtil deviceIs3inch])
        return @"overlay_health";
    else
        return @"overlay_health-568h@2x.png";
}

+ (NSString*) infoGoalImageFilename {
    if ([UCFSUtil deviceIs3inch])
        return @"info_log_health";
    else
        return @"info_log_health-568h@2x.png";
}

+ (NSString*) infoLogImageFilename {
    if ([UCFSUtil deviceIs3inch])
        return @"info_log_health";
    else
        return @"info_log_health-568h@2x.png";
}

+ (NSArray*)getGlucoseTimes {
    if (glucoseTimes==nil) {
        glucoseTimes = [[NSArray alloc] initWithObjects:
                 @"BREAKFAST",
                 @"LUNCH",
                 @"DINNER",
                 @"SNACK",
                 @"OTHER",
                 nil
                 ];
    }
    
    return glucoseTimes;
    
}

+(void)checkValueChangesWithGoal:(int)goal withValue:(float)value withValue2:(float)value2 asValue2:(BOOL)isValue2 {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    BOOL warning = NO;
    BOOL performChanges = YES;
    NSString* reason = @"";
    switch (goal) {
        case HEALTH_GOAL_WEIGHT:
            if (value>999) {
                warning = YES;
                performChanges = NO;
                reason = @"Weight should not be higher than 999. Please re-enter.";
            }
            break;
        case HEALTH_GOAL_HEARTRATE:
            if (value>200) {
                warning = YES;
                performChanges = NO;
                reason = @"Heart rate should not be higher than 200. Please re-enter.";
            }
            break;
        case HEALTH_GOAL_PRESSURE:
            if (value2>value) {
                warning = YES;
                performChanges = NO;
                reason = @"Systolic blood pressure cannot be lower than diastolic blood pressure. Please re-enter.";
            }
            else {
                if (value>300) {
                    warning = YES;
                    performChanges = NO;
                    reason = @"Systolic blood pressure shouldn't be that high. Please re-enter.";
                }
                else
                    if (value>=180 && value<=300) {
                        warning = YES;
                        performChanges = YES;
                        reason = @"That is a really high systolic blood pressure. Are you sure?";
                    }
                
                if (value2>150) {
                    warning = YES;
                    performChanges = NO;
                    reason = @"Diastolic blood pressure shouldn't be that high. Please re-enter.";
                }
                else
                    if (value2>=120 && value2<=150) {
                        warning = YES;
                        performChanges = YES;
                        reason = @"That is a really high diastolic blood pressure. Are you sure?";
                    }
            }
            break;
        case HEALTH_GOAL_GLUCOSE:
            if (value>400) {
                warning = YES;
                performChanges = NO;
                reason = @"Glucose usually isn't above 400. Please re-enter.";
            }
            else
                if (value>=250 && value<=400) {
                    warning = YES;
                    performChanges = YES;
                    reason = @"That is a really high glucose. Are you sure?";
                }
            break;
        case HEALTH_GOAL_CHOLESTEROL_LDL:
            if (value>300) {
                warning = YES;
                performChanges = NO;
                reason = @"LDL Cholesterol usually isn't that high. Please re-enter.";
            }
            break;

            
        default:
            break;
    }
    
    if (warning) {
        float logValue = 0;
        if (performChanges==NO) {
            FTLogData* defaultLogData = [self defaultLogDataWithGoalType:goal];
            logValue = (isValue2 ? defaultLogData.logValue2 : defaultLogData.logValue);
        }
        else {
            logValue = (isValue2 ? value2 : value);
        }
        [dict setObject:[NSNumber numberWithBool:performChanges] forKey:@"performChanges"];
        [dict setObject:[NSNumber numberWithFloat:logValue] forKey:@"logValue"];

        NSException* myException = [NSException
                                    exceptionWithName:@"ChangeNotAllowed"
                                    reason:reason
                                    userInfo:dict];
        @throw myException;
    }
    
}



@end
