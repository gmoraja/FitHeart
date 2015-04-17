//
//  SupportCompassionMeditationViewController.m
//  FitHeart
//
//  Created by Bitgears on 23/02/15.
//  Copyright (c) 2015 VPD. All rights reserved.
//

#import "SupportCompassionMeditationViewController.h"
#import "UCFSUtil.h"
#import "SupportSection.h"

@interface SupportCompassionMeditationViewController ()

@end

@implementation SupportCompassionMeditationViewController

@synthesize mainLabel;
@synthesize titleLabel;
@synthesize scrollview;

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
    
    mainLabel.text = @"Goal: Increase compassion for yourself and others.\n\n1) Repeat these phrases to yourself for a minute or two:\n\n\u2022 May I be happy.\n\u2022 May I be well.\n\u2022 May I be safe.\n\u2022 May I be peaceful and at ease.\n\n2) Visualize extending this energy to include somebody you care deeply about. Repeat the phrases, filling in the person’s name (instead of I).\n\n3) Now extend the energy to somebody for whom you have negative feelings. Repeat the phrases with his or her name.\n\n4) Finally, visualize extending this energy to the rest of the world.";
    
    [mainLabel sizeToFit];
    
    self.screenName = @"Support Compassion Meditation Screen";
    
    scrollview.contentInset = UIEdgeInsetsZero;
    [scrollview setContentSize:CGSizeMake(mainLabel.frame.size.width, mainLabel.frame.size.height)];
    scrollview.delegate = self;
    
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


-(void)scrollViewDidScroll:(UIScrollView *)sender {
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
