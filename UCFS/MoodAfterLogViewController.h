//
//  MoodAfterGoalViewController.h
//  FitHeart
//
//  Created by Bitgears on 05/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoodAfterLogViewController : UIViewController {
    
}

@property (strong, nonatomic) IBOutlet UIImageView *moodImageView;
@property (strong, nonatomic) IBOutlet UILabel *moodMessageLabel;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;
- (IBAction)continueAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *supportAction;
- (IBAction)supportAction:(id)sender;

+ (NSString*)getMoodInspirationalMessage;
+ (NSString*)getMoodActivationMessage;
+ (NSString*)getMoodReinforcementMessage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withMood:(int)mood;

@end
