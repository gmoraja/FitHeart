//
//  FitnessEndOfWeekViewController.m
//  FitHeart
//
//  Created by Bitgears on 03/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FitnessEndOfWeekViewController.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"

@interface FitnessEndOfWeekViewController ()

@end

@implementation FitnessEndOfWeekViewController

@synthesize continueButton;
@synthesize subtitleLabel;
@synthesize textLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    
    textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    subtitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0];
    continueButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[FitnessSection title]
                    bkgFileName:[FitnessSection navBarBkg:0]
                      textColor:[UIColor whiteColor]
                 isBackVisibile: YES
     ];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)continueAction:(id)sender {
}



@end
