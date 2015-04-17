//
//  FitnessEndOfWeekViewController.h
//  FitHeart
//
//  Created by Bitgears on 03/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FitnessEndOfWeekViewController : UIViewController
- (IBAction)continueAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;

@end
