//
//  FTDateLogData.m
//  FitHeart
//
//  Created by Bitgears on 12/02/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTDateLogData.h"

@implementation FTDateLogData

@synthesize year;
@synthesize month;
@synthesize logs;
@synthesize date;

-(id)initWithYear:(int)dateYear withMonth:(int)dateMonth {
    self = [super init];
    if (self) {
        year = dateYear;
        month = dateMonth;
        logs = [NSMutableArray array];
    }
    return self;
}

-(id)initWithDate:(NSDate*)groupDate {
    self = [super init];
    if (self) {
        date = groupDate;
        logs = [NSMutableArray array];
    }
    return self;
}

@end
