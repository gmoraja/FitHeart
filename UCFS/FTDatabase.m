//
//  FitnessDatabase.m
//  FitHeart
//
//  Created by Bitgears on 29/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTDatabase.h"
#import "FTGoalData.h"
#import "FTLogData.h"
#import "FTLogGroupedData.h"
#import "FTDateLogData.h"
#import "UCFSUtil.h"
#import "FTGoalGroupedData.h"

//**** DATA TYPE
const char *createDataTypeQuery = "CREATE TABLE IF NOT EXISTS FT_DATATYPE (goaltypeId INTEGER PRIMARY KEY, name TEXT, unit INTEGER)";
const char *insertDataTypeQuery = "INSERT INTO FT_DATATYPE (goaltypeId, name, unit) VALUES (?,?,?)";

//**** GOAL
const char *createGoalQuery = "CREATE TABLE IF NOT EXISTS FT_GOAL (goalId INTEGER PRIMARY KEY AUTOINCREMENT, section INTEGER, goalValue REAL, valueIsFloat INTEGER, insertDate INTEGER, startDate INTEGER, ended INTEGER, reached INTEGER, end_mood INTEGER, dataType INTEGER, uploadedToServer INTEGER)";
const char *insertGoalQuery = "INSERT INTO FT_GOAL (section, goalValue, valueIsFloat, insertDate, startDate, ended, reached, end_mood, dataType, uploadedToServer) VALUES (?,?,?,?,?,?,?,?,?,?)";
const char *updateGoalQuery = "UPDATE FT_GOAL SET goalValue=?, startDate=?, ended=?, reached=?, end_mood=?, uploadedToServer=? WHERE goalId=?";
const char *selectAllGoals = "SELECT * FROM FT_GOAL WHERE section=? ORDER BY startDate DESC ";
const char *selectAllGoalToSync = "SELECT * FROM FT_GOAL WHERE uploadedToServer=0";
const char *selectLastGoalQuery = "SELECT * FROM FT_GOAL WHERE section=? ORDER BY goalId DESC LIMIT 1";


//**** REMINDER
const char *createReminderQuery = "CREATE TABLE IF NOT EXISTS FT_REMINDER (reminderId INTEGER PRIMARY KEY AUTOINCREMENT, section INTEGER, goalType INTEGER, frequency INTEGER, dayofweek INTEGER, dayofmonth INTEGER, hours INTEGER, minutes INTEGER, ampm INTEGER, uploadedToServer INTEGER)";
const char *insertReminderQuery = "INSERT INTO FT_REMINDER (section, goalType, frequency, dayofweek, dayofmonth, hours, minutes, ampm, uploadedToServer) VALUES (?,?,?,?,?,?,?,?,?)";
const char *updateReminderQuery = "UPDATE FT_REMINDER SET frequency=?, dayofweek=?, dayofmonth=?, hours=?, minutes=?, ampm=?, uploadedToServer=? WHERE reminderId=?";
const char *selectReminderQuery = "SELECT * FROM FT_REMINDER WHERE section=? and goalType=? ORDER BY reminderId DESC";
const char *selectReminderByIdQuery = "SELECT * FROM FT_REMINDER WHERE reminderId=?";


//**** LOG
const char *createLogQuery = "CREATE TABLE IF NOT EXISTS FT_LOG (logId INTEGER PRIMARY KEY AUTOINCREMENT, section INTEGER, logValue REAL, logValue2 REAL, insertDate INTEGER, dataType INTEGER, activity INTEGER, effort INTEGER, meal INTEGER, uploadedToServer INTEGER, goalId INTEGER, deleted INTEGER)";
const char *insertLogQuery = "INSERT INTO FT_LOG (section, logValue, logValue2, insertDate, dataType, activity, effort, meal, uploadedToServer, goalId, deleted) VALUES (?,?,?,?,?,?,?,?,0,?,0)";
const char *updateLogQuery = "UPDATE FT_LOG SET logValue=?, logValue2=?, insertDate=?, activity=?, effort=?, meal=?, uploadedToServer=?, deleted=? WHERE logId=? ";
const char *deleteLogQuery = "UPDATE FT_LOG SET deleted=1, uploadedToServer=0 WHERE logId=?";

const char *selectLogQuery = "SELECT * FROM FT_LOG WHERE logId=? AND deleted=0 ";
const char *selectLastLogQuery = "SELECT * FROM FT_LOG WHERE section=? and dataType=? AND deleted=0 ORDER BY logId DESC LIMIT 1";
const char *selectMaxLogQuery = "SELECT max(logValue) FROM FT_LOG WHERE section=? and dataType=? AND deleted=0 ";
const char *selectMinLogQuery = "SELECT min(logValue) FROM FT_LOG WHERE section=? and dataType=? AND deleted=0";
const char *selectMaxLog2Query = "SELECT max(logValue2) FROM FT_LOG WHERE section=? and dataType=? AND deleted=0";
const char *selectMinLog2Query = "SELECT min(logValue2) FROM FT_LOG WHERE section=? and dataType=? AND deleted=0";
const char *selectLogByDateQuery = "SELECT * FROM FT_LOG WHERE section=? AND dataType=?  AND deleted=0 AND strftime('%Y-%m-%d', insertDate, 'unixepoch')=? ";
const char *selectLastLogByDateQuery = "SELECT uniqueid FROM FT_LOG WHERE section=? AND dataType=?  AND deleted=0 AND strftime('%Y-%m-%d', insertDate, 'unixepoch')=? ORDER BY logId DESC LIMIT 1";


const char *selectAllLogQuery = "SELECT * FROM FT_LOG WHERE section=? and dataType=? AND deleted=0 ORDER BY insertDate DESC";
const char *selectLogsByWeekQuery = "SELECT * FROM FT_LOG WHERE section=? AND dataType=?  AND deleted=0 AND insertDate BETWEEN ? AND ? ORDER BY insertDate DESC";

const char *selectAllLogsByGoalQuery = "SELECT * FROM FT_LOG WHERE goalId = ?  AND deleted=0 ORDER BY insertDate DESC";
const char *selectAllLogToSyncQuery = "SELECT * FROM FT_LOG WHERE uploadedToServer=0";



const char *resetGoalQuery = "DELETE FROM FT_GOAL";
const char *resetReminderQuery = "DELETE FROM FT_REMINDER";
const char *resetLogQuery = "DELETE FROM FT_LOG";





@implementation FTDatabase

static FTDatabase *instance;

+ (FTDatabase*)getInstance {
    if (instance == nil) {
        instance = [[FTDatabase alloc] init];
    }
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"fithearth"
                                                             ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

-(void) createDatabase {
    
    NSArray *dirPaths;
    NSString *docsDirPath;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDirPath = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDirPath stringByAppendingPathComponent: @"fithearth.db"]];
    
    NSLog(@"database path is : %@",databasePath);
    
    //Now create the database
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
        {
            char *errMsg;
            
            if (sqlite3_exec(database, createGoalQuery, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create FT_GOAL table");
            }
            
            if (sqlite3_exec(database, createReminderQuery, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create FT_REMINDER table");
            }

            if (sqlite3_exec(database, createLogQuery, NULL, NULL, &errMsg) != SQLITE_OK) {
                NSLog(@"Failed to create FT_LOG table");
            }

            
            sqlite3_close(database);
            
        } else {
            
            NSLog(@"Failed to open/create database");
            
        }
    }
    else{
        NSLog(@"Database already exists");
    }
}

-(void) resetDatabase {
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        char *errMsg;
        if (sqlite3_exec(database, resetGoalQuery, NULL, NULL, &errMsg) == SQLITE_OK) {
            NSLog(@"FT_GOAL table reset");
        }
        if (sqlite3_exec(database, resetReminderQuery, NULL, NULL, &errMsg) == SQLITE_OK) {
            NSLog(@"FT_REMINDER table reset");
        }
        if (sqlite3_exec(database, resetLogQuery, NULL, NULL, &errMsg) == SQLITE_OK) {
            NSLog(@"FT_LOG table reset");
        }
        sqlite3_close(database);
    }
}




-(void) insertGoal:(FTGoalData*)goal {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        bool exists = FALSE;

        sqlite3_stmt *selectStatement;
        NSString *selectQuery = [NSString stringWithFormat:@"SELECT count(*) FROM FT_GOAL WHERE goalId=? "];
        if(sqlite3_prepare_v2(database, [selectQuery UTF8String], -1, &selectStatement, NULL) == SQLITE_OK) {
            sqlite3_bind_int(selectStatement, 1, goal.goalId);
            if (sqlite3_step(selectStatement) == SQLITE_ROW) {
                int val = sqlite3_column_int(selectStatement, 0);
                exists = (val>0);
            }
        }
        sqlite3_finalize(selectStatement);
        
        if (!exists) {
            //create insertStatement
            sqlite3_stmt *insertStatement;
            
            if(sqlite3_prepare_v2(database, insertGoalQuery, -1, &insertStatement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            }
            // insert values
            //section, goalValue, valueIsFloat, insertDate, startDate, ended, reached, end_mood, dataType, uploadedToServer
            sqlite3_bind_int(insertStatement, 1, goal.section);
            sqlite3_bind_double(insertStatement, 2, goal.goalValue);
            sqlite3_bind_int(insertStatement, 3, (goal.valueIsFloat ? 1 : 0));
            if (goal.insertDate==nil) goal.insertDate = [NSDate date];
            sqlite3_bind_int(insertStatement, 4, [goal.insertDate timeIntervalSince1970]);
            sqlite3_bind_int(insertStatement, 5, [goal.startDate timeIntervalSince1970]);
            sqlite3_bind_int(insertStatement, 6, (goal.ended ? 1 : 0));
            sqlite3_bind_int(insertStatement, 7, (goal.reached ? 1 : 0));
            sqlite3_bind_int(insertStatement, 8, goal.end_mood);
            sqlite3_bind_int(insertStatement, 9, goal.dataType.goaltypeId);
            sqlite3_bind_int(insertStatement, 10, (goal.uploadedToServer ? 1 : 0) );
            
            if (sqlite3_step(insertStatement )== SQLITE_DONE) {
                NSLog(@"Goal sucessfully saved : new item id is %lld",sqlite3_last_insert_rowid(database));
            }
            else{
                NSLog(@"Failed to add Goal");
            }
            sqlite3_finalize(insertStatement);
        }
        else {
            //create updateStatement
            //UPDATE FT_GOAL SET goalValue=?, startDate=?, ended=?, reached=?, end_mood=? WHERE goalId=?
            sqlite3_stmt *updateStatement;
            
            if(sqlite3_prepare_v2(database, updateGoalQuery, -1, &updateStatement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            }
            // insert values
            sqlite3_bind_double(updateStatement, 1, goal.goalValue);
            sqlite3_bind_int(updateStatement, 2, [goal.startDate timeIntervalSince1970]);
            sqlite3_bind_int(updateStatement, 3, goal.ended);
            sqlite3_bind_int(updateStatement, 4, goal.reached);
            sqlite3_bind_int(updateStatement, 5, goal.end_mood);
            sqlite3_bind_int(updateStatement, 6, goal.uploadedToServer);
            sqlite3_bind_int(updateStatement, 7, goal.goalId);
            
            if (sqlite3_step(updateStatement )== SQLITE_DONE) {
                NSLog(@"Goal sucessfully updated ");
            }
            else{
                NSLog(@"Failed to update Goal");
            }
            sqlite3_finalize(updateStatement);
        }

    }
    sqlite3_close(database);
    
}

-(void) updateGoal:(FTGoalData*)goal {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        //create updateStatement
        sqlite3_stmt *updateStatement;
        
        if(sqlite3_prepare_v2(database, updateGoalQuery, -1, &updateStatement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
        }
        // insert values (start from index 1)
        //goalValue=?, ended=?, reached=?, end_mood=?
        sqlite3_bind_double(updateStatement, 1, goal.goalValue);
        sqlite3_bind_int(updateStatement, 2, [goal.startDate timeIntervalSince1970]);
        sqlite3_bind_int(updateStatement, 3, (goal.ended ? 1 : 0));
        sqlite3_bind_int(updateStatement, 4, (goal.reached ? 1 : 0));
        sqlite3_bind_int(updateStatement, 5, goal.end_mood);
        sqlite3_bind_int(updateStatement, 6, (goal.uploadedToServer ? 1 : 0) );
        sqlite3_bind_int(updateStatement, 7, goal.goalId);
        
        if (sqlite3_step(updateStatement )== SQLITE_DONE) {
            NSLog(@"Goal sucessfully saved ");
        }
        else{
            NSLog(@"Failed to update Goal");
        }
        sqlite3_finalize(updateStatement);
        
    }
    sqlite3_close(database);
}

-(FTGoalData*) selectGoalWithStatement:(sqlite3_stmt*)stmt {
    FTGoalData* goal = nil;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        goal = [[FTGoalData alloc] init];
        goal.goalId = sqlite3_column_int(stmt, 0);
        goal.section = sqlite3_column_int(stmt, 1);
        goal.goalValue = sqlite3_column_double(stmt, 2);
        goal.valueIsFloat = sqlite3_column_int(stmt, 3);
        goal.insertDate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(stmt, 4)];
        goal.startDate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(stmt, 5)];
        goal.ended = sqlite3_column_int(stmt, 6);
        goal.reached = sqlite3_column_int(stmt, 7);
        goal.end_mood = sqlite3_column_int(stmt, 8);
        goal.dataType = [[FTDataType alloc] init];
        goal.dataType.goaltypeId = sqlite3_column_int(stmt, 9);
        goal.uploadedToServer = sqlite3_column_int(stmt, 10);

        
    }
    return goal;
}


-(NSMutableArray*) selectAllGoalToSync  {
    
    NSMutableArray *results = [NSMutableArray array];
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database ,selectAllGoalToSync , -1, &selectStatement, NULL) == SQLITE_OK)
        {
            BOOL done = NO;
            while (done!=YES) {
                FTGoalData* goal = [self selectGoalWithStatement:selectStatement];
                if (goal!=nil) {
                    [results addObject:goal];
                }
                else {
                    done = YES;
                }
            }
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while creating selectAllGoalToSync statement. '%s'", sqlite3_errmsg(database));
        
        sqlite3_close(database);
    }
    
    return results;
    
}

-(FTGoalData*)selectLastGoalWithSection:(int)section {
    FTGoalData* result = nil;
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database, selectLastGoalQuery, -1, &selectStatement, NULL) == SQLITE_OK)  {
            sqlite3_bind_int(selectStatement, 1, section);
            result = [self selectGoalWithStatement:selectStatement];
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    
    return result;
}







-(void) insertReminder:(FTReminderData*)reminder {
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        FTReminderData* existingReminder =  [self selectReminderWithId:reminder.reminderId];
        bool exists = (existingReminder!=nil);

        if (exists) {
            //create insertStatement
            sqlite3_stmt *updateStatement;
            if(sqlite3_prepare_v2(database, updateReminderQuery, -1, &updateStatement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            }
            if ([self updateReminder:reminder withStatement:updateStatement]) {
                NSLog(@"Reminder sucessfully updated : item id is %i",reminder.reminderId);
            }
            else{
                NSLog(@"Failed to edit Reminder");
            }
            sqlite3_finalize(updateStatement);
            
        }
        else {
            //create insertStatement
            sqlite3_stmt *insertStatement;
            if(sqlite3_prepare_v2(database, insertReminderQuery, -1, &insertStatement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            }
            if ([self insertReminder:reminder withStatement:insertStatement]) {
                NSLog(@"Reminder sucessfully saved : new item id is %lld",sqlite3_last_insert_rowid(database));
            }
            else{
                NSLog(@"Failed to add Reminder");
            }
            sqlite3_finalize(insertStatement);
        }
        
        
        
    }
    sqlite3_close(database);
}


-(BOOL) insertReminder:(FTReminderData*)reminder withStatement:(sqlite3_stmt*)stmt {
    // insert values
    sqlite3_bind_int(stmt, 1, reminder.section);
    sqlite3_bind_int(stmt, 2, reminder.goalType);
    sqlite3_bind_int(stmt, 3, reminder.frequency );
    sqlite3_bind_int(stmt, 4, reminder.dayOfWeek );
    sqlite3_bind_int(stmt, 5, reminder.dayOfMonth );
    sqlite3_bind_int(stmt, 6, reminder.hours );
    sqlite3_bind_int(stmt, 7, reminder.minutes);
    sqlite3_bind_int(stmt, 8, reminder.amPm);
    sqlite3_bind_int(stmt, 9, (reminder.uploadedToServer ? 1 : 0));
    
    bool result = (sqlite3_step(stmt )== SQLITE_DONE);
    
    return result;
}

-(BOOL) updateReminder:(FTReminderData*)reminder withStatement:(sqlite3_stmt*)stmt {
    // insert values
    sqlite3_bind_int(stmt, 1, reminder.frequency );
    sqlite3_bind_int(stmt, 2, reminder.dayOfWeek );
    sqlite3_bind_int(stmt, 3, reminder.dayOfMonth );
    sqlite3_bind_int(stmt, 4, reminder.hours );
    sqlite3_bind_int(stmt, 5, reminder.minutes);
    sqlite3_bind_int(stmt, 6, reminder.amPm);
    sqlite3_bind_int(stmt, 7, (reminder.uploadedToServer ? 1 : 0));
    sqlite3_bind_int(stmt, 8, reminder.reminderId);
    
    bool result = (sqlite3_step(stmt )== SQLITE_DONE);
    
    return result;
}

-(FTReminderData*) selectReminderWithSection:(int)section withGoal:(int)goal {
    FTReminderData* result = nil;
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        result = [self selectReminderWithDBWithSection:section withGoal:goal];
    }
    sqlite3_close(database);
    return result;
}

-(FTReminderData*) selectReminderWithDBWithSection:(int)section withGoal:(int)goal {
    sqlite3_stmt *selectStatement;
    if (sqlite3_prepare_v2(database, selectReminderQuery, -1, &selectStatement, NULL) == SQLITE_OK)  {
        sqlite3_bind_int(selectStatement, 1, section);
        sqlite3_bind_int(selectStatement, 2, goal);
        FTReminderData* existing = [self selectReminderWithStatement:selectStatement];
        sqlite3_finalize(selectStatement);
        return existing;
    }
    else {
        NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
        return nil;
    }

}

-(FTReminderData*) selectReminderWithId:(int)reminderId {
    sqlite3_stmt *selectStatement;
    if (sqlite3_prepare_v2(database, selectReminderByIdQuery, -1, &selectStatement, NULL) == SQLITE_OK)  {
        sqlite3_bind_int(selectStatement, 1, reminderId);
        FTReminderData* existing = [self selectReminderWithStatement:selectStatement];
        sqlite3_finalize(selectStatement);
        return existing;
    }
    else {
        NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
        return nil;
    }
    
}

-(FTReminderData*) selectReminderWithStatement:(sqlite3_stmt*)stmt {
    FTReminderData* result = nil;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        result = [[FTReminderData alloc] init];
        result.reminderId = sqlite3_column_int(stmt, 0);
        result.section = sqlite3_column_int(stmt, 1);
        result.goalType = sqlite3_column_int(stmt, 2);
        result.frequency = sqlite3_column_int(stmt, 3);
        result.dayOfWeek = sqlite3_column_int(stmt, 4);
        result.dayOfMonth = sqlite3_column_int(stmt, 5);
        result.hours = sqlite3_column_int(stmt, 6);
        result.minutes = sqlite3_column_int(stmt, 7);
        result.amPm = sqlite3_column_int(stmt, 8);
        result.uploadedToServer = sqlite3_column_int(stmt, 9);
        
    }
    return result;
}








-(void) insertLog:(FTLogData*)log  {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        bool exists = FALSE;
       
        FTLogData* existingLog =  nil;

        sqlite3_stmt *selectStatement;
        if (sqlite3_prepare_v2(database, selectLogQuery, -1, &selectStatement, NULL) == SQLITE_OK)  {
            sqlite3_bind_int(selectStatement, 1, log.uniqueId);
            existingLog = [self selectLogwithStatement:selectStatement];
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));

        if (existingLog!=nil) {
            exists = TRUE;
        }
        
        if (exists) {
            //create updateStatement
            sqlite3_stmt *updateStatement;
            if(sqlite3_prepare_v2(database, updateLogQuery, -1, &updateStatement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            }
            if ([self updateLog:log withStatement:updateStatement]) {
                NSLog(@"Log sucessfully updated : item id is %i",log.uniqueId);
            }
            else{
                NSLog(@"Failed to edit Log");
                NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
                
            }
            sqlite3_finalize(updateStatement);
            
        }
        else {
            //create insertStatement
            sqlite3_stmt *insertStatement;
            if(sqlite3_prepare_v2(database, insertLogQuery, -1, &insertStatement, NULL) != SQLITE_OK) {
                NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(database));
            }
            if ([self insertLog:log withStatement:insertStatement]) {
                NSLog(@"Log sucessfully saved : new item id is %lld",sqlite3_last_insert_rowid(database));
            }
            else{
                NSLog(@"Failed to add Log");
                NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
                
            }
            sqlite3_finalize(insertStatement);
        }
        

    }
    sqlite3_close(database);
}

-(BOOL) insertLog:(FTLogData*)log withStatement:(sqlite3_stmt*)stmt {
    // insert values
    sqlite3_bind_int(stmt, 1, log.section);
    sqlite3_bind_double(stmt, 2, log.logValue);
    sqlite3_bind_double(stmt, 3, log.logValue2);
    sqlite3_bind_int(stmt, 4, [log.insertDate timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 5, log.goalType);
    sqlite3_bind_int(stmt, 6, log.activity );
    sqlite3_bind_int(stmt, 7, log.effort );
    sqlite3_bind_int(stmt, 8, log.meal );
    sqlite3_bind_int(stmt, 9, log.goalId );
    
    bool result = (sqlite3_step(stmt )== SQLITE_DONE);
 
    return result;
}

-(BOOL) updateLog:(FTLogData*)log withStatement:(sqlite3_stmt*)stmt {
    // insert values
    sqlite3_bind_double(stmt, 1, log.logValue);
    sqlite3_bind_double(stmt, 2, log.logValue2);
    sqlite3_bind_int(stmt, 3, [log.insertDate timeIntervalSince1970]);
    sqlite3_bind_int(stmt, 4, log.activity );
    sqlite3_bind_int(stmt, 5, log.effort );
    sqlite3_bind_int(stmt, 6, log.meal );
    sqlite3_bind_int(stmt, 7, (log.uploadedToServer ? 1 : 0) );
    sqlite3_bind_int(stmt, 8, (log.deleted ? 1 : 0) );
    sqlite3_bind_int(stmt, 9, log.uniqueId );
    
    bool result = (sqlite3_step(stmt )== SQLITE_DONE);
    
    return result;
}

-(void) updateLog:(FTLogData*)log {
    
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        //create updateStatement
        sqlite3_stmt *updateStatement;
        
        if(sqlite3_prepare_v2(database, updateLogQuery, -1, &updateStatement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(database));
        }
        BOOL result = [self updateLog:log withStatement:updateStatement];

        if (result) {
            NSLog(@"Log sucessfully saved ");
        }
        else{
            NSLog(@"Failed to update Log");
        }
        sqlite3_finalize(updateStatement);
        
    }
    sqlite3_close(database);
}


-(void) deleteLog:(int)logId {
    if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {

        sqlite3_stmt *deleteStatement;
        
        if (sqlite3_prepare_v2(database, deleteLogQuery, -1, &deleteStatement, NULL) == SQLITE_OK)  {
            sqlite3_bind_int(deleteStatement, 1, logId);
            if (sqlite3_step(deleteStatement)==SQLITE_DONE ){
                NSLog(@"Log deleted");
            }
            sqlite3_finalize(deleteStatement);
        }
        else
            NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));

        sqlite3_close(database);
    }
}

-(FTLogData*) selectLogwithStatement:(sqlite3_stmt*)stmt {
    FTLogData* result = nil;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        result = [[FTLogData alloc] init];
        result.uniqueId = sqlite3_column_int(stmt, 0);
        result.section = sqlite3_column_int(stmt, 1);
        result.logValue = sqlite3_column_double(stmt, 2);
        result.logValue2 = sqlite3_column_double(stmt, 3);
        result.insertDate = [NSDate dateWithTimeIntervalSince1970:sqlite3_column_int(stmt, 4)];
        result.goalType = sqlite3_column_int(stmt, 5);
        result.activity = sqlite3_column_int(stmt, 6);
        result.effort = sqlite3_column_int(stmt, 7);
        result.meal = sqlite3_column_int(stmt, 8);
        result.uploadedToServer = sqlite3_column_int(stmt, 9);
        result.goalId = sqlite3_column_int(stmt, 10);
        result.deleted = sqlite3_column_int(stmt, 11);
        
    }
    return result;
}


-(FTLogData*)selectLastLogWithSection:(int)section withGoal:(int)goalType {
    FTLogData* result = nil;
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database, selectLastLogQuery, -1, &selectStatement, NULL) == SQLITE_OK)  {
            sqlite3_bind_int(selectStatement, 1, section);
            sqlite3_bind_int(selectStatement, 2, goalType);
            result = [self selectLogwithStatement:selectStatement];
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    
    return result;
}


-(float)selectMaxLogValueWithSection:(int)section withGoal:(int)goalType onValue2:(BOOL)onValue2 {
    int result = 0;
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        sqlite3_stmt *selectStatement;
        
        const char *zSql = selectMaxLogQuery;
        if (onValue2) zSql = selectMaxLog2Query;
        
        if (sqlite3_prepare_v2(database, zSql, -1, &selectStatement, NULL) == SQLITE_OK)  {
            sqlite3_bind_int(selectStatement, 1, section);
            sqlite3_bind_int(selectStatement, 2, goalType);
            if (sqlite3_step(selectStatement) == SQLITE_ROW) {
                result = sqlite3_column_double(selectStatement, 0);
            }
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    
    return result;
}

-(float)selectMinLogValueWithSection:(int)section withGoal:(int)goalType onValue2:(BOOL)onValue2 {
    int result = 0;
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        sqlite3_stmt *selectStatement;
        
        const char *zSql = selectMinLogQuery;
        if (onValue2) zSql = selectMinLog2Query;
        
        if (sqlite3_prepare_v2(database, zSql, -1, &selectStatement, NULL) == SQLITE_OK)  {
            sqlite3_bind_int(selectStatement, 1, section);
            sqlite3_bind_int(selectStatement, 2, goalType);
            if (sqlite3_step(selectStatement) == SQLITE_ROW) {
                result = sqlite3_column_double(selectStatement, 0);
            }
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    
    return result;
}

-(FTLogData*)selectLogWithSection:(int)section withGoal:(int)goalType withId:(int)uniqueid {
    FTLogData* result = nil;
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database, selectLogQuery, -1, &selectStatement, NULL) == SQLITE_OK)  {
            sqlite3_bind_int(selectStatement, 1, section);
            sqlite3_bind_int(selectStatement, 2, goalType);
            sqlite3_bind_int(selectStatement, 3, uniqueid);
            result = [self selectLogwithStatement:selectStatement];
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    
    return result;
}

-(FTLogData*)selectLogWithSection:(int)section withGoal:(int)goalType withDate:(NSString*)dateStr {
    FTLogData* result = nil;
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database, selectLogByDateQuery, -1, &selectStatement, NULL) == SQLITE_OK)  {
            sqlite3_bind_int(selectStatement, 1, section);
            sqlite3_bind_int(selectStatement, 2, goalType);
            sqlite3_bind_text(selectStatement, 3, [dateStr UTF8String], -1, SQLITE_TRANSIENT);
            result = [self selectLogwithStatement:selectStatement];
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
        sqlite3_close(database);
    }
    
    return result;
}




-(NSMutableArray*) selectLogGroupedByDate:(int)dateType withGoal:(int)goalType withSection:(int)section withAggregation:(FTDatabaseAggregationType)aggregation {
    
    NSMutableArray *results = [NSMutableArray array];
    
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        //SELECT
        NSString *selectQuery = @"SELECT strftime(%@, insertDate, 'unixepoch'), %@ %@ FROM FT_LOG WHERE goalType=? AND section=? GROUP BY strftime(%@, insertDate, 'unixepoch') ORDER BY strftime(%@, insertDate, 'unixepoch') DESC";
        NSString* dateTypeFormat = nil;
        NSString* weekRangeDates = @"";
        switch (dateType) {
            case 0: dateTypeFormat = @"'%Y-%m-%d'"; break;
            case 1:
                dateTypeFormat = @"'%Y-%W'";
                weekRangeDates = @", strftime('%Y-%m-%d', insertDate, 'unixepoch', 'weekday 0', '-6 day'), strftime('%Y-%m-%d', insertDate, 'unixepoch', 'weekday 0')";
                break;
            case 2: dateTypeFormat = @"'%Y-%m'"; break;
        }
        
        NSString* aggregStr = @"logValue";
        switch (aggregation) {
            case DB_AGGREGATION_NONE:
                aggregStr = @"logValue, logValue2, max(insertDate)";
                selectQuery = @"SELECT strftime(%@, insertDate, 'unixepoch'), %@ %@ FROM FT_LOG WHERE goalType=? AND section=? AND logValue>0 GROUP BY strftime(%@, insertDate, 'unixepoch') ORDER BY strftime(%@, insertDate, 'unixepoch') DESC";
                break;
                
            case DB_AGGREGATION_SUM:
                aggregStr = @"SUM(logValue), SUM(logValue2)";
                break;
                
            case DB_AGGREGATION_AVERAGE:
                //aggregStr = @"SUM(logValue), SUM(logValue2)";
                aggregStr = @"AVG(CASE WHEN logValue <> 0 THEN logValue ELSE NULL END), AVG(CASE WHEN logValue2 <> 0 THEN logValue2 ELSE NULL END)"; //@"AVG(logValue)";
                break;
        }
      
        selectQuery = [NSString stringWithFormat:selectQuery, dateTypeFormat, aggregStr, weekRangeDates, dateTypeFormat, dateTypeFormat ];
        

        sqlite3_stmt *selectStatement;
        NSLog(@"queying data...");
        if (sqlite3_prepare_v2(database ,[selectQuery UTF8String] , -1, &selectStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(selectStatement, 1, goalType);
            sqlite3_bind_int(selectStatement, 2, section);
            
            while (sqlite3_step(selectStatement) == SQLITE_ROW)
            {
                FTLogGroupedData* log = [[FTLogGroupedData alloc] init];
                log.section = section;
                log.goalType = goalType;
                log.dateType = dateType;
                char *cDateValue = (char *) sqlite3_column_text(selectStatement, 0);
                log.dateValue = [[NSString alloc] initWithUTF8String:cDateValue];
                log.value = sqlite3_column_double(selectStatement, 1);
                log.value2 = sqlite3_column_double(selectStatement, 2);
                if (dateType==1) {
                    char *cWeekStartDate = (char *) sqlite3_column_text(selectStatement, 3);
                    log.weekStartDate = [[NSString alloc] initWithUTF8String:cWeekStartDate];
                    char *cWeekEndDate = (char *) sqlite3_column_text(selectStatement, 4);
                    log.weekEndDate = [[NSString alloc] initWithUTF8String:cWeekEndDate];
                }
                
                [results addObject:log];
                
            }
            sqlite3_finalize(selectStatement);
            //NSLog(@"...records=%i",[results count]);
        }
        sqlite3_close(database);
    }
    
    return results;
    
}

-(NSMutableArray*) selectAllDateLogWithSection:(int)section withGoal:(int)goalType   {
    
    NSMutableArray *results = [NSMutableArray array];
    
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database ,selectAllLogQuery , -1, &selectStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(selectStatement, 1, section);
            sqlite3_bind_int(selectStatement, 2, goalType);
            
            BOOL done = NO;
            int currentYear = -1;
            int currentMonth = -1;
            FTDateLogData* currentDateLogData = nil;
            while (done!=YES) {
                FTLogData* log = [self selectLogwithStatement:selectStatement];
                if (log!=nil) {
                    //check date
                    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:log.insertDate];
                    NSInteger month = [components month];
                    NSInteger year = [components year];
                    if (year!=currentYear || month!=currentMonth) {
                        currentDateLogData = [[FTDateLogData alloc] initWithYear:year withMonth:month];
                        currentYear = year;
                        currentMonth = month;
                        [results addObject:currentDateLogData];
                    }
                    
                    [currentDateLogData.logs addObject:log];
                }
                else {
                    done = YES;
                }
            }
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
        
        sqlite3_close(database);
    }
    
    return results;
    
}

-(NSMutableArray*) selectAllLogWithSection:(int)section withGoal:(int)goalType  {
    
    NSMutableArray *results = [NSMutableArray array];
    
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database ,selectAllLogQuery , -1, &selectStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(selectStatement, 1, section);
            sqlite3_bind_int(selectStatement, 2, goalType);
            
            BOOL done = NO;
            while (done!=YES) {
                FTLogData* log = [self selectLogwithStatement:selectStatement];
                if (log!=nil) {
                    [results addObject:log];
                }
                else {
                    done = YES;
                }
            }
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while select statement. '%s'", sqlite3_errmsg(database));
        
        sqlite3_close(database);
    }
    
    return results;
    
}


-(NSMutableArray*) selectAllLogsWithGoal:(FTGoalData*)goalData  {
    NSMutableArray *results = nil;
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK) {
        results = [self selectAllLogWithGoalInDb:goalData];
        sqlite3_close(database);
    }
    return results;
}

-(NSMutableArray*) selectAllLogWithGoalInDb:(FTGoalData*)goalData  {
    
    NSMutableArray *results = [NSMutableArray array];
    
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database ,selectAllLogsByGoalQuery , -1, &selectStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(selectStatement, 1, goalData.goalId);
            
            BOOL done = NO;
            while (done!=YES) {
                FTLogData* log = [self selectLogwithStatement:selectStatement];
                if (log!=nil) {
                    [results addObject:log];
                }
                else {
                    done = YES;
                }
            }
            sqlite3_finalize(selectStatement);
        }
        else
            NSAssert1(0, @"Error while creating selectAllLogWithGoal statement. '%s'", sqlite3_errmsg(database));

    
    return results;
    
}

//****
//Return an array of FTGoalGroupedData
//
-(NSMutableArray*) selectGoalGroupedDataWithSection:(int)section  {
    
    NSMutableArray *results = [NSMutableArray array];
    
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database ,selectAllGoals , -1, &selectStatement, NULL) == SQLITE_OK)
        {
            sqlite3_bind_int(selectStatement, 1, section);

            
            BOOL done = NO;
            while (done!=YES) {
                FTGoalData* goal = [self selectGoalWithStatement:selectStatement];
                if (goal!=nil) {
                    FTGoalGroupedData* goalGrouped = [[FTGoalGroupedData alloc] init];
                    goalGrouped.goalData = goal;
                    //find logs
                    NSMutableArray* logs = [self selectAllLogWithGoalInDb:goal];
                    goalGrouped.logs = logs;
                    if (logs!=nil && [logs count]>0) {
                        for (int i=0; i<[logs count]; i++) {
                            FTLogData* logData = (FTLogData*)[logs objectAtIndex:i];
                            
                            float normalizedValue = logData.logValue;
                            if (section==SECTION_FITNESS && logData.goalType==1) {
                                normalizedValue = [UCFSUtil calculateMinutesFromSteps:logData.logValue];
                            }
                            
                            goalGrouped.totalValue += normalizedValue;
                            //max value
                            if (normalizedValue>goalGrouped.maxValue)
                                goalGrouped.maxValue = normalizedValue;
                            //min value
                            if (normalizedValue<goalGrouped.minValue)
                                goalGrouped.minValue = normalizedValue;
                        }
                    }
                    
                    if (goalGrouped.logs!=nil && [goalGrouped.logs count]>0)
                        [results addObject:goalGrouped];
                }
                else {
                    done = YES;
                }
            }
            sqlite3_finalize(selectStatement);
        }
        sqlite3_close(database);
    }
    
    return results;
    
}


//****
//Return an array of FTDateLogData
//
-(NSMutableArray*) selectLogsGroupedDataWithGoal:(FTGoalData*)goalData  {
    
    NSMutableArray *results = [NSMutableArray array];
    
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK) {
    
        //find all logs
        NSMutableArray* logs = [self selectAllLogWithGoalInDb:goalData];
        //make groups
        NSDate* startDate = [UCFSUtil setTimeWithDate:goalData.startDate withHours:0 withMinutes:0 withSeconds:0];
        for (int i=0; i<7; i++) {
            NSDate* date = [UCFSUtil getDate:startDate addDays:(6-i)];
            NSDate* endDate = [UCFSUtil setTimeWithDate:date withHours:23 withMinutes:59 withSeconds:59];
            NSDate* currentDate = [UCFSUtil setTimeWithDate:[NSDate date] withHours:23 withMinutes:59 withSeconds:59];
            int comp = [currentDate compare:endDate];
            if (comp == NSOrderedDescending || comp==NSOrderedSame) {
                FTDateLogData* dateLogData = [[FTDateLogData alloc] initWithDate:date];
                
                //find logs by date
                if (logs!=nil && [logs count]>0) {
                    for (int j=0; j<[logs count]; j++) {
                        FTLogData* logData = (FTLogData*)[logs objectAtIndex:j];
                        if ([UCFSUtil date:logData.insertDate isBetweenDate:date andDate:endDate]) {
                            [dateLogData.logs addObject:logData];
                        }
                    }
                }
                if (dateLogData.logs!=nil && [dateLogData.logs count]>0)
                    [results addObject:dateLogData];
            }
        }
        
        sqlite3_close(database);
    }
    
    return results;
}


-(NSMutableArray*) selectAllLogToSync  {
    
    NSMutableArray *results = [NSMutableArray array];
    if (sqlite3_open([databasePath UTF8String] , &database) == SQLITE_OK){
        
        sqlite3_stmt *selectStatement;
        
        if (sqlite3_prepare_v2(database ,selectAllLogToSyncQuery , -1, &selectStatement, NULL) == SQLITE_OK)
        {
            BOOL done = NO;
            while (done!=YES) {
                FTLogData* log = [self selectLogwithStatement:selectStatement];
                if (log!=nil) {
                    [results addObject:log];
                }
                else {
                    done = YES;
                }
            }
            sqlite3_finalize(selectStatement);
        }
        
        sqlite3_close(database);
    }

    
    return results;
    
}






@end
