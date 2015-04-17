//
//  NutritionHomeViewController.h
//  FitHeart
//
//  Created by Bitgears on 27/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSectionHomeViewController.h"


@interface NutritionHomeViewController : FTSectionHomeViewController


- (IBAction)addAction:(UIButton*)sender;
- (IBAction)goalButtonAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *goalTab;

- (id)initWithAction:(FTNotificationAction*)action;

@end
