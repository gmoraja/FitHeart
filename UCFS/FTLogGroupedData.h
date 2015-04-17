//
//  FTGoalGroupedData.h
//  FitHeart
//
//  Created by Bitgears on 02/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FTLogGroupedData : NSObject {
    NSString* dateValue;
    float value;
    float value2;
    int dateType;
    int goalType;
    int section;
    NSString* weekStartDate;
    NSString* weekEndDate;
}

@property (nonatomic,strong) NSString* dateValue;
@property (nonatomic,assign) float value;
@property (nonatomic,assign) float value2;
@property (nonatomic,assign) int dateType;
@property (nonatomic,assign) int goalType;
@property (nonatomic,assign) int section;
@property (nonatomic,strong) NSString* weekStartDate;
@property (nonatomic,strong) NSString* weekEndDate;

@end
