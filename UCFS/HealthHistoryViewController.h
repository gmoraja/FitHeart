//
//  HealthHistoryViewController.h
//  FitHeart
//
//  Created by Bitgears on 09/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "GAITrackedViewController.h"

@interface HealthHistoryViewController : GAITrackedViewController<UITableViewDelegate, UITableViewDataSource> {
    Class<FTSection> currentSection;
    int goalType;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withGoalType:(int)goal;


@end
