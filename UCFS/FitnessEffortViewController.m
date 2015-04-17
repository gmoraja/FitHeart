//
//  FitnessEffortViewController.m
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FitnessEffortViewController.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"
#import "MenuItem.h"
#import "EffortTableViewCell.h"

static NSArray *efforts = nil;
static float CELL_HEIGHT = 65;

@interface FitnessEffortViewController ()  {
    
    int effort;
    FTLogData* logData;
    NSMutableArray* items;
    UIFont* itemFont;
}


@end

@implementation FitnessEffortViewController

@synthesize effortTableView;
@synthesize rowView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withLogData:(FTLogData*)log
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = [FitnessSection class];
        effort = log.effort;
        efforts = [FitnessSection getEfforts];
        logData = log;
        
        itemFont = [UIFont fontWithName:@"SourceSansPro-Light" size:20.0];
        
        MenuItem *notSelectedItem = [[MenuItem alloc] initWithTitle:@"Not Selected" thumbImageFileName:nil thumbOnImageFileName:nil withType:0];
        MenuItem *veryEasyItem = [[MenuItem alloc] initWithTitle:@"Very Easy" thumbImageFileName:@"effort_veryeasy" thumbOnImageFileName:@"effort_veryeasy_sel" withType:1];
        MenuItem *easyItem = [[MenuItem alloc] initWithTitle:@"Easy" thumbImageFileName:@"effort_easy" thumbOnImageFileName:@"effort_easy_sel" withType:2];
        MenuItem *somewhateasyItem = [[MenuItem alloc] initWithTitle:@"Somewhat Easy" thumbImageFileName:@"effort_somewhateasy" thumbOnImageFileName:@"effort_somewhateasy_sel" withType:3];
        MenuItem *somewhathardItem = [[MenuItem alloc] initWithTitle:@"Somewhat Hard" thumbImageFileName:@"effort_somewhathard" thumbOnImageFileName:@"effort_somewhathard_sel" withType:4];
        MenuItem *hardItem = [[MenuItem alloc] initWithTitle:@"Hard" thumbImageFileName:@"effort_hard" thumbOnImageFileName:@"effort_hard_sel" withType:5];
        MenuItem *veryhardItem = [[MenuItem alloc] initWithTitle:@"Very Hard" thumbImageFileName:@"effort_veryhard" thumbOnImageFileName:@"effort_veryhard_sel" withType:6];
        
        items = [NSMutableArray arrayWithObjects:notSelectedItem, veryEasyItem, easyItem, somewhateasyItem, somewhathardItem, hardItem, veryhardItem, nil];
        
        if ([UCFSUtil deviceIs3inch]) {
            CELL_HEIGHT = 50;
        }
        else {
            CELL_HEIGHT = 65;
       }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:@"EFFORT"
                    bkgFileName:[FitnessSection navBarBkg:0]
                      textColor:[UIColor whiteColor]
                 isBackVisibile: NO
     ];
    
    [self setupRightMenuButton];
    

    
    if ([UCFSUtil deviceSystemIOS7]) {
        effortTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([effortTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [effortTableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:logData.effort inSection:0];
    [effortTableView selectRowAtIndexPath:indexPath
                                animated:YES
                          scrollPosition:UITableViewScrollPositionNone];
    //[self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    
}


-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarDoneButtonWithTarget:self action:@selector(doneAction:) withSection:[FitnessSection class]];
}


- (IBAction)doneAction:(UIButton*)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    [self.navigationController popViewControllerAnimated: NO];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"EffortTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    MenuItem *item = [items objectAtIndex:indexPath.row];
    if (cell == nil) {
        cell = [[EffortTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier withMenuItem:item];
        
        if (item!=nil) {
            cell.indentationWidth = 130;
            cell.textLabel.font = itemFont;
            //[cell setSelectedBackgroundView:bgEmptyView];
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.textLabel.text = item.title;
            cell.textLabel.textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
            cell.imageView.image = item.thumbImage;
            
        }
        
        
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem *item = [items objectAtIndex:indexPath.row];
    if (item!=nil) {
         effort = item.menuType;
        logData.effort = item.menuType;
    }
    
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
