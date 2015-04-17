//
//  UCFSSection.h
//  UCFS
//
//  Created by Bitgears on 31/10/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTHeaderConf.h"
#import "FTGoalData.h"
#import "FTLogData.h"
#import "FTNotification.h"


enum {
    SECTION_FITNESS             =   0,
    SECTION_HEALTH              =   1,
    SECTION_MOOD                =   2
    
}; typedef NSUInteger SectionType;

@protocol FTSection <NSObject>

+ (SectionType) sectionType;
+ (NSString*) title;
+ (NSString*) goalTitle:(int)goal;
+ (NSString*) logTitle:(int)goal;
+ (UIColor*) mainColor:(int)goal;
+ (UIColor*) lightColor:(int)goal;
+ (UIColor*) highLightColor:(int)goal;
+ (UIColor*) darkColor:(int)goal;
+ (NSString*) navBarBkg:(int)goal;
+ (UIColor*) navBarTextColor:(int)goal;
+ (UIColor*) footerColor:(int)goal;

+ (NSString*) bannerReloadImageFilename;


// circular view
+ (NSString*) circularImageFilename;
+ (NSString*) circularInfoImageFilename;
+ (NSString*) circularDoubleInfoImageFilename;
+ (NSString*) circularMaxLimitImageFilename;
+ (UIColor*) circularOverlayTextColor;
+ (UIColor*) circularArrowTextColor;
+ (UIColor*) circularBottomTextColor;
+ (NSString*) circularTopFixImageFilename;
+ (NSString*) circularTopFixNotTappableImageFilename;
+ (NSString*) rightFixImageFilename;

+ (NSString*) verticalDottedLineImageFilename;


+ (NSString*)unitByGoalType:(int)goalType;

//GOAL
+ (int)getCurrentGoal;
+ (void)setCurrentGoal:(int)goalType;
+ (FTHeaderConf*)headerConfWithGoalType:(int)goalType;
+ (FTGoalData*)goalDataWithType:(int)goalType;
+ (void)setGoalData:(FTGoalData*)goalDataObj;
+ (FTGoalData*)defaultGoalDataWithType:(int)goalType;
+ (FTGoalData*)lastGoalData;
+ (void)loadGoals;
+ (void)saveGoalData:(FTGoalData*)goalData;
+ (NSString*)infoOverlayScreenText:(int)goal;
+ (void)updateGoalData:(FTGoalData*)goalData;
+ (NSMutableArray*)goalEntries;

//REMINDER
+ (FTReminderData*)defaultReminderWithGoal:(int)goal;
+ (void)saveReminder:(FTReminderData*)reminder;
+ (FTReminderData*)loadReminderWithGoal:(int)goal;


//LOG
+ (FTHeaderConf*)headerConfForLogWithGoalType:(int)goalType;
+ (FTLogData*)defaultLogDataWithGoalType:(int)goalType;
+ (FTLogData*)lastLogDataWithGoalType:(int)goalType;
+ (FTLogData*)logDataWithGoalType:(int)goalType withDate:(NSString*)dateValue;
+ (void)saveLogData:(FTLogData*)logData;
+ (NSMutableArray*)loadEntries:(int)dateType withGoalData:(FTGoalData*)goalData;
+ (float)maxLogValueWithGoal:(int)goal;
+ (float)minLogValueWithGoal:(int)goal;
+ (float)maxLogValue2WithGoal:(int)goal;
+ (float)minLogValue2WithGoal:(int)goal;
+ (NSMutableArray*)loadEntriesWithGoalData:(FTGoalData*)goalData;
+ (void)deleteLog:(int)logId;

+ (int)sliderIncrementByGoal:(int)goal;

//NOTIFICATION
+ (FTNotification*)nextBannerNotification;
+ (FTNotification*)nextLocalNotificationWithGoal:(int)goal withDateType:(int)dateType  withLast:(int)lastLocalNot;

//INFO
+ (NSString*) infoHomeImageFilename;
+ (NSString*) infoGoalImageFilename;
+ (NSString*) infoLogImageFilename;

@end
