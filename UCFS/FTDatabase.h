//
//  FitnessDatabase.h
//  FitHeart
//
//  Created by Bitgears on 29/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "FTGoalData.h"
#import "FTLogData.h"
#import "FTNoteData.h"

enum {
    DB_AGGREGATION_NONE            = 0,
    DB_AGGREGATION_SUM             = 1,
    DB_AGGREGATION_AVERAGE         = 2
    
}; typedef NSUInteger FTDatabaseAggregationType;

@interface FTDatabase : NSObject {
    sqlite3 *database;
    NSString *databasePath;
}

+ (FTDatabase*)getInstance;
-(void) createDatabase;
-(void) resetDatabase;

-(void) insertGoal:(FTGoalData*)goal;
-(FTGoalData*)selectLastGoalWithSection:(int)section;
-(void) updateGoal:(FTGoalData*)goal;

-(void) insertReminder:(FTReminderData*)reminder;
-(FTReminderData*) selectReminderWithSection:(int)section withGoal:(int)goal;

-(void) insertLog:(FTLogData*)log;
-(void) deleteLog:(int)logId;
-(void) updateLog:(FTLogData*)log;
-(FTLogData*)selectLastLogWithSection:(int)section withGoal:(int)goalType;
-(FTLogData*)selectLogWithSection:(int)section withGoal:(int)goalType withId:(int)uniqueid;
-(FTLogData*)selectLogWithSection:(int)section withGoal:(int)goalType withDate:(NSString*)dateStr;
-(NSMutableArray*) selectLogGroupedByDate:(int)dateType withGoal:(int)goalType withSection:(int)section withAggregation:(FTDatabaseAggregationType)aggregation;
-(float)selectMaxLogValueWithSection:(int)section withGoal:(int)goalType onValue2:(BOOL)onValue2;
-(float)selectMinLogValueWithSection:(int)section withGoal:(int)goalType onValue2:(BOOL)onValue2;
-(NSMutableArray*) selectAllLogWithSection:(int)section withGoal:(int)goalType;
-(NSMutableArray*) selectAllLogsWithGoal:(FTGoalData*)goalData;
-(NSMutableArray*) selectAllDateLogWithSection:(int)section withGoal:(int)goalType;
-(NSMutableArray*) selectGoalGroupedDataWithSection:(int)section;
-(NSMutableArray*) selectLogsGroupedDataWithGoal:(FTGoalData*)goalData;

-(NSMutableArray*) selectAllGoalToSync;
-(NSMutableArray*) selectAllLogToSync;


@end
