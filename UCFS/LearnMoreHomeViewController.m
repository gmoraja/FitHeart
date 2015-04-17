//
//  LearnMoreHomeViewController.m
//  FitHeart
//
//  Created by Bitgears on 17/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "LearnMoreHomeViewController.h"
#import "MenuItem.h"
#import "UCFSUtil.h"
#import "LearnMoreSection.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "LateralMenuViewController.h"
#import "LearnMoreContentViewController.h"

static float cellHeight = 75;

@interface LearnMoreHomeViewController () {

    UIView *menuBgColorView;
    UIFont *menuItemFont;
    
}

@end

@implementation LearnMoreHomeViewController

@synthesize contentView;
@synthesize menuTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        MenuItem *item1 = [[MenuItem alloc] initWithTitle:@"FITNESS" thumbImageFileName:@"learnmore_icon_fitness" withType:MENU_LEARNMORE_FITNESS ];
        MenuItem *item2 = [[MenuItem alloc] initWithTitle:@"HEALTH" thumbImageFileName:@"learnmore_icon_health" withType:MENU_LEARNMORE_HEALTH];
        MenuItem *item3 = [[MenuItem alloc] initWithTitle:@"NUTRITION" thumbImageFileName:@"learnmore_icon_nutrition" withType:MENU_LEARNMORE_NUTRITION];
        MenuItem *item4 = [[MenuItem alloc] initWithTitle:@"MOOD" thumbImageFileName:@"learnmore_icon_mood" withType:MENU_LEARNMORE_MOOD];
        
        menuItems = [NSMutableArray arrayWithObjects:item1, item2, item3, item4, nil];
        menuItemFont = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
        
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
    self.screenName = @"Learn More Screen";

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[LearnMoreSection title]
                    bkgFileName:[LearnMoreSection navBarBkg]
                      textColor:[LearnMoreSection navBarTextColor]
                 isBackVisibile: NO
     ];
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    /*
    UIImageView* bkgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, contentView.frame.size.width, contentView.frame.size.height)];
    [bkgView setImage:[UIImage imageNamed:@"fade_screen_overlay"]];
    [contentView addSubview:bkgView];
     */
}


-(void)setupLeftMenuButton{
    [self.navigationItem setLeftBarButtonItem:[UCFSUtil getNavigationBarMenuDarkButton:nil withTarget:self action:@selector(menuAction:)] animated:YES];
}

-(void)setupRightMenuButton{
    //self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarAddButton:nil withTarget:self action:@selector(addAction:)];
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
    static NSString *simpleTableIdentifier = @"MenuLearnMoreTableItem";
    MenuItem *item = [menuItems objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        UIView *mainView = [[UIView alloc] initWithFrame:cell.frame];
        //mainView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
        mainView.backgroundColor = [UIColor clearColor];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, (cellHeight-item.thumbImage.size.height)/2, item.thumbImage.size.width, item.thumbImage.size.height)];
        imageView.image = item.thumbImage;
        cell.imageView.image = nil;
        [mainView addSubview:imageView];
        
        UILabel * mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(100+item.thumbImage.size.width+10, (cellHeight-30)/2, 320, 30)];
        mainLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        mainLabel.font = menuItemFont;
        mainLabel.text = item.title;
        mainLabel.backgroundColor = [UIColor clearColor];
        [mainLabel setIsAccessibilityElement:YES];
        [mainLabel setAccessibilityLabel:[NSString stringWithFormat:@"%@ button", item.title]];
        [mainLabel setAccessibilityHint:[NSString stringWithFormat:@"Tap to learn more about %@", item.title]];
        [mainView addSubview:mainLabel];
        
        [cell.contentView addSubview:mainView];
        
        
        UIView* menuSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, cellHeight-1.5, 320, 1.5)];
        menuSeparatorView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];

        [cell.contentView addSubview:menuSeparatorView];
    }
    
    
    [cell setSelectedBackgroundView:menuBgColorView];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem *item = [menuItems objectAtIndex:indexPath.row];
    LearnMoreContentViewController *viewController = [[LearnMoreContentViewController alloc] initWithNibName:@"LearnMoreContentView" bundle:nil];
    switch (item.menuType) {
        case MENU_LEARNMORE_FITNESS:
            viewController.sectionId = SECTION_FITNESS;
            break;
        case MENU_LEARNMORE_HEALTH:
            viewController.sectionId = SECTION_HEALTH;
            break;
        case MENU_LEARNMORE_MOOD:
            viewController.sectionId = SECTION_MOOD;
            break;
        case MENU_LEARNMORE_NUTRITION:
            viewController.sectionId = 4;
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

@end
