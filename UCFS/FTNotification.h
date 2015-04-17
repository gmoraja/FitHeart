//
//  FTNotification.h
//  FitHeart
//
//  Created by Bitgears on 20/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTNotificationAction.h"

@interface FTNotification : NSObject {
    int uniqueid;
    int index;
    int section;
    int goal;
    int datetype;
    NSString* message;
    FTNotificationAction* action;

}

@property (assign) int uniqueid;
@property (assign) int index;
@property (assign) int section;
@property (assign) int goal;
@property (assign) int datetype;
@property (strong) NSString* message;
@property (strong) FTNotificationAction* action;



@end
