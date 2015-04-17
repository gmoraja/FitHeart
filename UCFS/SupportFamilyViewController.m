//
//  SupportFamilyViewController.m
//  FitHeart
//
//  Created by Bitgears on 15/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "SupportFamilyViewController.h"
#import "UCFSUtil.h"
#import "SupportSection.h"

@interface SupportFamilyViewController ()

@end

@implementation SupportFamilyViewController

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
    
    self.screenName = @"Support Family Screen";

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

@end
