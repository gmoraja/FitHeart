//
//  HealthGoalHomeViewController.h
//  FitHeart
//
//  Created by Bitgears on 08/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSectionHomeViewController.h"

@interface HealthGoalHomeViewController : FTSectionHomeViewController {
    
    int currentGoalType;
    
}

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIButton *bottomButton;
- (IBAction)bottomButtonAction:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withGoalType:(int)goalType;


@end
