//
//  FTSalesForce.h
//  FitHeart
//
//  Created by Bitgears on 10/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKSforce.h"
#import "FTLogData.h"
#import "FTGoalData.h"
#import "FTReminderData.h"

@interface FTSalesForce : NSObject {

}

+ (FTSalesForce*)getInstance;
- (NSString*)createIfNotExistsUser:(int)studyId;
- (BOOL)insertLog:(FTLogData*)logData withUser:(int)studyId;
- (BOOL)insertGoal:(FTGoalData*)logData withUser:(int)studyId;

@end
