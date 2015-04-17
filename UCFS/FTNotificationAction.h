//
//  FTNotificationAction.h
//  FitHeart
//
//  Created by Bitgears on 27/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTNotificationAction : NSObject {
    
    NSString* actionMessage;
    int actionSection;
    int actionGoal;
    int actionScreen;
    int actionItem;
}

@property (strong) NSString* actionMessage;
@property (assign) int actionSection;
@property (assign) int actionGoal;
@property (assign) int actionScreen;
@property (assign) int actionItem;

@end
