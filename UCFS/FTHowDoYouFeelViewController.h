//
//  FTHowDoYouFeelViewController.h
//  FitHeart
//
//  Created by Bitgears on 03/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"

@interface FTHowDoYouFeelViewController : UIViewController {
    Class<FTSection> currentSection;
}


- (IBAction)moodAction:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withLog:(FTLogData*)logData;
- (IBAction)bottomButtonAction:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *bottomButton;
@property (strong, nonatomic) IBOutlet UIButton *smile1Button;
@property (strong, nonatomic) IBOutlet UIButton *smile2Button;
@property (strong, nonatomic) IBOutlet UIButton *smile3Button;
@property (strong, nonatomic) IBOutlet UIButton *smile4Button;
@property (strong, nonatomic) IBOutlet UIButton *smile5Button;
@property (strong, nonatomic) IBOutlet UIImageView *line1ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *line2ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *line3ImageView;
@property (strong, nonatomic) IBOutlet UIImageView *line4ImageView;

@end
