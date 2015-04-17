//
//  NutritionSection.m
//  FitHeart
//
//  Created by Bitgears on 27/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "NutritionSection.h"
#import "UCFSUtil.h"
#import "FTDatabase.h"


NSString    *const UCFS_NutritionView_NavBar_Title = @"NUTRITION";
NSString    *const UCFS_NutritionGoalView_NavBar_Title = @"NUTRITION GOAL";
NSString    *const UCFS_NutritionGoalWeightView_NavBar_Title = @"WEIGHT GOAL";
NSString    *const UCFS_NutritionGoalCaloriesView_NavBar_Title = @"CALORIES GOAL";
NSString    *const UCFS_NutritionLogView_NavBar_Title = @"NUTRITION LOG";
NSString    *const UCFS_NutritionLogWeightView_NavBar_Title = @"WEIGHT LOG";
NSString    *const UCFS_NutritionLogCaloriesView_NavBar_Title = @"CALORIES LOG";

NSString    *const UCFS_NutritionView_NavBar_Bkg = @"nutrition_navbar_bkg";


@implementation NutritionSection

static NutritionSection *instance =nil;
static NutritionGoal currentGoal = NUTRITION_GOAL_WEIGHT;
static FTGoalData* weightGoal = nil;
static FTGoalData* caloriesGoal = nil;

static FTHeaderConf* headerConfGoalWeight = nil;
static FTHeaderConf* headerConfGoalCalories = nil;
static FTHeaderConf* headerConfLogWeight = nil;
static FTHeaderConf* headerConfLogCalories = nil;

static NSMutableArray* bannerNotifications = nil;
static BOOL extractNotificationRandomly = FALSE;
static int lastNotificationIndex = 0;
static NSMutableArray* localNotifications = nil;

static NSArray *meals = nil;

+(NutritionSection *)getInstance {
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [NutritionSection new];
        }
    }
    return instance;
}

+ (SectionType) sectionType {
    return SECTION_NUTRITION;
}

+ (NSString*) title {
    return UCFS_NutritionView_NavBar_Title;
}

+ (NSString*) goalTitle:(int)goal {
    switch (goal) {
        case NUTRITION_GOAL_WEIGHT:     return UCFS_NutritionGoalWeightView_NavBar_Title; break;
        case NUTRITION_GOAL_CALORIES:   return UCFS_NutritionGoalCaloriesView_NavBar_Title; break;
    }
    return UCFS_NutritionGoalView_NavBar_Title;
}

+ (NSString*) logTitle:(int)goal {
    switch (goal) {
        case NUTRITION_GOAL_WEIGHT:     return UCFS_NutritionLogWeightView_NavBar_Title; break;
        case NUTRITION_GOAL_CALORIES:   return UCFS_NutritionLogCaloriesView_NavBar_Title; break;
    }
    return UCFS_NutritionLogView_NavBar_Title;
}

+ (UIColor*) mainColor:(int)goal {
    return [UIColor colorWithRed:128.0/255.0 green:214.0/255.0 blue:123.0/255.0 alpha:1.0];
}

+ (UIColor*) lightColor:(int)goal {
    return [UIColor colorWithRed:204.0/255.0 green:227.0/255.0 blue:203.0/255.0 alpha:1.0];
}

+ (UIColor*) highLightColor:(int)goal {
    return [UIColor colorWithRed:204.0/255.0 green:227.0/255.0 blue:203.0/255.0 alpha:1.0];
}

+ (UIColor*) darkColor:(int)goal {
    return [UIColor colorWithRed:100.0/255.0 green:167.0/255.0 blue:96.0/255.0 alpha:1.0];
}

+ (UIColor*) footerColor:(int)goal {
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
}

+ (NSString*) navBarBkg:(int)goal {
    return UCFS_NutritionView_NavBar_Bkg;
}

+ (NSString*) bannerReloadImageFilename {
    return @"nutrition_reload";
}

+ (NSString*) circularImageFilename {
    return @"nutrition_home_circle";
}

+ (NSString*) circularInfoImageFilename {
    return @"nutrition_home_circle_info2";
}

+ (NSString*) circularDoubleInfoImageFilename {
    return @"nutrition_home_circle_info2";
}

+ (NSString*) circularMaxLimitImageFilename {
    return @"nutrition_max_limit2";
}

+ (NSString*) circularTopFixImageFilename {
    return @"top_fix_nutrition";
}

+ (NSString*) circularTopFixNotTappableImageFilename {
    return @"top_fix_nutrition_ne";
}

+ (NSString*) rightFixImageFilename {
    return @"right_fix_nutrition";
}

+ (UIColor*) circularOverlayTextColor {
    return [UIColor colorWithRed:222.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
}

+ (UIColor*) circularArrowTextColor {
    return [UIColor colorWithRed:171.0/255.0 green:225.0/255.0 blue:168.0/255.0 alpha:1.0];
}

+ (UIColor*) circularBottomTextColor {
    return [UIColor colorWithRed:100.0/255.0 green:167.0/255.0 blue:96.0/255.0 alpha:1.0];
}

+ (NSString*) verticalDottedLineImageFilename {
    return @"nutrition_dotted_line_vertical";
}


//GOAL
+ (FTHeaderConf*)headerConfWithGoalType:(int)goalType{
    FTHeaderConf *sectionGoal = nil;
    
    switch (goalType) {
        case NUTRITION_GOAL_WEIGHT:
            if (headerConfGoalWeight==nil) {
                headerConfGoalWeight = [[FTHeaderConf alloc] initAsSingleValueTopLabeled];
                headerConfGoalWeight.leftText = @"WEIGHT";
                headerConfGoalWeight.rightText = @"lbs";
                headerConfGoalWeight.topText = @"BELOW";
                headerConfGoalWeight.unit = @"lbs";
                headerConfGoalWeight.maxValueLimit = 999;
                headerConfGoalWeight.normalizeValue = FALSE;
            }
            sectionGoal = headerConfGoalWeight;
            break;
        case NUTRITION_GOAL_CALORIES:
            if (headerConfGoalCalories==nil) {
                headerConfGoalCalories = [[FTHeaderConf alloc] initAsSingleValueTopLabeled];
                headerConfGoalCalories.leftText = @"CALORIES";
                headerConfGoalCalories.rightText = @"cal/day";
                headerConfGoalCalories.topText = @"BELOW";
                headerConfGoalCalories.unit = @"cal";
                headerConfGoalCalories.dateType = 0;
                headerConfGoalCalories.maxValueIsEditable = FALSE;
                headerConfGoalCalories.valueTextWidth = 90.0;
                headerConfGoalCalories.compactValue = TRUE;
                headerConfGoalCalories.normalizeValue = FALSE;
            }
            sectionGoal = headerConfGoalCalories;
            break;
    }
    
    sectionGoal.valueTextColor = [self mainColor:0];
    sectionGoal.topTextColor = [self mainColor:0];
    return sectionGoal;

}

+ (int) getCurrentGoal {
    return currentGoal;
}

+ (void) setCurrentGoal:(int)goal {
    currentGoal = goal;
}

+ (FTGoalData*)defaultGoalDataWithType:(int)goalType {
    
    FTGoalData* goalData = [[FTGoalData alloc] init];
    goalData.goalType = goalType;
    goalData.section = SECTION_NUTRITION;
    goalData.value1IsFloat = NO;
    goalData.value2IsFloat = NO;
    goalData.reminder = [[FTReminderData alloc] initWithSection:SECTION_NUTRITION withGoal:goalType asDaily:FALSE];
    
    switch (goalType) {
        case NUTRITION_GOAL_WEIGHT:
            goalData.minGoalValue = 0;
            goalData.goalValue = 0;
            goalData.maxGoalValue = 400;
            goalData.reminder.dayOfWeek = 2;

            break;
        case NUTRITION_GOAL_CALORIES:
            goalData.minGoalValue = 0;
            goalData.goalValue = 1500;
            goalData.maxGoalValue = 3000;
            goalData.reminder.dayOfWeek = 6;
            break;

    }
    
    
    return goalData;
    
}

+ (void)loadGoals {
    weightGoal = nil;
    caloriesGoal = nil;

    FTDatabase *db = [FTDatabase getInstance];
    NSMutableArray *goals = [db selectAllGoalWithSection:SECTION_NUTRITION];
    for (int i=0; i<[goals count]; i++  ) {
        FTGoalData *goal = (FTGoalData*)[goals objectAtIndex:i];
        switch (goal.goalType) {
            case NUTRITION_GOAL_WEIGHT: weightGoal = goal; break;
            case NUTRITION_GOAL_CALORIES: caloriesGoal = goal; break;
        }
    }
}

+ (FTGoalData*)goalDataWithType:(int)goalType {
    switch (goalType) {
        case NUTRITION_GOAL_WEIGHT: return weightGoal; break;
        case NUTRITION_GOAL_CALORIES: return caloriesGoal; break;
    }
    return nil;
}


+ (void)saveGoalData:(FTGoalData*)goalData {
    FTDatabase *db = [FTDatabase getInstance];
    [db insertGoal:goalData];
    [db insertReminder:goalData.reminder];
    
}

+ (NSString*)infoOverlayScreenText:(int)goal {
    switch (goal) {
        case NUTRITION_GOAL_WEIGHT: return @"An average, achievable goal for weight loss is about 5 pounds in one month."; break;
        case NUTRITION_GOAL_CALORIES: return @"An average amount of calories for an active person is about 2000. To lose weight, you may need to eat fewer calories."; break;
    }
    return nil;
}


//LOG
+ (FTHeaderConf*)headerConfForLogWithGoalType:(int)goalType {
    
    FTHeaderConf *sectionGoal = nil;
    
    switch (goalType) {

        case NUTRITION_GOAL_WEIGHT:
            if (headerConfLogWeight==nil) {
                headerConfLogWeight = [[FTHeaderConf alloc] initAsSingleValue];
                headerConfLogWeight.leftText = @"WEIGHT";
                headerConfLogWeight.rightText = @"lbs";
                headerConfLogWeight.valueTextColor = [self mainColor:NUTRITION_GOAL_WEIGHT];
                headerConfLogWeight.normalizeValue = FALSE;
            }
            sectionGoal = headerConfLogWeight;
            break;
        case NUTRITION_GOAL_CALORIES:
            if (headerConfLogCalories==nil) {
                headerConfLogCalories = [[FTHeaderConf alloc] initAsSingleValue];
                headerConfLogCalories.leftText = @"CALORIES";
                headerConfLogCalories.rightText = @"cal";
                headerConfLogCalories.valueTextColor = [self mainColor:NUTRITION_GOAL_CALORIES];
                headerConfLogCalories.valueTextWidth = 90.0;
                headerConfLogCalories.compactValue = TRUE;

                
            }
            sectionGoal = headerConfLogCalories;
            break;
    }
    
    
    return sectionGoal;
    
}

+ (FTLogData*)defaultLogDataWithGoalType:(int)goalType {
    
    FTLogData* logData = [[FTLogData alloc] init];
    logData.goalType = goalType;
    logData.section = SECTION_NUTRITION;
    
    switch (goalType) {
        case NUTRITION_GOAL_WEIGHT:
            logData.logValue = 200.0;
            
            break;
        case NUTRITION_GOAL_CALORIES:
            logData.logValue = 0.0;
            break;
    }
    
    logData.logValue2 = 0;
    logData.insertDate = [NSDate date];
    
    return logData;
    
}

+ (FTLogData*)lastLogDataWithGoalType:(int)goalType {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectLastLogWithSection:SECTION_NUTRITION withGoal:goalType];
}

+ (void)saveLogData:(FTLogData*)logData {
    FTDatabase *db = [FTDatabase getInstance];
    [db insertLog:logData];
    
}

+(NSMutableArray*)loadEntries:(int)dateType withGoalType:(int)goalType {
    FTDatabase *db = [FTDatabase getInstance];
    if (dateType>=0) {
        if (goalType==NUTRITION_GOAL_WEIGHT)
            return [db selectLogGroupedByDate:dateType withGoal:goalType withSection:SECTION_NUTRITION withAggregation:DB_AGGREGATION_AVERAGE];
        else {
            if (dateType==0)
                return [db selectLogGroupedByDate:dateType withGoal:goalType withSection:SECTION_NUTRITION withAggregation:DB_AGGREGATION_SUM];
            else
                return [db selectLogGroupedByDate:dateType withGoal:goalType withSection:SECTION_NUTRITION withAggregation:DB_AGGREGATION_AVERAGE];
        }
    }
    else
        return [db selectAllLogWithSection:SECTION_NUTRITION withGoal:goalType];

}

+ (FTLogData*)logDataWithGoalType:(int)goalType withDate:(NSString*)dateValue {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectLogWithSection:SECTION_NUTRITION withGoal:goalType withDate:dateValue];
}

+ (float)maxLogValueWithGoal:(int)goal {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectMaxLogValueWithSection:SECTION_NUTRITION withGoal:goal];
    
}

+ (int)sliderIncrementByGoal:(int)goal {
    switch (goal) {
        case NUTRITION_GOAL_WEIGHT: return 5; break;
        case NUTRITION_GOAL_CALORIES: return 50; break;
        default: return 1;
    }
}

+ (FTNotification*)nextBannerNotification {
    FTNotification* nextNotification = nil;
    
    if (bannerNotifications==nil) {
        bannerNotifications = [UCFSUtil notificationsFromJson:@"nutrition_banner_notifications"];
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
        localNotifications = [UCFSUtil notificationsFromJson:@"nutrition_local_notifications"];
    }
    
    if (localNotifications!=nil && [localNotifications count]>0 ) {
        NSMutableArray* tempGoalNotifications = [[NSMutableArray alloc] init];
        for (int i=0; i<[localNotifications count]; i++ ) {
            FTNotification* notification = (FTNotification*)[localNotifications objectAtIndex:i];
            if ((notification.goal==-1 || notification.goal==goal) && (notification.datetype==dateType) )
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
        return @"overlay_nutrition";
    else
        return @"overlay_nutrition-568h@2x.png";
}

+ (NSString*) infoGoalImageFilename {
    if ([UCFSUtil deviceIs3inch])
        return @"info_log_nutrition";
    else
        return @"info_log_nutrition-568h@2x.png";
}

+ (NSString*) infoLogImageFilename {
    if ([UCFSUtil deviceIs3inch])
        return @"info_log_nutrition";
    else
        return @"info_log_nutrition-568h@2x.png";
}


+ (NSArray*)getMeals {
    if (meals==nil) {
        meals = [[NSArray alloc] initWithObjects:
                 @"BREAKFAST",
                 @"LUNCH",
                 @"DINNER",
                 @"SNACK",
                 nil
                 ];
    }
    
    return meals;
    
}


@end
