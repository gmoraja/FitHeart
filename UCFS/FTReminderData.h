//
//  FTReminderData.h
//  FitHeart
//
//  Created by Bitgears on 03/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    TIME_FREQUENCY_NONE            = 0,
    TIME_FREQUENCY_DAILY           = 1,
    TIME_FREQUENCY_WEEKLY          = 2,
    TIME_FREQUENCY_MONTHLY         = 3
    
}; typedef NSUInteger FTTimeFrequency;

@interface FTReminderData : NSObject {
    int reminderId;
    int section;
    int goalType;
    FTTimeFrequency frequency;
    int dayOfWeek;
    int hours;
    int minutes;
    int amPm;
    int dayOfMonth;
    BOOL uploadedToServer;
}

@property (nonatomic,assign) int reminderId;
@property (nonatomic,assign) int section;
@property (nonatomic,assign) int goalType;
@property (nonatomic,assign) FTTimeFrequency frequency;
@property (nonatomic,assign) int dayOfWeek;
@property (nonatomic,assign) int hours;
@property (nonatomic,assign) int minutes;
@property (nonatomic,assign) int amPm;
@property (nonatomic,assign) int dayOfMonth;
@property (nonatomic,assign) BOOL uploadedToServer;

- (id)initWithSection:(int)sec withGoal:(int)goal asDaily:(BOOL)asDaily;


@end
