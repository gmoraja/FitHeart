//
//  SupportStressReductionVideoViewController.m
//  FitHeart
//
//  Created by Bitgears on 23/02/15.
//  Copyright (c) 2015 VPD. All rights reserved.
//

#import "SupportStressReductionVideoViewController.h"
#import "UCFSUtil.h"
#import "SupportSection.h"

@interface SupportStressReductionVideoViewController ()

@end

@implementation SupportStressReductionVideoViewController

@synthesize mainLabel;
@synthesize titleLabel;


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
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[SupportSection title]
                    bkgFileName:[SupportSection navBarBkg]
                      textColor:[SupportSection navBarTextColor]
                 isBackVisibile: NO
     ];
    
    [self setupLeftMenuButton];
    
    mainLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18.0];
    
    mainLabel.text = @"Watch a video on stress reduction.";
    [mainLabel setAccessibilityHint:@"Tap to view the video on youtube.com"];
    [mainLabel sizeToFit];
    
    self.screenName = @"Support Stress Reduction Video Screen";
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [mainLabel addGestureRecognizer:tapGesture];
    mainLabel.userInteractionEnabled = YES;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [mainLabel sizeToFit];
    
}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(backAction:) withTextColor:[SupportSection navBarTextColor]];
}


- (IBAction)backAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated: YES];
}


-(IBAction)handleTap:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/watch?v=OBshy5g8DZw"]];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
