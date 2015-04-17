//
//  FTLogData.h
//  FitHeart
//
//  Created by Bitgears on 05/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTGoalData.h"

@interface FTLogData : NSObject {
    
    int uniqueId;
    int section;
    float logValue;
    float logValue2;
    NSDate *insertDate;
    int activity; //fitness
    int effort; //fitness
    int meal; //nutrition
    int goalType;
    int goalId;
    BOOL uploadedToServer;
    BOOL deleted;
}

@property (nonatomic,assign) int uniqueId;
@property (nonatomic,assign) int section;
@property (nonatomic,assign) float logValue;
@property (nonatomic,assign) float logValue2;
@property (nonatomic,strong) NSDate *insertDate;
@property (nonatomic,assign) int activity;
@property (nonatomic,assign) int effort;
@property (nonatomic,assign) int meal;
@property (nonatomic,assign) int goalType;
@property (nonatomic,assign) int goalId;
@property (nonatomic,assign) BOOL uploadedToServer;
@property (nonatomic,assign) BOOL deleted;

- (id)initWithGoal:(FTGoalData*)goal;

@end
