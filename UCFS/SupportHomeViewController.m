//
//  SupportHomeViewController.m
//  FitHeart
//
//  Created by Bitgears on 12/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "SupportHomeViewController.h"
#import "MenuItem.h"
#import "UCFSUtil.h"
#import "SupportSection.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "LateralMenuViewController.h"
#import "SupportMindfulnessViewController.h"
#import "SupportPeopleLikeYouViewController.h"
#import "SupportHealthProvidersViewController.h"
#import "SupportFamilyViewController.h"
#import "SupportMindfulnessMeditationViewController.h"
#import "SupportStressReductionVideoViewController.h"
#import "SupportCompassionMeditationViewController.h"
#import "AppDelegate.h"


static float cellHeight = 80;


@interface SupportHomeViewController () {
    UIView *menuBgColorView;
    UIFont *menuItemFont;

}

@end

@implementation SupportHomeViewController

@synthesize menuTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        MenuItem *item1 = [[MenuItem alloc] initWithTitle:@"Mindfulness Audio" thumbImageFileName:@"" withType:MENU_SUPPORT_MINDFULNESSAUDIO ];
        MenuItem *item2 = [[MenuItem alloc] initWithTitle:@"Mindfulness Meditation" thumbImageFileName:@"" withType:MENU_SUPPORT_MINDFULNESSMEDITATION ];
        MenuItem *item3 = [[MenuItem alloc] initWithTitle:@"Compassion Meditation" thumbImageFileName:@"" withType:MENU_SUPPORT_COMPASSIONMEDITATION ];
        MenuItem *item4 = [[MenuItem alloc] initWithTitle:@"Stress Reduction Video" thumbImageFileName:@"" withType:MENU_SUPPORT_STRESSREDUCTIONVIDEO];
        MenuItem *item5 = [[MenuItem alloc] initWithTitle:@"People Like You" thumbImageFileName:@"" withType:MENU_SUPPORT_PEOPLELIKEYOU];
        MenuItem *item6 = [[MenuItem alloc] initWithTitle:@"Family and Friends" thumbImageFileName:@"" withType:MENU_SUPPORT_FAMILY];
        MenuItem *item7 = [[MenuItem alloc] initWithTitle:@"Health Providers" thumbImageFileName:@"" withType:MENU_SUPPORT_HEALTHPROVIDERS];
        
        menuItems = [NSMutableArray arrayWithObjects:item1, item2, item3, item4, item5, item6, item7, nil];
        menuItemFont = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
        
      
        menuBgColorView = [[UIView alloc] init];
        menuBgColorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];//[MoodSection lightColor];
        menuBgColorView.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.wantsFullScreenLayout = YES;
    
    [self.mm_drawerController setMaximumRightDrawerWidth:200.0];
    
    
    //MENU
    [menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if ([menuTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [menuTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    self.screenName = @"Support Screen";
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[SupportSection title]
                    bkgFileName:[SupportSection navBarBkg]
                      textColor:[SupportSection navBarTextColor]
                 isBackVisibile: NO
     ];
    [self setupLeftMenuButton];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    /*
     UIImageView* bkgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, contentView.frame.size.width, contentView.frame.size.height)];
     [bkgView setImage:[UIImage imageNamed:@"fade_screen_overlay"]];
     [contentView addSubview:bkgView];
     */
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate selectMenuItem:5];

    
}


-(void)setupLeftMenuButton{
    [self.navigationItem setLeftBarButtonItem:[UCFSUtil getNavigationBarMenuDarkButton:nil withTarget:self action:@selector(menuAction:)] animated:YES];
}


- (IBAction)menuAction:(UIButton*)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MenuSupportTableItem";
    MenuItem *item = [menuItems objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, cellHeight)];
        mainView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
        
        float offset_x = 16;
        UILabel * mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_x, (cellHeight-30)/2, 320-offset_x, 30)];
        mainLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1];
        mainLabel.font = menuItemFont;
        mainLabel.text = item.title;
        mainLabel.backgroundColor = [UIColor clearColor];
        [mainView addSubview:mainLabel];
        
        UIView* menuSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-1.5, 320, 1.5)];
        menuSeparatorView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];

        
        [cell.contentView addSubview:mainView];
        
        [cell.contentView addSubview:menuSeparatorView];
    }
    
    
    [cell setSelectedBackgroundView:menuBgColorView];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem *item = [menuItems objectAtIndex:indexPath.row];
    UIViewController* viewController;
    switch (item.menuType) {
        case MENU_SUPPORT_MINDFULNESSAUDIO:
            viewController = [[SupportMindfulnessViewController alloc] initWithNibName:@"SupportMindfulnessView" bundle:nil];
            break;
        case MENU_SUPPORT_MINDFULNESSMEDITATION:
            viewController = [[SupportMindfulnessMeditationViewController alloc] initWithNibName:@"SupportMindfulnessMeditationView" bundle:nil];
            break;
        case MENU_SUPPORT_COMPASSIONMEDITATION:
            viewController = [[SupportCompassionMeditationViewController alloc] initWithNibName:@"SupportCompassionMeditationView" bundle:nil];
            break;
        case MENU_SUPPORT_STRESSREDUCTIONVIDEO:
            viewController = [[SupportStressReductionVideoViewController alloc] initWithNibName:@"SupportStressReductionVideoView" bundle:nil];
            break;
        case MENU_SUPPORT_PEOPLELIKEYOU:
            viewController = [[SupportPeopleLikeYouViewController alloc] initWithNibName:@"SupportPeopleLikeYouView" bundle:nil];
            break;
        case MENU_SUPPORT_FAMILY:
            viewController = [[SupportFamilyViewController alloc] initWithNibName:@"SupportFamilyView" bundle:nil];
            break;
        case MENU_SUPPORT_HEALTHPROVIDERS:
            viewController = [[SupportHealthProvidersViewController alloc] initWithNibName:@"SupportHealthProvidersView" bundle:nil];
            break;
    }
    
    [self goTo:viewController];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)goTo:(UIViewController*)viewController {
    
    if (viewController!=nil) {
        CATransition* transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        [self.navigationController pushViewController:viewController animated:NO];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
