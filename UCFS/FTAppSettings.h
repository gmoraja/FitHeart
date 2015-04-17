//
//  FTAppSettings.h
//  FitHeart
//
//  Created by Bitgears on 21/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTAppSettings : NSObject

+(void)reset;

+(BOOL)isEulaConfirmed;
+(void)confirmEula;
+(BOOL)isStudyIdConfirmed;
+(void)confirmStudyId;
+(BOOL)isOrientationConfirmed;
+(void)confirmOrientation;

+(BOOL)isProvidingDataEnabled;
+(void)setProvidingData:(BOOL)provide;

+(int)getStudyId;
+(void)setStudyId:(int)studyId;
+(BOOL)getStartNewWeek;
+(void)setStartNewWeek:(BOOL)value;

+(int)getCongratMsgGoalReachedIndex;
+(void)setCongratMsgGoalReachedIndex:(int)index;
+(int)getCongratMsgGoalNotReachedIndex;
+(void)setCongratMsgGoalNotReachedIndex:(int)index;
+(int)getEducationMsgGoalReachedIndex;
+(void)setEducationMsgGoalReachedIndex:(int)index;
+(int)getEducationMsgGoalNotReachedIndex;
+(void)setEducationMsgGoalNotReachedIndex:(int)index;
+(int)getMoodMessageIndex;
+(void)setMoodMessageIndex:(int)index;
+(int)getMoodReinforcementMessageIndex;
+(void)setMoodReinforcementMessageIndex:(int)index;
+(int)getMoodActivationMessageIndex;
+(void)setMoodActivationMessageIndex:(int)index;
+(int)getMoodInspirationalMessageIndex;
+(void)setMoodInspirationalMessageIndex:(int)index;

@end
