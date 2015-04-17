//
//  MoodHistoryViewController.m
//  FitHeart
//
//  Created by Bitgears on 06/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "MoodHistoryViewController.h"
#import "UCFSUtil.h"
#import "MoodHistoryCellView.h"
#import "FTHowDoYouFeelViewController.h"


static float HEADER_HEIGHT = 46;
static float TABLE_ROW_HEIGHT = 51;
static float INFO_WIDTH = 78.0;
static float MOOD_IMAGE_WIDTH = 39.0;
static float SECTION_ROW_HEIGHT = 0;

@interface MoodHistoryViewController () {
    NSMutableArray *groupedItems;
    
    UIView* headerView;
    UITableView* listTableView;
    
}

@end

@implementation MoodHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = section;

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
                          title:@"MOOD HISTORY"
                    bkgFileName:[currentSection navBarBkg:0]
                      textColor:[currentSection navBarTextColor:0]
                 isBackVisibile: NO
     ];
    [self setupLeftMenuButton];
    
    
    //load data
    groupedItems = [currentSection loadEntriesWithGoalData:nil];

    [self initHeader];
    [self initTableView];
    
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
    float y=0;
    if ([UCFSUtil deviceSystemIOS7]) y=44;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    for (int i=0; i<5; i++) {
        CGRect moodRect = CGRectMake(INFO_WIDTH+5+ (i*(MOOD_IMAGE_WIDTH+10)), 2, MOOD_IMAGE_WIDTH, MOOD_IMAGE_WIDTH);
        UIImageView* moodImageView = [[UIImageView alloc] initWithFrame:moodRect];
        switch (i) {
            case 0: [moodImageView setImage:[UIImage imageNamed:@"mood_smile_5_graphLabel"]];  break;
            case 1: [moodImageView setImage:[UIImage imageNamed:@"mood_smile_4_graphLabel"]];  break;
            case 2: [moodImageView setImage:[UIImage imageNamed:@"mood_smile_3_graphLabel"]];  break;
            case 3: [moodImageView setImage:[UIImage imageNamed:@"mood_smile_2_graphLabel"]];  break;
            case 4: [moodImageView setImage:[UIImage imageNamed:@"mood_smile_1_graphLabel"]];  break;
        }
        [headerView addSubview:moodImageView];
    }
    
    
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
    if (groupedItems!=nil)
        return [groupedItems count];
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( groupedItems!=nil && ([groupedItems count]>section) ) {
        FTDateLogData* dateLogData = [groupedItems objectAtIndex:section];
        if (dateLogData!=nil && dateLogData.logs!=nil)
            return [dateLogData.logs count]+1;
        else
            return 1;
        
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0)
        return SECTION_ROW_HEIGHT;
    else
        return TABLE_ROW_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        //SECTION
        static NSString *simpleTableHeaderIdentifier = @"TableHeader";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableHeaderIdentifier];
        
        //FTDateLogData* dateLogData = [groupedItems objectAtIndex:indexPath.section];
        UIView* cellView = nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableHeaderIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CGRect rect = CGRectMake(0, 0, 320, SECTION_ROW_HEIGHT);
            
            cellView = [[UIView alloc] initWithFrame:rect];
            cellView.tag = 1;
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            
            [cell.contentView addSubview:cellView];
        }

        
        return cell;
        
    }
    else {
        static NSString *simpleTableIdentifier = @"TableItem";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        MoodHistoryCellView *cellView = nil;
        FTDateLogData* dateLogData = [groupedItems objectAtIndex:indexPath.section];
        FTLogData* logData = [dateLogData.logs objectAtIndex:indexPath.row-1];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CGRect rect = CGRectMake(0, 0, 320, TABLE_ROW_HEIGHT);
            
            cellView = [[MoodHistoryCellView alloc] initWithFrame:rect withSection:currentSection  withLogData:logData];
            cellView.tag = 1;
            [[cell contentView] setBackgroundColor:[UIColor clearColor]];
            [[cell backgroundView] setBackgroundColor:[UIColor clearColor]];
            [cell setBackgroundColor:[UIColor clearColor]];
            
            [cell.contentView addSubview:cellView];
        }
        
        if (cellView==nil)
            cellView = (MoodHistoryCellView*)[cell.contentView viewWithTag:1];
        [cellView updateWithLogData:logData];
        
        return cell;
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FTDateLogData* dateLogData = [groupedItems objectAtIndex:indexPath.section];
    FTLogData* logData = [dateLogData.logs objectAtIndex:indexPath.row-1];
    if (logData!=nil)
        [self editLog:logData];
}


- (void)editLog:(FTLogData*)logData {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    FTHowDoYouFeelViewController *viewController = [[FTHowDoYouFeelViewController alloc] initWithNibName:@"MoodHowDoYouFeelView" bundle:nil withSection:currentSection withLog:logData];
    
    [self.navigationController pushViewController:viewController animated:NO];
    
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
