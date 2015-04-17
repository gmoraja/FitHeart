//
//  FTSectionGoal.h
//  FitHeart
//
//  Created by Bitgears on 12/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTHeaderConf : NSObject {
    
    int type;
    int uiType; //0=single, 1=single+toplabel, 2=double, 3=timer
    int dateType; //0=day, 1=week, 2=month
    NSString* leftText;
    NSString* rightText;
    NSString* topText;
    NSString* unit;
    NSString* unit2;
    BOOL valueIsFloat;
    float valueTextWidth;
    UIColor *leftTextColor;
    UIColor *rightTextColor;
    UIColor *topTextColor;
    UIColor *valueTextColor;
    UIColor *value2TextColor;
    float headerHeight;
    BOOL compactValue;
    BOOL maxValueIsEditable;
    float maxValueLimit;
    float minValueLimit;
    BOOL normalizeValue;
    float wheelStepValue;
}

@property (assign) int type;
@property (assign) int uiType;
@property (assign) int dateType;
@property (strong, nonatomic) NSString* leftText;
@property (strong, nonatomic) NSString* rightText;
@property (strong, nonatomic) NSString* topText;
@property (strong, nonatomic) NSString* unit;
@property (strong, nonatomic) NSString* unit2;
@property (assign) BOOL valueIsFloat;
@property (assign) float valueTextWidth;
@property (strong, nonatomic) UIColor *leftTextColor;
@property (strong, nonatomic) UIColor *rightTextColor;
@property (strong, nonatomic) UIColor *topTextColor;
@property (strong, nonatomic) UIColor *valueTextColor;
@property (strong, nonatomic) UIColor *value2TextColor;
@property (assign) float headerHeight;
@property (assign) BOOL compactValue;
@property (assign) BOOL maxValueIsEditable;
@property (assign) float maxValueLimit;
@property (assign) float minValueLimit;
@property (assign) BOOL normalizeValue;
@property (assign) float wheelStepValue;

- (id) initAsSingleValue;
- (id) initAsSingleValueTopLabeled;
- (id) initAsDoubleValue;
- (id) initAsTimerValue;


@end
