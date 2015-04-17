//
//  SupportMindfulnessMeditationViewController.m
//  FitHeart
//
//  Created by Bitgears on 23/02/15.
//  Copyright (c) 2015 VPD. All rights reserved.
//

#import "SupportMindfulnessMeditationViewController.h"
#import "UCFSUtil.h"
#import "SupportSection.h"

@interface SupportMindfulnessMeditationViewController ()

@end

@implementation SupportMindfulnessMeditationViewController

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
    
    [mainLabel sizeToFit];
    
    self.screenName = @"Support Mindfulness Meditation Screen";
    
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
