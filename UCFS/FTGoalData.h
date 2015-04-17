//
//  FTGoalData.h
//  FitHeart
//
//  Created by Bitgears on 22/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTReminderData.h"
#import "FTDataType.h"



@interface FTGoalData : NSObject {

    int goalId;
    int section;
    float goalValue;
    bool valueIsFloat;
    NSDate *insertDate;
    NSDate *startDate;
    BOOL ended;
    BOOL reached;
    int end_mood;
    BOOL uploadedToServer;

    FTDataType* dataType;

}

@property (nonatomic,assign) int goalId;
@property (nonatomic,assign) int section;
@property (nonatomic,assign) float goalValue;
@property (nonatomic,assign) bool valueIsFloat;
@property (nonatomic,strong) NSDate* insertDate;
@property (nonatomic,strong) NSDate* startDate;
@property (nonatomic,assign) BOOL ended;
@property (nonatomic,assign) BOOL reached;
@property (nonatomic,assign) BOOL uploadedToServer;
@property (nonatomic,assign) int end_mood;
@property (nonatomic,strong) FTDataType* dataType;

@end
