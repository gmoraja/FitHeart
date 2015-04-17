//
//  MoodSection.h
//  FitHeart
//
//  Created by Bitgears on 19/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTSection.h"
#import "FTNoteData.h"

extern NSString     *const UCFS_MoodView_NavBar_Title;
extern NSString     *const UCFS_MoodView_NavBar_Bkg;
extern NSString     *const UCFS_MoodSimplePleasureView_NavBar_Title;
extern NSString     *const UCFS_MoodVWriteANoteView_NavBar_Title;
extern NSString     *const UCFS_MoodMindfulnessView_NavBar_Title;
extern NSString     *const UCFS_MoodCallAFriendView_NavBar_Title;
extern NSString     *const UCFS_MoodView_Picker_Simple_Bkg;
extern NSString     *const UCFS_MoodReminderView_NavBar_Title;

enum {
    MOOD_GOAL_SIMPLEPLEASURE        = 0,
    MOOD_GOAL_WRITEANOTE            = 1,
    MOOD_GOAL_MINDFULNESS           = 2,
    MOOD_GOAL_CALLAFRIEND           = 3
    
}; typedef NSUInteger MoodGoal;

enum {
    MOOD_SIMPLEPLEASURE_POSITIVEEVENTS              = 0,
    MOOD_SIMPLEPLEASURE_GRATITUDE                   = 1,
    MOOD_SIMPLEPLEASURE_SILVERLINING                = 2,
    MOOD_SIMPLEPLEASURE_PERSONALSTRENGHTS           = 3,
    MOOD_SIMPLEPLEASURE_ACTSOFKINDNESS              = 4
    
}; typedef NSUInteger MoodSimplePleasures;

@interface MoodSection : NSObject<FTSection>  {
    MoodGoal *currentGoal;
}


+ (NSString*)simplePleasureTextPrompt:(MoodSimplePleasures)sp;

@end
