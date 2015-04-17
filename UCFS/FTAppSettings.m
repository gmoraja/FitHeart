//
//  FTAppSettings.m
//  FitHeart
//
//  Created by Bitgears on 21/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTAppSettings.h"
#import "FTDatabase.h"

static NSString* SETTING_EULA = @"EulaConfirmed";
static NSString* SETTING_STUDYID = @"StudyIdConfirmed";
static NSString* SETTING_ORIENTATION = @"OrientationConfirmed";
static NSString* SETTING_PROVIDEDATA = @"ProvideDataConfirmed";
static NSString* SETTING_CONGRAT_MSG_GOALREACHED_INDEX = @"congratMsgGoalReachedIndex";
static NSString* SETTING_CONGRAT_MSG_GOALNOTREACHED_INDEX = @"congratMsgGoalNotReachedIndex";
static NSString* SETTING_EDUCATION_MSG_GOALREACHED_INDEX = @"educationMsgGoalReachedIndex";
static NSString* SETTING_EDUCATION_MSG_GOALNOTREACHED_INDEX = @"educationMsgGoalNotReachedIndex";
static NSString* SETTING_MOOD_MESSAGE_INDEX = @"moodMessageIndex";
static NSString* SETTING_MOOD_REINFORCEMENT_MESSAGE_INDEX = @"moodReinforcementMessageIndex";
static NSString* SETTING_MOOD_INSPIRATIONAL_MESSAGE_INDEX = @"moodInspirationalMessageIndex";
static NSString* SETTING_MOOD_ACTIVATION_MESSAGE_INDEX = @"moodActivationMessageIndex";
static NSString* SETTING_STUDYID_VALUE = @"StudyIdValue";
static NSString* SETTING_STARTNEWWEEK_VALUE = @"StartNewWeek";


@implementation FTAppSettings

+(void)reset {
    //reset database
    FTDatabase *db = [FTDatabase getInstance];
    [db resetDatabase];
    
    //reset preferences
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SETTING_EULA];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SETTING_STUDYID];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SETTING_ORIENTATION];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SETTING_PROVIDEDATA];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:SETTING_CONGRAT_MSG_GOALREACHED_INDEX];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:SETTING_CONGRAT_MSG_GOALNOTREACHED_INDEX];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:SETTING_EDUCATION_MSG_GOALREACHED_INDEX];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:SETTING_EDUCATION_MSG_GOALNOTREACHED_INDEX];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:SETTING_MOOD_MESSAGE_INDEX];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:SETTING_MOOD_REINFORCEMENT_MESSAGE_INDEX];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:SETTING_MOOD_INSPIRATIONAL_MESSAGE_INDEX];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:SETTING_MOOD_ACTIVATION_MESSAGE_INDEX];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:SETTING_STUDYID_VALUE];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:SETTING_STARTNEWWEEK_VALUE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //reset notifications
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

+(BOOL)isEulaConfirmed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_EULA];
}

+(void)confirmEula {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SETTING_EULA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isStudyIdConfirmed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_STUDYID];
}

+(void)confirmStudyId {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SETTING_STUDYID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isOrientationConfirmed {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_ORIENTATION];
}

+(void)confirmOrientation {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:SETTING_ORIENTATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(BOOL)isProvidingDataEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_PROVIDEDATA];
}

+(void)setProvidingData:(BOOL)provide {
    [[NSUserDefaults standardUserDefaults] setBool:provide forKey:SETTING_PROVIDEDATA];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getCongratMsgGoalReachedIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:SETTING_CONGRAT_MSG_GOALREACHED_INDEX];
}

+(void)setCongratMsgGoalReachedIndex:(int)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SETTING_CONGRAT_MSG_GOALREACHED_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getCongratMsgGoalNotReachedIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:SETTING_CONGRAT_MSG_GOALNOTREACHED_INDEX];
}

+(void)setCongratMsgGoalNotReachedIndex:(int)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SETTING_CONGRAT_MSG_GOALNOTREACHED_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getEducationMsgGoalReachedIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:SETTING_EDUCATION_MSG_GOALREACHED_INDEX];
}

+(void)setEducationMsgGoalReachedIndex:(int)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SETTING_EDUCATION_MSG_GOALREACHED_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getEducationMsgGoalNotReachedIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:SETTING_EDUCATION_MSG_GOALNOTREACHED_INDEX];
}

+(void)setEducationMsgGoalNotReachedIndex:(int)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SETTING_EDUCATION_MSG_GOALNOTREACHED_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getMoodMessageIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:SETTING_MOOD_MESSAGE_INDEX];
}

+(void)setMoodMessageIndex:(int)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SETTING_MOOD_MESSAGE_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getMoodReinforcementMessageIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:SETTING_MOOD_REINFORCEMENT_MESSAGE_INDEX];
}

+(void)setMoodReinforcementMessageIndex:(int)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SETTING_MOOD_REINFORCEMENT_MESSAGE_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(int)getMoodActivationMessageIndex {
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:SETTING_MOOD_ACTIVATION_MESSAGE_INDEX];
}

+(void)setMoodActivationMessageIndex:(int)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SETTING_MOOD_ACTIVATION_MESSAGE_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(int)getMoodInspirationalMessageIndex {
    return [[NSUserDefaults standardUserDefaults] integerForKey:SETTING_MOOD_INSPIRATIONAL_MESSAGE_INDEX];
}

+(void)setMoodInspirationalMessageIndex:(int)index {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:SETTING_MOOD_INSPIRATIONAL_MESSAGE_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(int)getStudyId {
    return (int)([[NSUserDefaults standardUserDefaults] integerForKey:SETTING_STUDYID_VALUE]);
}

+(void)setStudyId:(int)studyId {
    [[NSUserDefaults standardUserDefaults] setInteger:studyId forKey:SETTING_STUDYID_VALUE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getStartNewWeek {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SETTING_STARTNEWWEEK_VALUE];
}

+(void)setStartNewWeek:(BOOL)value {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:SETTING_STARTNEWWEEK_VALUE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




@end
