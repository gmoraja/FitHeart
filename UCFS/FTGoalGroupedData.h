//
//  FTGoalGroupedData.h
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTGoalData.h"

@interface FTGoalGroupedData : NSObject {
    FTGoalData* goalData;
    NSMutableArray* logs;
    float totalValue;
    float maxValue;
    float minValue;
}

@property (nonatomic,strong) FTGoalData* goalData;
@property (nonatomic,strong) NSMutableArray* logs;
@property (nonatomic,assign) float totalValue;
@property (nonatomic,assign) float maxValue;
@property (nonatomic,assign) float minValue;

@end
