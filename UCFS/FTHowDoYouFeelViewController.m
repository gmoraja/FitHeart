//
//  FTHowDoYouFeelViewController.m
//  FitHeart
//
//  Created by Bitgears on 03/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTHowDoYouFeelViewController.h"
#import "FitnessIntroViewController.h"
#import "MoodAfterLogViewController.h"
#import "UCFSUtil.h"
#import "FTAppSettings.h"

@interface FTHowDoYouFeelViewController () {
    FTLogData* editableLogData;
}

@end

@implementation FTHowDoYouFeelViewController

@synthesize bottomButton;

@synthesize smile1Button;
@synthesize smile2Button;
@synthesize smile3Button;
@synthesize smile4Button;
@synthesize smile5Button;
@synthesize line1ImageView;
@synthesize line2ImageView;
@synthesize line3ImageView;
@synthesize line4ImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = section;
        editableLogData = nil;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withLog:(FTLogData*)logData {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = section;
        editableLogData = logData;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    // Do any additional setup after loading the view.
    
    bottomButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    
    if ([UCFSUtil deviceIs3inch]) {
        float w = 60;
        float h = 56;
        float offsetY = 10;
        CGRect rect1 = CGRectMake((320-w)/2, smile1Button.frame.origin.y-(offsetY*4), w, h);
        CGRect rect2 = CGRectMake((320-w)/2, smile2Button.frame.origin.y-(offsetY*3), w, h);
        CGRect rect3 = CGRectMake((320-w)/2, smile3Button.frame.origin.y-(offsetY*2), w, h);
        CGRect rect4 = CGRectMake((320-w)/2, smile4Button.frame.origin.y-(offsetY*1), w, h);
        CGRect rect5 = CGRectMake((320-w)/2, smile5Button.frame.origin.y-(offsetY*0), w, h);
        
        smile1Button.frame = rect1;
        smile2Button.frame = rect2;
        smile3Button.frame = rect3;
        smile4Button.frame = rect4;
        smile5Button.frame = rect5;
        
        w = line1ImageView.frame.size.width;
        h = line1ImageView.frame.size.height;
        CGRect lrect1 = CGRectMake((320-w)/2, line1ImageView.frame.origin.y-(offsetY*1), w, h);
        CGRect lrect2 = CGRectMake((320-w)/2, line2ImageView.frame.origin.y-(offsetY*2), w, h);
        CGRect lrect3 = CGRectMake((320-w)/2, line3ImageView.frame.origin.y-(offsetY*3), w, h);
        CGRect lrect4 = CGRectMake((320-w)/2, line4ImageView.frame.origin.y-(offsetY*4), w, h);
        line1ImageView.frame = lrect1;
        line2ImageView.frame = lrect2;
        line3ImageView.frame = lrect3;
        line4ImageView.frame = lrect4;
    }
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)moodAction:(id)sender {
    UIButton* button = (UIButton*)sender;
    
    FTLogData* logData;
    if (editableLogData!=nil) {
        logData = editableLogData;
        logData.logValue = button.tag-1;
        logData.uploadedToServer = 0;
    }
    else {
        //insert log
        logData = [[FTLogData alloc] init];
        logData.logValue = button.tag-1;
        logData.section = 2; //mood
        logData.goalType = 0;
        logData.insertDate = [NSDate date];
        logData.activity = 0;
        logData.effort = 0;
        logData.meal = 0;
    }
    [currentSection saveLogData:logData ];
    
    [UCFSUtil trackGAEventWithCategory:@"ui_action" withAction:@"mood" withLabel:@"open" withValue:[NSNumber numberWithInt:logData.logValue]];

    
    //go to dest
    if ([currentSection sectionType]==SECTION_FITNESS) {
        [FTAppSettings setStartNewWeek:TRUE];
        UIViewController* controller = [[FitnessIntroViewController alloc] initWithNibName:@"FitnessIntroView" bundle:nil asNewWeek:TRUE];
        [self.navigationController pushViewController:controller animated:FALSE];
    }
    else {
        UIViewController* controller = [[MoodAfterLogViewController alloc] initWithNibName:@"MoodAfterLogView" bundle:nil withMood:logData.logValue];
        [self.navigationController pushViewController:controller animated:FALSE];
    }

}

- (IBAction)bottomButtonAction:(id)sender {
    /*
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
     */

    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:NO];
}




@end
