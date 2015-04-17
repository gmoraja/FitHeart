//
//  EulaViewController.m
//  UCFS
//
//  Created by Bitgears on 30/10/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "EulaViewController.h"
#import "EulaSection.h"
#import "StudyIdViewController.h"
#import "UCFSUtil.h"
#import "FTAppSettings.h"

@interface EulaViewController ()

@end

@implementation EulaViewController

@synthesize footerImageView;
@synthesize contentText1Label;
@synthesize contentText2Label;
@synthesize contentText3Label;
@synthesize iagreeButton;
@synthesize scrollView;
@synthesize contentView;
@synthesize actionLabel;
@synthesize maskImageView;

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
                          title:[EulaSection title]
                    bkgFileName:[EulaSection navBarBkg]
                      textColor:[UIColor blackColor]
                 isBackVisibile: NO
     ];
    
    footerImageView.backgroundColor = [EulaSection footerColor];
    iagreeButton.backgroundColor = [EulaSection lightColor];
    [scrollView layoutIfNeeded];
    //scroller.frame = self.view.frame;
    scrollView.contentSize = contentView.bounds.size;
    maskImageView.hidden = [UCFSUtil deviceIs3inch]==NO;
    
    contentText1Label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    contentText2Label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    contentText3Label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    actionLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:14.0];
    iagreeButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0];
    
    self.screenName = @"Eula Screen";

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)iagreeAction:(id)sender {
    [FTAppSettings confirmEula];
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    
    StudyIdViewController *viewController = [[StudyIdViewController alloc] initWithNibName:@"StudyIdView" bundle:nil];
    
    [self.navigationController pushViewController:viewController animated:NO];
}




@end
