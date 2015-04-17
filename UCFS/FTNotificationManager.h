//
//  FTNotificationManager.h
//  FitHeart
//
//  Created by Bitgears on 23/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTReminderData.h"
#import "FTNotification.h"
#import "FTNotificationAction.h"

@interface FTNotificationManager : NSObject {
    
}

+ (void)scheduleNotification:(FTNotification*)notification withReminder:(FTReminderData*)reminder;
+ (FTNotificationAction*)processNotification:(UILocalNotification*)localNotif;
+ (void)listNotification ;


@end
