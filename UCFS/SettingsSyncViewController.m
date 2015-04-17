//
//  SettingsSyncViewController.m
//  FitHeart
//
//  Created by Bitgears on 15/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "SettingsSyncViewController.h"
#import "SettingsSection.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTSalesForce.h"
#import "FTDatabase.h"
#import "FTAppSettings.h"

static BOOL syncExecuted;

@interface SettingsSyncViewController () {
    UIActivityIndicatorView *indicator;
}

@end

@implementation SettingsSyncViewController

@synthesize syncView;
@synthesize syncFailedLabel;
@synthesize syncNoButton;
@synthesize syncYesButton;
@synthesize syncSuccessLabel;
@synthesize successView;
@synthesize errorView;

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
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    
    
    errorView.hidden = YES;
    successView.hidden = YES;
    
    self.screenName = @"Settings Sync Screen";
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self startSync];
    
}



-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(backAction:) withTextColor:[UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:118.0/255.0]];
}

- (IBAction)backAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)setupRightMenuButton{
}


-(void)startSync {
    errorView.hidden = YES;
    successView.hidden = YES;
    syncView.hidden = NO;
    syncExecuted = FALSE;
    
    indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake( (syncView.frame.size.width-60) / 2, (syncView.frame.size.height-60) / 2, 60, 60)];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setColor:[UIColor blackColor]];
    [syncView addSubview:indicator];
    [indicator startAnimating];
    
    [self syncInBackground:nil];

}

-(void)syncInBackgroundCompleted {
    if (syncExecuted) {
        //SUCCESS
        errorView.hidden = YES;
        successView.hidden = NO;
        syncView.hidden = YES;
        [UCFSUtil trackGAEventWithCategory:@"ui_action" withAction:@"sync data" withLabel:@"success" withValue:[NSNumber numberWithInt:1]];

        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(goToHome:) userInfo:nil repeats:NO];
    }
    else {
        //ERROR
        errorView.hidden = NO;
        successView.hidden = YES;
        syncView.hidden = YES;
        [UCFSUtil trackGAEventWithCategory:@"ui_action" withAction:@"sync data" withLabel:@"failure" withValue:[NSNumber numberWithInt:0]];

    }
}

- (IBAction)goToHome:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)syncInBackground:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        syncExecuted = [UCFSUtil syncData];

        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self syncInBackgroundCompleted];
        });
    });
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

- (IBAction)syncNoAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)syncYesAction:(id)sender {
    [self startSync];
}


@end
