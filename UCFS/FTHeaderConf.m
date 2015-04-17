//
//  FTSectionGoal.m
//  FitHeart
//
//  Created by Bitgears on 12/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTHeaderConf.h"

@implementation FTHeaderConf

@synthesize type;
@synthesize uiType; //0=single value, 1=single+toplabel, 2=double value
@synthesize dateType;
@synthesize leftText;
@synthesize rightText;
@synthesize topText;
@synthesize unit;
@synthesize unit2;
@synthesize valueIsFloat;
@synthesize valueTextWidth;
@synthesize leftTextColor;
@synthesize rightTextColor;
@synthesize topTextColor;
@synthesize valueTextColor;
@synthesize value2TextColor;
@synthesize headerHeight;
@synthesize compactValue;
@synthesize maxValueIsEditable;
@synthesize maxValueLimit;
@synthesize minValueLimit;
@synthesize normalizeValue;
@synthesize wheelStepValue;


-(void)setDefault {
    leftTextColor = [UIColor lightGrayColor];
    rightTextColor = [UIColor lightGrayColor];
    topTextColor = [UIColor lightGrayColor];
    valueTextWidth = 200.0;
    headerHeight = 67;
    compactValue = FALSE;
    valueIsFloat = FALSE;
    dateType = 1; //month
    maxValueIsEditable = TRUE;
    maxValueLimit = 999;
    minValueLimit = 1;
    normalizeValue = TRUE;
    wheelStepValue = 0;
}

- (id) initAsSingleValue {
    self = [super init];
    if (self) {
        uiType = 0;
        [self setDefault];
    }
    return self;
}

- (id) initAsSingleValueTopLabeled {
    self = [super init];
    if (self) {
        uiType = 1;
        [self setDefault];
    }
    return self;
}

- (id) initAsDoubleValue {
    self = [super init];
    if (self) {
        uiType = 2;
        [self setDefault];
    }
    return self;
}

- (id) initAsTimerValue {
    self = [super init];
    if (self) {
        uiType = 3;
        [self setDefault];
    }
    return self;
}

@end
