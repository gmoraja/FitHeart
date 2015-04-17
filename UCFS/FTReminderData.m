//
//  FTReminderData.m
//  FitHeart
//
//  Created by Bitgears on 03/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTReminderData.h"

@implementation FTReminderData

@synthesize reminderId;
@synthesize section;
@synthesize goalType;
@synthesize frequency;
@synthesize dayOfWeek;
@synthesize hours;
@synthesize minutes;
@synthesize amPm;
@synthesize dayOfMonth;
@synthesize uploadedToServer;


- (id)initWithSection:(int)sec withGoal:(int)goal asDaily:(BOOL)asDaily {
    
    self = [super init];
    if (self) {
        section = sec;
        goalType = goal;
        
        NSDate *today = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents* dateComp = [calendar components:kCFCalendarUnitHour | NSCalendarUnitMinute | NSWeekdayCalendarUnit fromDate:today];
        
        if (asDaily) {
            frequency = TIME_FREQUENCY_DAILY;
        }
        else {
            frequency = TIME_FREQUENCY_NONE;
        }
        
        dayOfWeek = (int)[dateComp weekday];
        dayOfMonth = 1;
        hours = 9;
        minutes = 0;
        amPm = 0;
        uploadedToServer = FALSE;
    }
    return self;

}

@end
