//
//  LateralMenuViewController.m
//  FitHeart
//
//  Created by Bitgears on 12/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "LateralMenuViewController.h"
#import "MenuItem.h"
#import "UCFSUtil.h"
#import "SettingsViewController.h"
#import "FitnessHomeViewController.h"
#import "HealthHomeViewController.h"
#import "MoodHomeViewController.h"
#import "AboutViewController.h"
#import "LearnMoreHomeViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "SupportHomeViewController.h"
#import "MenuTableViewCell.h"
#import "FitnessSection.h"
#import "FitnessIntroViewController.h"

static float CELL_HEIGHT = 66;
static float CELL_HEIGHT_2 = 50;

@interface LateralMenuViewController () {
    MenuItem *fitnessMenuItem;
    MenuItem *healthMenuItem;
    MenuItem *moodMenuItem;
    
    float menuNoneSpaceH;
}

@end

@implementation LateralMenuViewController

@synthesize menuTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        fitnessMenuItem = [[MenuItem alloc] initWithTitle:@"FITNESS" thumbImageFileName:@"fitness_icon" thumbOnImageFileName:@"fitness_icon_act" withType:MENU_FITNESS ];
        healthMenuItem = [[MenuItem alloc] initWithTitle:@"HEALTH" thumbImageFileName:@"health_icon" thumbOnImageFileName:@"health_icon_act" withType:MENU_HEALTH ];
        moodMenuItem = [[MenuItem alloc] initWithTitle:@"MOOD" thumbImageFileName:@"mood_icon" thumbOnImageFileName:@"mood_icon_act"  withType:MENU_MOOD ];
        MenuItem *spaceItem = [[MenuItem alloc] initWithTitle:@"" thumbImageFileName:@"" withType:MENU_NONE];
        MenuItem *learnMore = [[MenuItem alloc] initWithTitle:@"Learn More" thumbImageFileName:@"learn_more_icon" thumbOnImageFileName:@"learn_more_icon_act" withType:MENU_LEARNMORE];
        MenuItem *about = [[MenuItem alloc] initWithTitle:@"About" thumbImageFileName:@"about_icon" thumbOnImageFileName:@"about_icon_act" withType:MENU_ABOUT];
        MenuItem *support = [[MenuItem alloc] initWithTitle:@"Support" thumbImageFileName:@"support_icon" thumbOnImageFileName:@"support_icon_act" withType:MENU_SUPPORT];
        MenuItem *settings = [[MenuItem alloc] initWithTitle:@"Settings" thumbImageFileName:@"settings_icon" thumbOnImageFileName:@"settings_icon_act" withType:MENU_SETTING];
        //items = [NSMutableArray arrayWithObjects:fitnessMenuItem, learnMore, about, settings, nil];
        items = [NSMutableArray arrayWithObjects:fitnessMenuItem, healthMenuItem, moodMenuItem, spaceItem, learnMore, support, about, settings, nil];
        itemFont = [UIFont fontWithName:@"SourceSansPro-Light" size:20.0];
        
        bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:73.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
        //bgColorView.layer.cornerRadius = 7;
        bgColorView.layer.masksToBounds = YES;
        
        bgEmptyView = [[UIView alloc] init];
        bgEmptyView.backgroundColor = [UIColor clearColor];
        bgEmptyView.layer.masksToBounds = YES;
        
        
        separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hor_sep"]];
        separator.frame = CGRectMake(40, 20, 320, 1);
        
        menuNoneSpaceH = 120;
        if ([UCFSUtil deviceIs3inch]) menuNoneSpaceH = 50;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [menuTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([UCFSUtil deviceSystemIOS7]) {
        menuTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([menuTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [menuTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [menuTableView selectRowAtIndexPath:indexPath
                                 animated:YES
                           scrollPosition:UITableViewScrollPositionNone];


}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, menuTableView);
    
    UINavigationController* navController = (UINavigationController*)([self.mm_drawerController centerViewController]);
    UIViewController *sourceViewController = [navController visibleViewController];
    if ([sourceViewController respondsToSelector:@selector(enableScreen)])
        [sourceViewController performSelector:@selector(enableScreen) ];
    
    //mainViewController.view.userInteractionEnabled = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
    UINavigationController* navController = (UINavigationController*)([self.mm_drawerController centerViewController]);
    UIViewController *sourceViewController = [navController visibleViewController];
    if ([sourceViewController respondsToSelector:@selector(disableScreen)]) {
        [sourceViewController performSelector:@selector(disableScreen)];
    }
    
    
    [super viewDidDisappear:animated];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [items count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=0 && indexPath.row<3)
        return CELL_HEIGHT;
    else
        if (indexPath.row==3)
            return menuNoneSpaceH;
        else
            return CELL_HEIGHT_2;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MenuTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    MenuItem *item = [items objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier withMenuItem:item];
        
        if (item!=nil) {
            cell.indentationWidth = 20;
            cell.textLabel.font = itemFont;
            [cell setSelectedBackgroundView:bgEmptyView];
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.textLabel.text = item.title;
            cell.textLabel.textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
            cell.imageView.image = item.thumbImage;
            
        }


    }
    if (item.menuType==MENU_NONE) {
        [cell setIsAccessibilityElement:NO];
        cell.userInteractionEnabled = NO;
    }
   

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem *item = [items objectAtIndex:indexPath.row];
    if (item!=nil && item.menuType!=MENU_NONE) {
        UINavigationController* navController = (UINavigationController*)([self.mm_drawerController centerViewController]);
        UIViewController *sourceViewController = [navController visibleViewController];
        UIViewController *viewController = nil;
        
        switch (item.menuType) {
            case MENU_FITNESS:
            if ([sourceViewController isMemberOfClass:[FitnessHomeViewController class]]==FALSE) {
                [navController popViewControllerAnimated:NO];
                //check if there are goal
                viewController = [UCFSUtil getFitnessViewController];
                [navController pushViewController:viewController animated:NO];
            }
            break;
            case MENU_HEALTH:
            if ([sourceViewController isMemberOfClass:[HealthHomeViewController class]]==FALSE) {
                [navController popViewControllerAnimated:NO];
                viewController = [UCFSUtil getViewControllerWithSection:SECTION_HEALTH withAction:nil];
                [navController pushViewController:viewController animated:NO];
            }
            break;
            case MENU_MOOD:
            if ([sourceViewController isMemberOfClass:[MoodHomeViewController class]]==FALSE) {
                [navController popViewControllerAnimated:NO];
                viewController = [UCFSUtil getViewControllerWithSection:SECTION_MOOD withAction:nil];
                [navController pushViewController:viewController animated:NO];
            }
            break;
            case MENU_LEARNMORE:
            if ([sourceViewController isMemberOfClass:[LearnMoreHomeViewController class]]==FALSE) {
                [navController popViewControllerAnimated:NO];
                viewController = [[LearnMoreHomeViewController alloc] initWithNibName:@"LearnMoreHomeView" bundle:nil];
                [navController pushViewController:viewController animated:NO];
            }
            break;
            case MENU_SUPPORT:
                if ([sourceViewController isMemberOfClass:[SupportHomeViewController class]]==FALSE) {
                    [navController popViewControllerAnimated:NO];
                    viewController = [[SupportHomeViewController alloc] initWithNibName:@"SupportHomeView" bundle:nil];
                    [navController pushViewController:viewController animated:NO];
                }
                break;
            case MENU_ABOUT:
            if ([sourceViewController isMemberOfClass:[AboutViewController class]]==FALSE) {
                [navController popViewControllerAnimated:NO];
                viewController = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil];
                [navController pushViewController:viewController animated:NO];
            }
            break;
            case MENU_SETTING:
            if ([sourceViewController isMemberOfClass:[SettingsViewController class]]==FALSE) {
                [navController popViewControllerAnimated:NO];
                viewController = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
                [navController pushViewController:viewController animated:NO];
            }
            break;
        }
        //[tableView deselectRowAtIndexPath:indexPath animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }

}

-(void)replaceSectionMenuItem:(int)section {
    /*
    MenuItem* newMenuItem = nil;
    switch (section) {
        case SECTION_FITNESS:   newMenuItem = fitnessMenuItem; break;
        case SECTION_HEALTH:    newMenuItem = healthMenuItem; break;
        case SECTION_NUTRITION: newMenuItem = nutritionMenuItem; break;
        case SECTION_MOOD:      newMenuItem = moodMenuItem; break;
    }
    
    [items replaceObjectAtIndex:0 withObject:newMenuItem];
    [menuTableView reloadData];
     */
}

-(void)selectMenuItem:(int)item {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:item inSection:0];
    [menuTableView selectRowAtIndexPath:indexPath
                               animated:YES
                         scrollPosition:UITableViewScrollPositionNone];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
