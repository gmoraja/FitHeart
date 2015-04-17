//
//  HealthHistoryViewController.m
//  FitHeart
//
//  Created by Bitgears on 09/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "HealthHistoryViewController.h"
#import "UCFSUtil.h"
#import "HealthHistoryCellView.h"
#import "HealthSection.h"


static float HEADER_HEIGHT = 46;
static float TABLE_ROW_HEIGHT = 51;
static float INFO_WIDTH = 78.0;

@interface HealthHistoryViewController () {
    NSMutableArray *items;
    
    UIView* headerView;
    UITableView* listTableView;
    
    float minValue;
    float maxValue;
    
}

@end

@implementation HealthHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withGoalType:(int)goal
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = section;
        goalType = goal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    NSString* title = [NSString stringWithFormat:@"%@ HISTORY", [HealthSection logTitle:goalType]];
    if (goalType==HEALTH_GOAL_CHOLESTEROL_LDL)
        title = @"LDL HISTORY";
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:title 
                    bkgFileName:[currentSection navBarBkg:0]
                      textColor:[currentSection navBarTextColor:0]
                 isBackVisibile: NO
     ];
    [self setupLeftMenuButton];
    
    
    //load data
    if (goalType==HEALTH_GOAL_PRESSURE)
        minValue = [currentSection minLogValue2WithGoal:goalType];
    else
        minValue = [currentSection minLogValueWithGoal:goalType];
    if (minValue>10)
        minValue = minValue -10;

    maxValue = [currentSection maxLogValueWithGoal:goalType];

    int maxValueNorm = floor(maxValue / 10.0) * 10;
    maxValue = maxValueNorm +10;

    items = [HealthSection loadEntries:0 withGoalType:(int)goalType];
    
    [self initHeader];
    [self initTableView];
    
    self.screenName = [NSString stringWithFormat:@"%@ History Screen", [UCFSUtil sectionName:[currentSection sectionType] withGoal:(int)goalType]];

    
}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(cancelAction:) withSection:currentSection];
}

- (IBAction)cancelAction:(UIButton*)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    [self.navigationController popViewControllerAnimated: YES];
}

-(void)initHeader {
    float y = 44;
    if ([UCFSUtil deviceSystemIOS7])
        y = 0;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, y, 320, HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    float rowHeight = HEADER_HEIGHT;
    
    NSString* unit;
    switch(goalType) {
        case HEALTH_GOAL_WEIGHT:            unit = @"lbs"; break;
        case HEALTH_GOAL_PRESSURE:          unit = @"mmHg"; break;
        case HEALTH_GOAL_HEARTRATE:         unit = @"bpm"; break;
        case HEALTH_GOAL_GLUCOSE:           unit = @"mg/dL"; break;
        case HEALTH_GOAL_CHOLESTEROL_LDL:   unit = @"mg/dL"; break;
    }
    
    UILabel* minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFO_WIDTH, 0, 60, rowHeight)];
    minValueLabel.textColor = [UIColor blackColor];
    minValueLabel.backgroundColor = [UIColor clearColor];
    minValueLabel.text = [NSString stringWithFormat:@"%i", (int)(trunc(minValue))];
    minValueLabel.textAlignment =  NSTextAlignmentLeft;
    minValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
    [minValueLabel setAccessibilityLabel:[NSString stringWithFormat:@"minimum value in %@", unit]];
    [minValueLabel setAccessibilityValue:[NSString stringWithFormat:@"%@ %@", minValueLabel.text, unit]];
    
    
    UILabel* valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFO_WIDTH+60, 0, 116, rowHeight)];
    valueLabel.textColor = [UIColor blackColor];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.textAlignment =  NSTextAlignmentCenter;
    valueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
    valueLabel.text = unit;
    [valueLabel setIsAccessibilityElement:NO];

    
    
    UILabel* maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFO_WIDTH+156, 0, 80, rowHeight)];
    maxValueLabel.textColor = [UIColor blackColor];
    maxValueLabel.backgroundColor = [UIColor clearColor];
    maxValueLabel.text = [NSString stringWithFormat:@"%i", (int)(trunc(maxValue))];
    maxValueLabel.textAlignment =  NSTextAlignmentRight;
    maxValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
    [maxValueLabel setAccessibilityLabel:[NSString stringWithFormat:@"maximum value in %@", unit]];
    [maxValueLabel setAccessibilityValue:[NSString stringWithFormat:@"%@ %@", maxValueLabel.text, unit]];
    
    
    [headerView addSubview:minValueLabel];
    [headerView addSubview:maxValueLabel];
    [headerView addSubview:valueLabel];
    
    
    [self.view addSubview:headerView];
}


-(void)initTableView {
    float tableHeight = [UCFSUtil contentAreaHeight]-HEADER_HEIGHT;
    CGRect tableRect = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, 320, tableHeight);
    listTableView = [[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    listTableView.rowHeight = TABLE_ROW_HEIGHT;
    listTableView.opaque = NO;
    listTableView.backgroundColor = [UIColor clearColor];
    listTableView.sectionFooterHeight = 0;
    listTableView.sectionHeaderHeight = 0;
    listTableView.scrollEnabled = YES;
    listTableView.showsVerticalScrollIndicator = YES;
    listTableView.userInteractionEnabled = YES;
    listTableView.bounces = NO;
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.backgroundView = nil;
    
    [self.view addSubview:listTableView];
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( items!=nil && ([items count]>0) ) {
        return [items count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TABLE_ROW_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"TableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    HealthHistoryCellView *cellView = nil;
    FTLogData* item = [items objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGRect rect = CGRectMake(0, 0, 320, TABLE_ROW_HEIGHT);
        
        cellView = [[HealthHistoryCellView alloc] initWithFrame:rect withSection:currentSection withLogData:item withMinValue:minValue withMaxValue:maxValue withGoalType:goalType];
        cellView.tag = 1;
        [[cell contentView] setBackgroundColor:[UIColor clearColor]];
        [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        [cell.contentView addSubview:cellView];
    }
    
    if (cellView==nil)
        cellView = (HealthHistoryCellView*)[cell.contentView viewWithTag:1];
    [cellView updateWithLogData:item withMinValue:minValue withMaxValue:maxValue];
    cellView.opaque = NO;
    cellView.backgroundColor = [UIColor clearColor];
    
    
    return cell;
    
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
