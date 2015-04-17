//
//  FTLogContainerView.h
//  FitHeart
//
//  Created by Bitgears on 13/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFSUtil.h"
#import "FTSection.h"
#import "FTLogData.h"
#import "FTOptionGroupView.h"
#import "FTDateSelectView.h"
#import "FTActivitySelectView.h"
#import "FTEffortSelectView.h"
#import "FTMealSelectView.h"
#import "FTGlucoseSelectView.h"
#import "FTHeaderView.h"
#import "FTSingleHeaderView.h"
#import "BSKeyboardControls.h"
#import "FTDoubleHeaderView.h"

@protocol FTLogContainerDelegate
- (void)startEditingValue;
- (void)finishEditingValue;
- (void)infoTouched;
- (void)bottomButtonTouched:(int)buttonType;
- (void)switchToTimer;
- (void)switchToManual;

@end

@interface FTLogContainerView : UIView<UITextFieldDelegate, BSKeyboardControlsDelegate, FTDoubleHeaderProtocol> {
    
    
    Class<FTSection> currentSection;
    FTGoalData* currentGoalData;
    FTLogData* currentLogData;
    FTHeaderConf *conf;
    FTHeaderView *headerView;
    
    UIView *bodyContainerView;
    UIView* mainContainerView;
    UIImage *infoImage;
    UIButton *infoButton;
    UIImage *keypadImage;
    UIButton *keypadButton;
    UIView *maskView;

    FTOptionGroupView* optionView;
    FTDateSelectView *dateSelect;
    FTActivitySelectView *activitySelect;
    FTEffortSelectView *effortSelect;
    FTMealSelectView *mealSelect;
    FTGlucoseSelectView *glucoseSelect;
    float bodyContainerHeight;
    
    float contentStartY;
    float maxY;
    float minY;
    CGRect topRect;
    CGRect bottomRect;
    
    BOOL useTimer;
    
    BSKeyboardControls *keyboardControls;
    TBCircularSlider *slider;
    
}

@property (weak) id <FTLogContainerDelegate> delegate;
@property (strong) FTHeaderView *headerView;

- (void)createKeypadButtonWithRect:(CGRect)rect;
- (void)createInfoButtonWithRect:(CGRect)rect;
- (void)createMask;
- (void)initOptions;

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData;
- (void)updateWithGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData withActiveValue:(int)activeValue;
- (void)refreshBottomButtons;
-(void)updateTimeButton:(BOOL)asTimer;
- (FTLogData*)getLogData;

-(BOOL)isSliding;
-(void)dismissKeyboard;


@end
