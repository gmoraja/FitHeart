//
//  FTGoalContainerView.h
//  FitHeart
//
//  Created by Bitgears on 12/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFSUtil.h"
#import "FTSection.h"
#import "FTGoalData.h"
#import "FTHeaderView.h"
#import "FTReminderSelectView.h"
#import "FTOptionGroupView.h"
#import "FTGoalAchivedSelectView.h"
#import "BSKeyboardControls.h"

@protocol FTGoalContainerDelegate
- (void)startEditingValue;
- (void)finishEditingValue;
- (void)infoTouched;
@end

@interface FTGoalContainerView : UIView<UITextFieldDelegate, BSKeyboardControlsDelegate> {
    
    Class<FTSection> currentSection;
    FTGoalData* currentGoalData;
    FTHeaderConf *conf;
    FTHeaderView *headerView;
    UIView* mainContainerView;
    TBCircularSlider *slider;
    UIButton *infoButton;
    UIButton *keypadButton;
    UIView *maskView;
    FTReminderSelectView *reminderSelect;
    FTGoalAchivedSelectView* goalAchivedBySelect;
    FTOptionGroupView* optionView;
    UIView *bodyContainerView;
    float bodyContainerHeight;
    BOOL isEditingMaxValue;

    float maxY;
    float minY;
    CGRect topRect;
    CGRect bottomRect;
    
    BSKeyboardControls *keyboardControls;
    

}

@property (weak) id <FTGoalContainerDelegate> delegate;
@property (strong) FTHeaderView *headerView;

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withGoalData:(FTGoalData*)goalData;
- (void)updateWithGoalData:(FTGoalData*)goalData;
- (FTGoalData*)getGoalData;
-(void)dismissKeyboard;


@end
