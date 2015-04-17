//
//  FTSectionGoalViewController.h
//  FitHeart
//
//  Created by Bitgears on 30/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "FTDialogView.h"
#import "FTGoalContainerView.h"
#import "FitnessSwitcherView.h"
#import "GAITrackedViewController.h"

@interface FTSectionGoalViewController : GAITrackedViewController<FTGoalContainerDelegate, FTDialogDelegate, FitnessSwitcherDelegate> {
    Class<FTSection> currentSection;
    FTGoalContainerView *goalContainerView;
    FTGoalData* currentGoalData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withGoal:(FTGoalData*)goalData asNew:(BOOL)isNew;

@end
