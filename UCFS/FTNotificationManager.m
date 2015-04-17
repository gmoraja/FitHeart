//
//  FTNotificationManager.m
//  FitHeart
//
//  Created by Bitgears on 23/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTNotificationManager.h"
#import "UCFSUtil.h"
#import "FTNotification.h"


@implementation FTNotificationManager


+ (void)scheduleNotification:(FTNotification*)notification withReminder:(FTReminderData*)reminder {
    if (reminder!=nil) {
        //remove existing notification by section and goal
        [self removeNotification:notification];
        if (reminder.frequency!=TIME_FREQUENCY_NONE) {
            //schedule new notification by section and goal
            [self addNotification:notification withReminder:reminder ];
        }
    }
}


+ (NSDate*)fireDateWithReminder:(FTReminderData*)reminder {
    if (reminder!=nil && reminder.frequency!=TIME_FREQUENCY_NONE) {
        
        NSDateComponents *currComps = [[NSCalendar currentCalendar] components: NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekOfYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        
        [currComps setHour: [UCFSUtil hour24From12:reminder.hours withType:reminder.amPm] ];
        [currComps setMinute:reminder.minutes];
        [currComps setSecond:0];

        NSDate* fireDate = nil;
        if (reminder.frequency==TIME_FREQUENCY_DAILY) {
            NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
            
            fireDate = [[NSCalendar currentCalendar] dateFromComponents:currComps];
            dayComponent.day = 1;
            fireDate = [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:fireDate options:0];
        }
        if (reminder.frequency==TIME_FREQUENCY_WEEKLY) {
            NSDate* tempDate = [self getFireDateForDayOfWeek:reminder.dayOfWeek];
            NSDateComponents *fireDateComponents = [[NSCalendar currentCalendar]
                                                    components: NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                    fromDate:tempDate];
            [fireDateComponents setHour: [UCFSUtil hour24From12:reminder.hours withType:reminder.amPm] ];
            [fireDateComponents setMinute:reminder.minutes];
            [fireDateComponents setSecond:0];
            
            fireDate = [[NSCalendar currentCalendar] dateFromComponents:fireDateComponents];
            // The day could be today but time is in past. If so, move ahead to next week
            if(fireDate.timeIntervalSinceNow < 0) {
                fireDate = [fireDate dateByAddingTimeInterval:60 * 60 * 24 * 7];
            }
        }
        if (reminder.frequency==TIME_FREQUENCY_MONTHLY) {
            [currComps setDay:reminder.dayOfMonth];
            fireDate = [[NSCalendar currentCalendar] dateFromComponents:currComps];
            // The day could be today but time is in past. If so, move ahead to next week
            if(fireDate.timeIntervalSinceNow < 0) {
                NSDateComponents *monthComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:fireDate];
                monthComponent.month = 1;
                fireDate = [[NSCalendar currentCalendar] dateByAddingComponents:monthComponent toDate:fireDate options:0];
            }
        }

        return fireDate;
    }
    
    return nil;
}

+ (NSDictionary*)userInfoWithNotification:(FTNotification*)notification {
    if (notification!=nil)
        return   [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:notification.index], @"index",
                    [NSNumber numberWithInt:notification.section], @"section",
                    [NSNumber numberWithInt:notification.goal], @"goal",
                    [NSNumber numberWithInt:notification.datetype], @"datetype",
                    [NSNumber numberWithInt:notification.action.actionSection], @"actionSection",
                    [NSNumber numberWithInt:notification.action.actionGoal], @"actionGoal",
                    [NSNumber numberWithInt:notification.action.actionScreen], @"actionScreen",
                    [NSNumber numberWithInt:notification.action.actionItem], @"actionItem",
                    nil
                  ];
    else
        return nil;
    
}

+ (void)addNotification:(FTNotification*)notification withReminder:(FTReminderData*)reminder {
    
    //NSDate* fireDate = [[NSDate date] dateByAddingTimeInterval:60];
    NSDate* fireDate = [self fireDateWithReminder:reminder];
    NSLog(@"firedate=%@",[UCFSUtil formatDateTime:fireDate]);

    if (fireDate!=nil) {
        // Schedule the notification
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = fireDate;

        //localNotif.timeZone = [NSTimeZone defaultTimeZone];
        
        // Notification details
        localNotif.alertBody = notification.message;
        // Set the action button
        localNotif.alertAction = @"View";
        
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        //localNotif.applicationIconBadgeNumber = 1;
        
        //user data
        localNotif.userInfo = [self userInfoWithNotification:notification];
        
        //repeat
        switch (reminder.frequency) {
            case TIME_FREQUENCY_DAILY:
                localNotif.repeatInterval = NSDayCalendarUnit;
                break;
            case TIME_FREQUENCY_WEEKLY:
                localNotif.repeatInterval = NSWeekCalendarUnit;
                break;
            case TIME_FREQUENCY_MONTHLY:
                localNotif.repeatInterval = NSMonthCalendarUnit;
                break;
        }
        
        // Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        
        NSLog(@"NOTIFICATION ADDED");
        [self listNotification];
    }
    
}



+(void)removeNotification:(FTNotification*)notification {
    NSArray* notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if (notifications!=nil)
        for (int i=0; i<[notifications count]; i++) {
            UILocalNotification *localNotif = [notifications objectAtIndex:i];
            NSNumber* notifSection = (NSNumber*)[localNotif.userInfo objectForKey:@"section"];
            NSNumber* notifGoal = (NSNumber*)[localNotif.userInfo objectForKey:@"goal"];
            if (notification.section==[notifSection intValue] && notification.goal==[notifGoal intValue]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
                NSLog(@"NOTIFICATION REMOVED");
                [self listNotification];
            }
        }
 }

+ (void)listNotification {
    NSArray* notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"num notifications=%lu", (unsigned long)[notifications count]);
    for (int i=0; i<[notifications count]; i++) {
        UILocalNotification *localNotif = [notifications objectAtIndex:i];
        NSNumber* section = (NSNumber*)[localNotif.userInfo objectForKey:@"section"];
        NSNumber* goal = (NSNumber*)[localNotif.userInfo objectForKey:@"goal"];
        
        NSLog(@"Notif[ section=%i, goal=%i, fire=%@ ]", [section intValue] , [goal intValue], [UCFSUtil formatDateTimeGmt:localNotif.fireDate] );
    }
}

+ (FTNotificationAction*)processNotification:(UILocalNotification*)localNotif {
    FTNotification* notif = nil;
    FTNotificationAction* action = nil;

    if (localNotif!=nil) {
        
        notif = [[FTNotification alloc] init];
        notif.section = [[localNotif.userInfo objectForKey:@"section"] intValue];
        notif.goal = [[localNotif.userInfo objectForKey:@"goal"] intValue];
        
        //get action data
        NSNumber* actionSection = (NSNumber*)[localNotif.userInfo objectForKey:@"actionSection"];
        NSNumber* actionGoal = (NSNumber*)[localNotif.userInfo objectForKey:@"actionGoal"];
        NSNumber* actionScreen = (NSNumber*)[localNotif.userInfo objectForKey:@"actionScreen"];
        NSNumber* actionItem = (NSNumber*)[localNotif.userInfo objectForKey:@"actionItem"];
        if (actionSection!=nil && actionGoal!=nil && actionScreen!=nil) {
            action = [[FTNotificationAction alloc] init];
            action.actionSection = [actionSection intValue];
            action.actionGoal = [actionGoal intValue];
            action.actionScreen = [actionScreen intValue];
            action.actionItem = [actionItem intValue];
        }
        
        //remove notif
        [self removeNotification:notif];
        //reschedule notification 
        NSNumber* section = (NSNumber*)[localNotif.userInfo objectForKey:@"section"];
        NSNumber* goal = (NSNumber*)[localNotif.userInfo objectForKey:@"goal"];
        NSNumber* datetype = (NSNumber*)[localNotif.userInfo objectForKey:@"datetype"];
        NSNumber* index = (NSNumber*)[localNotif.userInfo objectForKey:@"index"];
        if (section!=nil && goal!=nil && datetype!=nil ) {
            
            int lastIndex = 0;
            if (index!=nil) lastIndex = [index intValue];
            FTNotification* nextNotification = [UCFSUtil nextLocalNotificationWithSection:[section intValue]
                                                                             withGoal:[goal intValue]
                                                                         withDateType:[datetype intValue]
                                                                             withLast:lastIndex
                                            ];
            FTReminderData* reminder = [UCFSUtil remiderWithSection:[section intValue] withGoal:[goal intValue]];
            
            if (nextNotification!=nil && reminder!=nil) {
                NSLog(@"rescheduling notification");
                nextNotification.section = [section intValue];
                nextNotification.goal = [goal intValue];
                [self addNotification:nextNotification withReminder:reminder ];
            }
        }

        
    }
    return action;
    
}

+ (NSDate *) getFireDateForDayOfWeek:(NSInteger)desiredWeekday  // 1:Sunday - 7:Saturday
{
    NSRange weekDateRange = [[NSCalendar currentCalendar] maximumRangeOfUnit:NSCalendarUnitWeekday];
    NSInteger daysInWeek = weekDateRange.length - weekDateRange.location + 1;
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSInteger currentWeekday = dateComponents.weekday;
    NSInteger differenceDays = (desiredWeekday - currentWeekday + daysInWeek) % daysInWeek;
    
    NSDateComponents *daysComponents = [[NSDateComponents alloc] init];
    daysComponents.day = differenceDays;
    NSDate *fireDate = [[NSCalendar currentCalendar] dateByAddingComponents:daysComponents toDate:[NSDate date] options:0];

    return fireDate;
}



@end
