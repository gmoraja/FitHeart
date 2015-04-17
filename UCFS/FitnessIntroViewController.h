//
//  FitnessIntroViewController.h
//  FitHeart
//
//  Created by Bitgears on 23/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FitnessIntroViewController : UIViewController {
    BOOL isNewWeek;
}

@property (strong, nonatomic) IBOutlet UIButton *setgoalButton;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *text1Label;
@property (strong, nonatomic) IBOutlet UILabel *text2Label;
- (IBAction)setgoalAction:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil asNewWeek:(BOOL)newWeek;

@end
