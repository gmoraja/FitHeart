//
//  FTGoalHistoryViewController.m
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTGoalHistoryViewController.h"
#import "UCFSUtil.h"
#import "FTGoalGroupedData.h"
#import "FTGoalHistoryCellView.h"
#import "FTSection.h"

static float HEADER_HEIGHT = 46;
static float TABLE_ROW_HEIGHT = 60;
static float INFO_WIDTH = 78.0;

@interface FTGoalHistoryViewController () {
    NSString* logNibName;
    NSMutableArray *items;
    
    UIView* headerView;
    UITableView* listTableView;
    UIImageView* bkgView;
    
    float maxValue;
    float minValue;
    
    UILabel* weekLabel;

}

@end

@implementation FTGoalHistoryViewController

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
    int goal = [currentSection getCurrentGoal];
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:@"FITNESS HISTORY"
                    bkgFileName:[currentSection navBarBkg:goal]
                      textColor:[UIColor whiteColor]
                 isBackVisibile: NO
     ];

    [self setupLeftMenuButton];
    
    bkgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,[UCFSUtil contentAreaHeight])];
    [bkgView setImage:[UIImage imageNamed:@"goalhistorytablebkg"]];
    [self.view addSubview:bkgView];
    
    
    //load data
    items = [currentSection goalEntries];
    //calculate maxValue
    maxValue = 0;
    if (items!=nil && [items count]>0) {
        for (int i=0; i<[items count]; i++) {
            FTGoalGroupedData* item = [items objectAtIndex:i];
            if (item.totalValue>maxValue)
                maxValue = item.totalValue;
        }
        //round nearest 10 minutes
        int maxValueNorm = floor(maxValue / 10.0) * 10;
        maxValue = maxValueNorm +10;
    }
    //calculate minValue
    minValue = 0;
    if (items!=nil && [items count]>0) {
        for (int i=0; i<[items count]; i++) {
            FTGoalGroupedData* item = [items objectAtIndex:i];
            if (item.totalValue<minValue)
                minValue = item.totalValue;
        }
        /*
        int minValueNorm = floor(minValue / 10.0) * 10;
        minValue = minValueNorm -10;
        if (minValue<10) minValue = 10;
         */
    }
    [self initHeader];
    [self initTableView];
    
    self.screenName = [NSString stringWithFormat:@"%@ History Screen", [UCFSUtil sectionName:[currentSection sectionType] withGoal:-1]];

    
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
    
    
    [self.navigationController popViewControllerAnimated: NO];
}

-(void)initHeader {
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    float rowHeight = HEADER_HEIGHT;
    if ([currentSection sectionType]==SECTION_FITNESS ) {
        rowHeight = HEADER_HEIGHT / 2;
    }
    
    weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, INFO_WIDTH, headerView.frame.size.height)];
    weekLabel.textColor = [UIColor blackColor];
    weekLabel.backgroundColor = [UIColor clearColor];
    weekLabel.text = @"Week";
    weekLabel.textAlignment =  NSTextAlignmentCenter;
    weekLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
    [weekLabel setAccessibilityLabel:@"Week"];
    
    
    UILabel* minValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFO_WIDTH, 0, 60, rowHeight)];
    minValueLabel.textColor = [UIColor blackColor];
    minValueLabel.backgroundColor = [UIColor clearColor];
    minValueLabel.text = [NSString stringWithFormat:@"%i", (int)(trunc(minValue))];
    minValueLabel.textAlignment =  NSTextAlignmentLeft;
    minValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
    [minValueLabel setAccessibilityLabel:@"minimum value in minutes"];
    [minValueLabel setAccessibilityValue:[NSString stringWithFormat:@"%@ minutes", minValueLabel.text]];
    
    
    UILabel* valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFO_WIDTH+60, 0, 116, rowHeight)];
    valueLabel.textColor = [UIColor blackColor];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.textAlignment =  NSTextAlignmentCenter;
    valueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
    valueLabel.text = @"minutes";
    [valueLabel setIsAccessibilityElement:NO];
    
    UILabel* maxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFO_WIDTH+156, 0, 80, rowHeight)];
    maxValueLabel.textColor = [UIColor blackColor];
    maxValueLabel.backgroundColor = [UIColor clearColor];
    maxValueLabel.text = [NSString stringWithFormat:@"%i", (int)(trunc(maxValue))];
    maxValueLabel.textAlignment =  NSTextAlignmentRight;
    maxValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
    [maxValueLabel setAccessibilityLabel:@"maximum value in minutes"];
    [maxValueLabel setAccessibilityValue:[NSString stringWithFormat:@"%@ minutes", maxValueLabel.text]];

    if ([currentSection sectionType]==SECTION_FITNESS ) {
        
        float minValueSteps = [UCFSUtil calculateStepsFromMinutes:minValue];
        float maxValueSteps = [UCFSUtil calculateStepsFromMinutes:maxValue];
        
        UILabel* stepsMinValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFO_WIDTH, rowHeight, 60, rowHeight)];
        stepsMinValueLabel.textColor = [UIColor blackColor];
        stepsMinValueLabel.backgroundColor = [UIColor clearColor];
        stepsMinValueLabel.text = [NSString stringWithFormat:@"%i", (int)(trunc(minValueSteps))];
        stepsMinValueLabel.textAlignment =  NSTextAlignmentLeft;
        stepsMinValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
        [stepsMinValueLabel setAccessibilityLabel:@"minimum value in steps"];
        [stepsMinValueLabel setAccessibilityValue:[NSString stringWithFormat:@"%@ steps", stepsMinValueLabel.text]];
        
        UILabel* stepsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFO_WIDTH+60, rowHeight, 116, rowHeight)];
        stepsValueLabel.textColor = [UIColor blackColor];
        stepsValueLabel.backgroundColor = [UIColor clearColor];
        stepsValueLabel.textAlignment =  NSTextAlignmentCenter;
        stepsValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
        stepsValueLabel.text = @"steps";
        [stepsValueLabel setIsAccessibilityElement:NO];
        
        UILabel* stepsMaxValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFO_WIDTH+156, rowHeight, 80, rowHeight)];
        stepsMaxValueLabel.textColor = [UIColor blackColor];
        stepsMaxValueLabel.backgroundColor = [UIColor clearColor];
        stepsMaxValueLabel.text = [NSString stringWithFormat:@"%i", (int)(trunc(maxValueSteps))];
        stepsMaxValueLabel.textAlignment =  NSTextAlignmentRight;
        stepsMaxValueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
        [stepsMaxValueLabel setAccessibilityLabel:@"maximum value in steps"];
        [stepsMaxValueLabel setAccessibilityValue:[NSString stringWithFormat:@"%@ steps", stepsMaxValueLabel.text]];
        
        [headerView addSubview:stepsMinValueLabel];
        [headerView addSubview:stepsMaxValueLabel];
        [headerView addSubview:stepsValueLabel];
    }
    

    
    
    [headerView addSubview:weekLabel];
    [headerView addSubview:minValueLabel];
    [headerView addSubview:maxValueLabel];
    [headerView addSubview:valueLabel];

    
    [self.view addSubview:headerView];
}

-(void)initTableView {
    float tableHeight = [UCFSUtil contentAreaHeight]-HEADER_HEIGHT;
    CGRect tableRect = CGRectMake(0, HEADER_HEIGHT, 320, tableHeight);
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
    FTGoalHistoryCellView *cellView = nil;
    FTGoalGroupedData* item = [items objectAtIndex:indexPath.row];
    int barPerc = (item.totalValue / maxValue) * 100;
    if (barPerc>100) barPerc = 100;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGRect rect = CGRectMake(0, 0, 320, TABLE_ROW_HEIGHT);
        
        cellView = [[FTGoalHistoryCellView alloc] initWithFrame:rect withSection:currentSection withData:item withBarPerc:barPerc];
        cellView.tag = 1;
        [[cell contentView] setBackgroundColor:[UIColor clearColor]];
        [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        [cell.contentView addSubview:cellView];
    }
    
    if (cellView==nil)
        cellView = (FTGoalHistoryCellView*)[cell.contentView viewWithTag:1];
    [cellView updateWithData:item withBarPerc:barPerc];
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
