//
//  SettingsViewController.m
//  FitHeart
//
//  Created by Bitgears on 19/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsSection.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTDialogView.h"
#import "RESwitch.h"
#import "FTAppSettings.h"
#import "FTNotificationManager.h"
#import "SettingsSyncViewController.h"
#import "EulaViewController.h"
#import "FTNotificationManager.h"


@interface SettingsViewController () {
    RESwitch *provideDataSwitchView;
}

@end

@implementation SettingsViewController

@synthesize resetButton;
@synthesize syncButton;
@synthesize anonymousTitleLabel;
@synthesize anonymousDescrLabel;
@synthesize anonymousSwitch;

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
    //[self initSwitch];
    
    [FTNotificationManager listNotification];
    
    anonymousTitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    anonymousDescrLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:14.0];

    
    [FTNotificationManager listNotification];
    
    self.screenName = @"Settings Screen";

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[SettingsSection title]
                    bkgFileName:[SettingsSection navBarBkg]
                      textColor:[SettingsSection navBarTextColor]
                 isBackVisibile: NO
     ];
    
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    [self.mm_drawerController setMaximumRightDrawerWidth:200.0];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];

    
}



-(void)setupLeftMenuButton{
    [self.navigationItem setLeftBarButtonItem:[UCFSUtil getNavigationBarMenuDarkButton:nil withTarget:self action:@selector(menuAction:)] animated:YES];
}

- (IBAction)menuAction:(UIButton*)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)setupRightMenuButton{
}


- (IBAction)resetButtonAction:(id)sender {

    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"All user data will be permanently deleted." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete User Data" otherButtonTitles:nil, nil];
    [popupQuery showInView:self.view];
    

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self performReset];
    }
}

-(void)performReset {
    //show loading
    FTDialogView *dialogView = [[FTDialogView alloc] initFullscreen];
    dialogView.delegate = self;
    [self.parentViewController.view addSubview:dialogView];
    //reset data
    [FTAppSettings reset];
    [dialogView popupText:@"Data reset successfully"];
}

- (void)dialogPopupFinished:(UIView*)dialogView {
    //hide loading
    [dialogView removeFromSuperview];
    
    //GO TO FIRST LAUNCH
    EulaViewController* viewController = [[EulaViewController alloc] initWithNibName:@"EulaView" bundle:nil];
    [self.navigationController pushViewController:viewController animated:NO];
    
}

- (void)switchViewChanged:(RESwitch *)switchView
{
    [FTAppSettings setProvidingData:(switchView.on)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)syncButtonAction:(id)sender {
    SettingsSyncViewController* viewController = [[SettingsSyncViewController alloc] initWithNibName:@"SettingsSyncView" bundle:nil];
    [self.navigationController pushViewController:viewController animated:NO];
}

-(void)enableScreen {
    if (screenMaskView==nil)
        screenMaskView = [[ScreenMaskView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:screenMaskView];
}

-(void)disableScreen {
    if (screenMaskView!=nil)
        [screenMaskView removeFromSuperview];
}



@end
