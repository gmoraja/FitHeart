//
//  TutorialViewController.m
//  FitHeart
//
//  Created by Bitgears on 24/09/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "TutorialViewController.h"
#import "AboutSection.h"
#import "UCFSUtil.h"



@interface TutorialViewController () {
    int page;
    int lastpage;
    NSArray* accessibilityValues;
    NSArray* accessibilityLabels;
    
    BOOL isFirstLaunch;
}

@end

@implementation TutorialViewController

@synthesize scrollView;
@synthesize getStartedButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        page = 0;
        lastpage = 0;
        isFirstLaunch = FALSE;
       
        [self initialize];
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFirstLaunch:(BOOL)firstLaunch {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        page = 0;
        lastpage = 0;
        
        isFirstLaunch = TRUE;
        
        [self initialize];
        
    }
    return self;
}

-(void)initialize {
    accessibilityLabels = [NSArray arrayWithObjects:@"Setting a Fitness Goal. Page 1 of 4.",
                           @"Fitness Home Screen. Page 2 of 4.",
                           @"Making a fitness log entry. Page 3 of 4.",
                           @"Viewing Logs. Page 4 of 4.",
                           
                           nil];
    
    
    accessibilityValues = [NSArray arrayWithObjects:@"You can set a goal by dragging a knob in the middle of the screen or tapping a number at the top of the screen to edit with a numeric keyboard. You can change whether to track by minutes or steps by tapping on buttons at the bottom of the screen.",
                           @"By tapping the Main Menu button at the top left of the screen, you can access Health, Mood, Settings, and more. By tapping the top bar of the screen, you can view history. By tapping the options button at the top right of the screen, you can change and set goals and reminders. In the middle of the screen, the weekly status is displayed. Tapping the center of the screen will allow you to view and edit log entries. By tapping the button at the bottom of the screen, you can add a new activity log entry.",
                           @"By tapping on the number at the top of the screen, you can edit with the numeric keypad. By dragging the knob at the center of the screen, you can edit the value. The numeric keypad is an equivalent alternative to using the knob control. By tapping at the lower right side of the screen, you can record your minutes using a timer. By tapping the three bottom buttons, you can change the date, type of activity, and effort level.",
                           @"You can review your logs as a list. You can edit any entry by tapping on it or even delete it by sliding to the left.",
                           
                           nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:@"Tutorial"
                    bkgFileName:[AboutSection navBarBkg]
                      textColor:[AboutSection navBarTextColor]
                 isBackVisibile: NO
     ];
    //scrollView.frame = CGRectMake(0,0,320,[UCFSUtil contentAreaHeight]);
    //scrollView.frame = self.view.bounds;
    getStartedButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    if (isFirstLaunch) {
        getStartedButton.titleLabel.text = @"GET STARTED";
        [getStartedButton setAccessibilityLabel:@"get started"];
    }
    else {
        getStartedButton.titleLabel.text = @"END TUTORIAL";
        [getStartedButton setAccessibilityLabel:@"end tutorial"];
        
    }
    
    [self setupLeftMenuButton];
    //[self setupRightMenuButton];
    
    
    
    CGFloat height = 504;
    NSArray* images = [NSArray arrayWithObjects:@"A4-568h", @"A5-568h", @"A6-568h", @"A7-568h", nil];
    //NSArray* images = [NSArray arrayWithObjects:@"A4", @"A5", @"A6", @"A7", nil];
    if ([UCFSUtil deviceIs3inch]) {
        height = 416;
        images = [NSArray arrayWithObjects:@"A4", @"A5", @"A6", @"A7", nil];
    }
    UIView* pagesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width*4, height)];
    
    
    for (int i=0; i<4; i++) {
        UIImageView* pageView = [[UIImageView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width*i, 0, 320, height)];
        pageView.image = [UIImage imageNamed:[images objectAtIndex:i]];
        pageView.isAccessibilityElement  = YES;
        pageView.accessibilityLabel = [accessibilityLabels objectAtIndex:i];
        pageView.accessibilityValue = [accessibilityValues objectAtIndex:i];
        [pagesView addSubview:pageView];
    }
    
    scrollView.contentInset = UIEdgeInsetsZero;
    [scrollView setContentSize:CGSizeMake(pagesView.frame.size.width, pagesView.frame.size.height)];
    [scrollView addSubview:pagesView];
    scrollView.delegate = self;
    
    
    
    
    [self updateUI];
    
    self.screenName = @"Tutorial Screen";

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupLeftMenuButton{
    [self.navigationItem setLeftBarButtonItem:[UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(backAction:) withTextColor:[AboutSection navBarTextColor] ]];
}

-(void)setupRightMenuButton{
    [self.navigationItem setRightBarButtonItem:[UCFSUtil getNavigationBarNextButtonWithTarget:self action:@selector(nextAction:) withTextColor:[AboutSection navBarTextColor] ]];
}

- (IBAction)getStartedAction:(id)sender {
    UIViewController* viewController = [UCFSUtil getFitnessViewController];
    [self.navigationController pushViewController:viewController animated:NO];
}
     
- (IBAction)backAction:(UIButton*)sender {
    switch(page) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:
        case 2:
        case 3:
            //[scrollView setContentOffset:CGPointMake(320*page, 0) animated:YES];
            [scrollView scrollRectToVisible:CGRectMake(320*(page-1), 0, 320, scrollView.frame.size.height) animated:YES];
            break;
    }

}

- (IBAction)nextAction:(UIButton*)sender {
    switch(page) {
        case 0:
        case 1:
        case 2:
            //[scrollView setContentOffset:CGPointMake(320*page, 0) animated:YES];
            [scrollView scrollRectToVisible:CGRectMake(320*(page+1), 0, 320, scrollView.frame.size.height) animated:YES];
            break;
    }
    
}

-(void)updateUI {
    switch(page) {
        case 0:
            getStartedButton.hidden = YES;
            [self setupRightMenuButton];
            scrollView.accessibilityLabel = @"";
            break;
        case 1:
            getStartedButton.hidden = YES;
            [self setupRightMenuButton];
            scrollView.accessibilityLabel = @"";
            break;
        case 2:
            getStartedButton.hidden = YES;
            [self setupRightMenuButton];
            scrollView.accessibilityLabel = @"";
            break;
        case 3:
            getStartedButton.hidden = NO;
            self.navigationItem.rightBarButtonItem = nil;
            scrollView.accessibilityLabel = @"";
            break;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)sender {
    page = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (page!=lastpage) {
        NSLog(@"page=%i",page);
        lastpage = page;
        [self updateUI];
    }
    
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    NSLog(@"page=%i",page);
}



@end
