//
//  FTDateLogData.h
//  FitHeart
//
//  Created by Bitgears on 12/02/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTDateLogData : NSObject {
    int year;
    int month;
    NSDate* date;
    NSMutableArray* logs;
}

@property (nonatomic,strong) NSDate* date;
@property (nonatomic,assign) int year;
@property (nonatomic,assign) int month;
@property (nonatomic,strong) NSMutableArray* logs;

-(id)initWithYear:(int)dateYear withMonth:(int)dateMonth;
-(id)initWithDate:(NSDate*)groupDate;


@end
