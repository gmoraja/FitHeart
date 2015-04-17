//
//  HealthHomeViewController.h
//  FitHeart
//
//  Created by Bitgears on 01/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthGoalSelectorView.h"
#import "FTNotificationAction.h"
#import "FTSectionHomeViewController.h"


@interface HealthHomeViewController : FTSectionHomeViewController <HealthGoalSelectorDelegate>

- (IBAction)goalButtonAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *contentView;

- (id)initWithAction:(FTNotificationAction*)action;

@end
