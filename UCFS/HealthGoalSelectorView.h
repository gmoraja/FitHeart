//
//  HealthGoalSelectorView.h
//  FitHeart
//
//  Created by Bitgears on 02/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTLogData.h"


@protocol HealthGoalSelectorDelegate
    - (void)changeGoal:(int)goal;
@end

@interface HealthGoalSelectorView : UIView {
    int selectedGoal;
}

- (id)initWithFrame:(CGRect)frame;

@property (assign) id <HealthGoalSelectorDelegate> delegate;
@property (assign) int selectedGoal;

- (void)updateWithLog:(FTLogData*)logData withDataType:(int)dataType;

@end
