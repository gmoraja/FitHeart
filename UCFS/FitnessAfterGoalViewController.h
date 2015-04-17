//
//  FitnessAfterGoalViewController.h
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FitnessAfterGoalViewController : UIViewController
- (IBAction)continueButtonAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *goalreachedImageView;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil asReached:(BOOL)reached asEndOfWeek:(BOOL)endOfWeek;

+ (NSString*)getCongratulatoryMessageGoalNotReached;
+ (NSString*)getCongratulatoryMessageGoalReached;
+ (NSString*)getEducationMessageGoalNotReached;
+ (NSString*)getEducationMessageGoalReached;

@end
