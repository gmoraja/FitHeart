//
//  FTSalesForce.m
//  FitHeart
//
//  Created by Bitgears on 10/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTSalesForce.h"
#import "ZKSforce.h"
#import "FTLogData.h"
#import "FTGoalData.h"
#import "FTReminderData.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"
#import "HealthSection.h"
/*
static NSString * const username      = @"fitheart.mobile.api@fitheart.com.dev";
static NSString * const password      = @"pa55w0rd!ZAKVMit3ER1XI9ekYkoGokUU";
static NSString * const host          = @"https://test.salesforce.com";
 */
/*
static NSString * const username      = @"fitheart.mobile.api@fitheart.com.fithrtqa";
static NSString * const password      = @"pa55w0rd!IVy1GnvtvtYO7h9WLyPrmJd5";
static NSString * const host          = @"https://test.salesforce.com";
 */
static NSString * const username      = @"integrationadmin@ucsf.edu.fitheart";
static NSString * const password      = @"fitHeart201482Ho6teqFMzV5fdQZxADcScPz";
static NSString * const host          = @"https://login.salesforce.com";


@interface FTSalesForce() {
    ZKSforceClient* sforce;
}

@end

@implementation FTSalesForce

static FTSalesForce *instance;

+ (FTSalesForce*)getInstance {
    if (instance == nil) {
        instance = [[FTSalesForce alloc] init];
    }
    return instance;
}

- (id)init {
    if ((self = [super init])) {

    }
    return self;
}

// connection
- (BOOL)connect {
    @try {
        if (sforce==nil) {
            sforce = [[ZKSforceClient alloc] init];
            [sforce setLoginProtocolAndHost:host];
            [sforce login:username password:password];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR %@", [exception reason]);
        sforce=nil;
    }
    
    return (sforce!=nil && sforce.loggedIn);
}



-(NSString*)createSectionIfNotExists:(int)sectionType withPartecipant:(NSString*)pId {
    NSString* sectionId = nil;
    @try {
        if ([self connect]) {
            sectionId = [self sectionExists:(sectionType+1) withPartecipant:pId ];
            if (sectionId==nil) {
                ZKSObject *section = [ZKSObject withType:@"FitHeart_Section__c"];
                [section setFieldValue:[NSString stringWithFormat:@"%i", sectionType+1] field:@"section_id__c"];
                [section setFieldValue:pId field:@"Participant__c"];

                
                NSArray *results = [sforce create:[NSArray arrayWithObject:section]];
                ZKSaveResult *sr = [results objectAtIndex:0];
                if ([sr success]){
                    sectionId = [sr id];
                    NSLog(@"New Section ID %@", [sr id]);
                }
            }
        }
    }
    @catch(NSException* ex) {
        NSLog(@"createIfNotExistsSection exception ");
    }
    
    return sectionId;
}

- (NSString*)sectionExists:(int)sectionType withPartecipant:(NSString*)pId {
    if (sforce!=nil) {
        ZKQueryResult *qr = [sforce query:[NSString stringWithFormat:@"SELECT Id FROM FitHeart_Section__c WHERE Participant__c='%@' AND section_id__c=%i ", pId, sectionType] ];
        if (qr!=nil && [[qr records] count]==1) {
            ZKSObject *o = [[qr records] objectAtIndex:0];
            return [o fieldValue:@"Id"];
        }
    }
    
    return nil;
}

- (NSString*)createIfNotExistsUser:(int)studyId {
    NSString* participantId = nil;
    @try {
        if ([self connect]) {
            participantId = [self userExists:studyId];
            if (participantId==nil) {
                // object preparation
                ZKSObject *participant = [ZKSObject withType:@"FitHeart_Participant__c"];
                [participant setFieldValue:[NSString stringWithFormat:@"%i", studyId] field:@"study_id__c"];
                
                // object creation
                NSArray *results = [sforce create:[NSArray arrayWithObject:participant]];
                ZKSaveResult *sr = [results objectAtIndex:0];
                
                if ([sr success]){
                    NSLog(@"New Participant ID %@", [sr id]);
                    participantId = [sr id];
                }
            }
            else {
                //update user login date
                NSString* datetimeStr = [UCFSUtil datetimeGMT:[NSDate date]];

                //[sforce query:[NSString stringWithFormat:@"UPDATE FitHeart_Participant__c SET last_login__c=%@ WHERE study_id__c=%i", datetimeStr, studyId] ];
                
            }
        }
    }
    @catch(NSException* ex) {
        NSLog(@"createUser exception %@", ex.reason);
    }
    
    return participantId;

}

- (NSString*)userExists:(int)studyId {
    if (sforce!=nil) {
        @try {
            ZKQueryResult *qr = [sforce query:[NSString stringWithFormat:@"SELECT Id FROM FitHeart_Participant__c WHERE study_id__c=%i", studyId] ];
            if (qr!=nil && [[qr records] count]==1) {
                ZKSObject *o = [[qr records] objectAtIndex:0];
                return [o fieldValue:@"Id"];
            }
        }
        @catch(NSException* ex) {
            NSLog(@"userExists exception %@", ex.reason);
        }
    }
    
    return nil;
}


- (ZKSObject*)logFromId:(int)logId withPartecipant:(NSString*)pId {
    @try {
        if (sforce!=nil) {
            //GET ID
            ZKQueryResult *qr = [sforce query:[NSString stringWithFormat:@"SELECT Id FROM FitHeart_Log__c WHERE log_id__c=%i AND FitHeart_Participant__c='%@'", logId, pId] ];
            if (qr!=nil && [[qr records] count]==1) {
                ZKSObject *o = [[qr records] objectAtIndex:0];
                NSString* recordId = [o fieldValue:@"Id"];
                
                ZKSObject *record = [ZKSObject withType:@"FitHeart_Log__c"];
                [record setFieldValue:recordId field:@"Id"];
                return record;
            }
        }
        
        return nil;
    }
    @catch(NSException* ex) {
        NSLog(@"logFromId exception ");
        return nil;
    }
}

- (BOOL)insertLog:(FTLogData*)logData withUser:(int)studyId {
    @try {
        NSString* participantId = [self createIfNotExistsUser:studyId];
        if (participantId!=nil) {
            
            NSString* sectionId = [self createSectionIfNotExists:logData.section withPartecipant:participantId];
            if (sectionId!=nil) {
                
                ZKSObject* log = [self logFromId:logData.uniqueId withPartecipant:participantId];
                if (log==nil) {
                    NSLog(@"inserting log... ");
                    // object preparation
                    ZKSObject *record = [ZKSObject withType:@"FitHeart_Log__c"];
                    [record setFieldValue:[NSString stringWithFormat:@"%i", logData.uniqueId] field:@"log_id__c"];
                    //VALUE
                    if (logData.section== SECTION_MOOD) {
                        int tmpValue = (int)(logData.logValue);
                        int moodValue = tmpValue+1;
                        [record setFieldValue:[NSString stringWithFormat:@"%i", moodValue] field:@"log_value__c"];
                        
                    }
                    else
                        [record setFieldValue:[NSString stringWithFormat:@"%i", (int)(logData.logValue)] field:@"log_value__c"];
                    //VALUE2
                    [record setFieldValue:[NSString stringWithFormat:@"%i", (int)(logData.logValue2)] field:@"log_value_aux__c"];
                    //ACTIVITY + EFFORT
                    if (logData.section == SECTION_FITNESS) {
                        [record setFieldValue:[NSString stringWithFormat:@"%i", (logData.effort) ] field:@"effort__c"];
                        [record setFieldValue:[NSString stringWithFormat:@"%i", (logData.activity)] field:@"activity__c"];
                    }
                    else {
                        [record setFieldValue:[NSString stringWithFormat:@"%i", 0] field:@"effort__c"];
                        [record setFieldValue:[NSString stringWithFormat:@"%i", 0] field:@"activity__c"];
                    }
                    //GOAL TYPE
                    if (logData.section== SECTION_FITNESS) {
                        [record setFieldValue:[NSString stringWithFormat:@"%i", logData.goalType+1] field:@"goaltype_id__c"];
                    }
                    else
                        if (logData.section== SECTION_HEALTH) {
                            [record setFieldValue:[NSString stringWithFormat:@"%i", logData.goalType+3] field:@"goaltype_id__c"];
                        }
                        else
                            [record setFieldValue:[NSString stringWithFormat:@"%i", 0] field:@"goaltype_id__c"];
                    
                    NSString* datetimeStr = [UCFSUtil datetimeGMT:logData.insertDate];
                    [record setFieldValue:datetimeStr field:@"insert_date__c"];
                    [record setFieldValue:participantId field:@"FitHeart_Participant__c"];
                    [record setFieldValue:sectionId field:@"Section__c"];
                    
                    if (logData.section==SECTION_FITNESS) {
                        ZKSObject* goal = [self goalFromId:logData.goalId withPartecipant:participantId];
                        if (goal!=nil) {
                            NSString* goalId = [goal fieldValue:@"Id"];
                            [record setFieldValue:goalId field:@"Goal__c"];
                        }
                        else {
                            NSLog(@"No related goal found ");
                        }
                    }
                    
                    // object creation
                    NSArray *results = [sforce create:[NSArray arrayWithObject:record]];
                    ZKSaveResult *sr = [results objectAtIndex:0];
                    
                    if ([sr success]){
                        NSLog(@"New LOG ID %@", [sr id]);
                        return true;
                    }
                    else {
                        NSLog(@"No log created ");
                    }
                    
                }
                else {
                    //UPDATE
                    NSString* logId = [log fieldValue:@"Id"];
                    NSLog(@"updating log... %@", logId);
                    [log setFieldValue:[NSString stringWithFormat:@"%i", (int)(!logData.deleted)] field:@"Active__c"];
                    NSString* datetimeStr = [UCFSUtil datetimeGMT:logData.insertDate];
                    [log setFieldValue:datetimeStr field:@"insert_date__c"];
                    
                    // object creation
                    NSArray *results = [sforce update:[NSArray arrayWithObject:log]];
                    ZKSaveResult *sr = [results objectAtIndex:0];
                    if ([sr success]){
                        NSLog(@"Log updated!");
                        return true;
                    }
                }
                
                
            }
        }
    }
    @catch(NSException* ex) {
        NSLog(@"insertLog exception ");
    }
    
    return false;
}


- (ZKSObject*)goalFromId:(int)goalId withPartecipant:(NSString*)pId {
    @try {
        if (sforce!=nil) {
            //GET ID
            ZKQueryResult *qr = [sforce query:[NSString stringWithFormat:@"SELECT Id FROM FitHeart_Goal__c WHERE goal_id__c=%i AND FitHeart_Participant__c='%@'", goalId, pId] ];
            if (qr!=nil && [[qr records] count]==1) {
                ZKSObject *o = [[qr records] objectAtIndex:0];
                NSString* recordId = [o fieldValue:@"Id"];
                
                ZKSObject *record = [ZKSObject withType:@"FitHeart_Goal__c"];
                [record setFieldValue:recordId field:@"Id"];
                return record;
            }
        }
        
        return nil;
    }
    @catch(NSException* ex) {
        NSLog(@"goalFromId exception ");
        return nil;
    }
}

- (BOOL)insertGoal:(FTGoalData*)goalData withUser:(int)studyId {
    @try {
        NSString* participantId = [self createIfNotExistsUser:studyId];
        if (participantId!=nil) {
            
            NSString* sectionId = [self createSectionIfNotExists:goalData.section withPartecipant:participantId];
            if (sectionId!=nil) {
                
                //check if goal exists
                ZKSObject* goal = [self goalFromId:goalData.goalId withPartecipant:participantId];
                if (goal==nil) {
                    NSLog(@"inserting goal... ");
                    // object preparation
                    ZKSObject *record = [ZKSObject withType:@"FitHeart_Goal__c"];
                    [record setFieldValue:[NSString stringWithFormat:@"%i", goalData.goalId] field:@"goal_id__c"];
                    [record setFieldValue:[NSString stringWithFormat:@"%i", (int)(goalData.goalValue)] field:@"goal_value__c"];
                    [record setFieldValue:[NSString stringWithFormat:@"%i", (int)(goalData.reached)] field:@"reached__c"];
                    [record setFieldValue:[NSString stringWithFormat:@"%i", (int)(goalData.ended)] field:@"ended__c"];
                    [record setFieldValue:[NSString stringWithFormat:@"%i", (int)(goalData.end_mood)] field:@"end_mood__c"];
                    
                    NSString* datetimeStr = [UCFSUtil datetimeGMT:goalData.insertDate];
                    [record setFieldValue:datetimeStr  field:@"insert_date__c"];
                    
                    NSString* startdatetimeStr = [UCFSUtil datetimeGMT:goalData.startDate];
                    [record setFieldValue:startdatetimeStr  field:@"startDate__c"];
                    
                    [record setFieldValue:participantId field:@"FitHeart_Participant__c"];
                    [record setFieldValue:sectionId field:@"Section__c"];
                    
                    if (goalData.dataType!=nil)
                        [record setFieldValue:[NSString stringWithFormat:@"%i", goalData.dataType.goaltypeId+1] field:@"Goal_Type_ID__c"];
                    
                    // object creation
                    NSArray *results = [sforce create:[NSArray arrayWithObject:record]];
                    ZKSaveResult *sr = [results objectAtIndex:0];
                    
                    if ([sr success]){
                        NSLog(@"New GOAL ID %@", [sr id]);
                        return true;
                    }
                }
                else {
                    //UPDATE
                    NSString* goalId = [goal fieldValue:@"Id"];
                    NSLog(@"updating goal... %@", goalId);
                    [goal setFieldValue:[NSString stringWithFormat:@"%i", (int)(goalData.goalValue)] field:@"goal_value__c"];
                    [goal setFieldValue:[NSString stringWithFormat:@"%i", (int)(goalData.reached)] field:@"reached__c"];
                    [goal setFieldValue:[NSString stringWithFormat:@"%i", (int)(goalData.ended)] field:@"ended__c"];
                    [goal setFieldValue:[NSString stringWithFormat:@"%i", (int)(goalData.end_mood)] field:@"end_mood__c"];

                    // object update
                    NSArray *results = [sforce update:[NSArray arrayWithObject:goal]];
                    ZKSaveResult *sr = [results objectAtIndex:0];
                    if ([sr success]){
                        NSLog(@"goal updated!");
                        return true;
                    }
                }

            }
        }

    }
    @catch(NSException* ex) {
        NSLog(@"insertGoal exception ");
    }
    
    return false;
}





@end
