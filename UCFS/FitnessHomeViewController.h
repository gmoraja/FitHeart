//
//  FitnessHomeViewController.h
//  FitHeart
//
//  Created by Bitgears on 11/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSectionHomeViewController.h"


@interface FitnessHomeViewController : FTSectionHomeViewController


- (IBAction)addAction:(UIButton*)sender;
- (IBAction)goalButtonAction:(id)sender;
- (IBAction)continueAction:(id)sender;
- (IBAction)setNewGoalYesAction:(id)sender;
- (IBAction)setNewGoalNoAction:(id)sender;



@property (strong, nonatomic) IBOutlet UIView *standardView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *addActivityButton;
@property (strong, nonatomic) IBOutlet UIView *endOfWeekView;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UIView *setNewGoalView;

@property (strong, nonatomic) IBOutlet UIButton *setNewGoalYesButton;
@property (strong, nonatomic) IBOutlet UIButton *setNewGoalNoButton;
@property (strong, nonatomic) IBOutlet UILabel *setNewGoalTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *setNewGoalSubtitleLabel;

- (id)initWithAction:(FTNotificationAction*)action;
- (void)buttonNewGoalTouch;

@end
