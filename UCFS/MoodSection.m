//
//  MoodSection.m
//  FitHeart
//
//  Created by Bitgears on 19/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "MoodSection.h"
#import "FTDatabase.h"
#import "UCFSUtil.h"

NSString     *const UCFS_MoodView_NavBar_Bkg = @"mood_navbar_bkg";
NSString     *const UCFS_MoodView_Picker_Simple_Bkg = @"mood_simple_picker_bkg";
NSString     *const UCFS_MoodView_NavBar_Title = @"MOOD";
NSString     *const UCFS_MoodSimplePleasureView_NavBar_Title = @"SIMPLE PLEASURES";
NSString     *const UCFS_MoodVWriteANoteView_NavBar_Title = @"WRITE A NOTE";
NSString     *const UCFS_MoodMindfulnessView_NavBar_Title = @"MINDFULNESS";
NSString     *const UCFS_MoodCallAFriendView_NavBar_Title = @"FITNESS";
NSString     *const UCFS_MoodReminderView_NavBar_Title = @"ADD REMINDER";

static NSString* simplePleasurePositiveEventsPrompt = @"Identifying and remembering positive events can affect your mood.\nAdd a note about something positive that happened recently.";
static NSString* simplePleasureGratitudePrompt = @"Gratitude can refer to the way you feel when you're thankful for something. Are you thankful for something today?";
static NSString* simplePleasureSilverliningPrompt = @"How you think about an event can make an event feel stressful, relaxing, wonderful, or meaningful. Can you find a way to think about an experience in a more positive way?";
static NSString* simplePleasurePersonalStrengthsPrompt = @"You can use your personal strengths to help you overcome barriers. What are some of your strengths?";
static NSString* simplePleasureActOfKindnessPrompt = @"Doing nice things for other people can make you feel good, even if you don't get anything in return. Have you done something nice for someone else today?";


@implementation MoodSection

static MoodSection *instance =nil;
static MoodGoal currentGoal = MOOD_GOAL_SIMPLEPLEASURE;

static NSMutableArray* bannerNotifications = nil;
static BOOL extractNotificationRandomly = FALSE;
static int lastNotificationIndex = 0;
static NSMutableArray* localNotifications = nil;

+(MoodSection *)getInstance {
    @synchronized(self) {
        if(instance==nil) {
            instance= [MoodSection new];
        }
    }
    return instance;
}

+ (SectionType) sectionType {
    return SECTION_MOOD;
}

+ (NSString*) title {
    return UCFS_MoodView_NavBar_Title;
}

+ (NSString*) goalTitle:(int)goal { return nil; }

+ (NSString*) logTitle:(int)goal { return nil; }

+ (UIColor*) mainColor:(int)goal {
    return [UIColor colorWithRed:245.0/255.0 green:166.0/255.0 blue:35.0/255.0 alpha:1.0];
}

+ (UIColor*) lightColor:(int)goal {
    return [UIColor colorWithRed:240.0/255.0 green:230.0/255.0 blue:208.0/255.0 alpha:1.0];
}

+ (UIColor*) highLightColor:(int)goal {
    return [UIColor colorWithRed:227.0/255.0 green:189.0/255.0 blue:106.0/255.0 alpha:1.0];
}

+ (UIColor*) darkColor:(int)goal {
    return [UIColor colorWithRed:212.0/255.0 green:177.0/255.0 blue:100.0/255.0 alpha:1.0];
}

+ (UIColor*) footerColor:(int)goal {
    return [UIColor colorWithRed:227.0/255.0 green:189.0/255.0 blue:106.0/255.0 alpha:1.0];
}


+ (NSString*) navBarBkg:(int)goal {
    return UCFS_MoodView_NavBar_Bkg;
}

+ (UIColor*) navBarTextColor:(int)goal {
    return [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
}

+ (NSString*) pickerDateBkg:(int)goal { return nil; }

+ (NSString*) pickerSimpleBkg:(int)goal {
    return UCFS_MoodView_Picker_Simple_Bkg;
}

+ (NSString*) bannerReloadImageFilename {
    return @"mood_reload";
}

+ (NSString*) circularImageFilename { return nil; }
+ (NSString*) circularInfoImageFilename { return nil; }
+ (NSString*) circularDoubleInfoImageFilename { return nil; }
+ (UIColor*) circularOverlayTextColor { return nil; }
+ (UIColor*) circularArrowTextColor { return nil; }
+ (UIColor*) circularBottomTextColor { return nil; }
+ (NSString*) circularMaxLimitImageFilename { return nil; }
+ (NSString*) verticalDottedLineImageFilename { return nil; }
+ (NSString*) circularTopFixImageFilename { return nil; }
+ (NSString*) circularTopFixNotTappableImageFilename { return nil; }
+ (NSString*) rightFixImageFilename { return nil; }

+ (NSString*)unitByGoalType:(int)goalType {
    NSString* unit = @"";
    return unit;
}

+ (FTHeaderConf*)headerConfWithGoalType:(int)goalType {
    
    FTHeaderConf *conf = [[FTHeaderConf alloc] initAsTimerValue];
    conf.leftText = @"REMAINING";
    conf.valueTextColor = [self mainColor:0];
    conf.value2TextColor = [self mainColor:0];
    return conf;
}


//GOAL
+ (int)getCurrentGoal { return (int)currentGoal; }
+ (void)setCurrentGoal:(int)goal { currentGoal = goal; }
+ (FTGoalData*)goalDataWithType:(int)goalType { return nil; }
+ (FTGoalData*)defaultGoalDataWithType:(int)goalType { return nil; }
+ (void)loadGoals {}
+ (void)saveGoalData:(FTGoalData*)goalData {}
+ (NSString*)infoOverlayScreenText:(int)goal { return nil; }
+ (void)setGoalData:(FTGoalData*)goalDataObj {}
+ (void)updateGoalData:(FTGoalData*)goalData {}
+ (NSMutableArray*)goalEntries { return nil;}
+ (FTGoalData*)lastGoalData { return nil; }

//REMINDER
+ (void)saveReminder:(FTReminderData*)reminder {
    FTDatabase *db = [FTDatabase getInstance];
    [db insertReminder:reminder];
}

+ (FTReminderData*)defaultReminderWithGoal:(int)goal {
    FTReminderData* result = [[FTReminderData alloc] initWithSection:SECTION_MOOD withGoal:0 asDaily:FALSE];
    //9AM tuesday
    result.frequency = TIME_FREQUENCY_WEEKLY;
    result.dayOfWeek = 3;
    result.hours = 9;
    result.amPm = 0;
    
    return result;

}


+ (FTReminderData*)loadReminderWithGoal:(int)goal {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectReminderWithSection:SECTION_MOOD withGoal:goal];
}

//LOG
+ (FTHeaderConf*)headerConfForLogWithGoalType:(int)goalType { return nil; }
+ (FTLogData*)defaultLogDataWithGoalType:(int)goalType { return nil; }
+ (FTLogData*)logDataWithGoalType:(int)goalType withDate:(NSString*)dateValue {return nil; }
+ (float)maxLogValueWithGoal:(int)goal { return 0; }
+ (float)minLogValueWithGoal:(int)goal { return 0; }
+ (float)maxLogValue2WithGoal:(int)goal { return 0; }
+ (float)minLogValue2WithGoal:(int)goal { return 0; }

+ (NSMutableArray*)loadEntries:(int)dateType withGoalData:(FTGoalData*)goalData  {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectAllDateLogWithSection:SECTION_MOOD withGoal:0];
}

+ (FTLogData*)lastLogDataWithGoalType:(int)goalType {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectLastLogWithSection:SECTION_MOOD withGoal:goalType];

}


+ (void)saveLogData:(FTLogData*)logData {
    FTDatabase *db = [FTDatabase getInstance];
    [db insertLog:logData];
    
}


+ (NSMutableArray*)loadEntriesWithGoalData:(FTGoalData*)goalData {
    FTDatabase *db = [FTDatabase getInstance];
    return [db selectAllDateLogWithSection:SECTION_MOOD withGoal:0];
}

+ (void)deleteLog:(int)logId {
    FTDatabase *db = [FTDatabase getInstance];
    [db deleteLog:logId];
    
}


+ (int)sliderIncrementByGoal:(int)goal { return 1; }

+ (NSString*)simplePleasureTextPrompt:(MoodSimplePleasures)sp {
    switch (sp) {
        case MOOD_SIMPLEPLEASURE_POSITIVEEVENTS:    return simplePleasurePositiveEventsPrompt; break;
        case MOOD_SIMPLEPLEASURE_GRATITUDE:         return simplePleasureGratitudePrompt; break;
        case MOOD_SIMPLEPLEASURE_SILVERLINING:      return simplePleasureSilverliningPrompt; break;
        case MOOD_SIMPLEPLEASURE_PERSONALSTRENGHTS: return simplePleasurePersonalStrengthsPrompt; break;
        case MOOD_SIMPLEPLEASURE_ACTSOFKINDNESS:    return simplePleasureActOfKindnessPrompt; break;
    }
    
    return nil;
}


+ (FTNotification*)nextBannerNotification {
    FTNotification* nextNotification = nil;
    
    if (bannerNotifications==nil) {
        bannerNotifications = [UCFSUtil notificationsFromJson:@"mood_banner_notifications"];
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
        localNotifications = [UCFSUtil notificationsFromJson:@"mood_local_notifications"];
    }
    
    if (localNotifications!=nil && [localNotifications count]>0 ) {
        NSMutableArray* tempGoalNotifications = [[NSMutableArray alloc] init];
        for (int i=0; i<[localNotifications count]; i++ ) {
            FTNotification* notification = (FTNotification*)[localNotifications objectAtIndex:i];
            if ((notification.goal==-1 || notification.goal==goal) )
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
    return nil;
}

+ (NSString*) infoGoalImageFilename {
    return nil;
}

+ (NSString*) infoLogImageFilename {
    return nil;
}




@end
