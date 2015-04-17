//
//  OrientationViewController.h
//  FitHeart
//
//  Created by Bitgears on 09/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OrientationViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *context1Label;
@property (strong, nonatomic) IBOutlet UILabel *context2Label;
@property (strong, nonatomic) IBOutlet UILabel *fitnessLabel;
@property (strong, nonatomic) IBOutlet UILabel *healthLabel;
@property (strong, nonatomic) IBOutlet UILabel *moodLabel;

@end
