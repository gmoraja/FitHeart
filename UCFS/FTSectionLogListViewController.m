//
//  FTSectionLogListViewController.m
//  FitHeart
//
//  Created by Bitgears on 05/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTSectionLogListViewController.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTSectionLogViewController.h"


@interface FTSectionLogListViewController () {
    NSString* logNibName;

}

@end

@implementation FTSectionLogListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withLogNibName:(NSString*)logNib
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = section;
        logNibName = logNib;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    int goal = [currentSection getCurrentGoal];
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[currentSection title]
                    bkgFileName:[currentSection navBarBkg:goal]
                      textColor:[currentSection mainColor:goal]
                 isBackVisibile: YES
     ];
    [self setupLeftMenuButton];
    
    float offset_y = 40;
    if ([UCFSUtil deviceSystemIOS7]) offset_y = 0;
    CGRect containerFrame = CGRectMake(0, offset_y, 320, [UCFSUtil contentAreaHeight]);
    containerView = [[FTLogListContainerView alloc] initWithFrame:containerFrame
                                                       withSection:currentSection
                                                      withGoalType:[currentSection getCurrentGoal]
                         ];
    [self.view addSubview:containerView];
    containerView.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [containerView updateData];
}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarBackButtonWithTarget:self action:@selector(cancelAction:)];
}

- (IBAction)cancelAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

-(void)updateUI {
    
    int goal = [currentSection getCurrentGoal];
    FTGoalData* goalData = [currentSection goalDataWithType:(int)goal];
    if (goalData==nil) goalData = [currentSection defaultGoalDataWithType:(int)goal];
    
    //NSMutableArray* entries = [currentSection loadEntries:dateType withGoalType:goal];
    
    
    //[containerView updateWithGoalData:goalData];
    
}

-(void)editLog:(FTLogData*)logData {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    FTSectionLogViewController *viewController = [[FTSectionLogViewController alloc] initWithNibName:logNibName bundle:nil withSection:currentSection withLogData:logData];
    
    [self.navigationController pushViewController:viewController animated:NO];
    
}

- (void)buttonEntryTouchWithDate:(FTLogData*)logData {
    [self editLog:logData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
