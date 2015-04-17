//
//  AboutViewController.m
//  FitHeart
//
//  Created by Bitgears on 16/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutSection.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTNote.h"
#import "FTNoteHeader.h"
#import "FTNoteHeaderView.h"
#import "RTLabel.h"
#import "TutorialViewController.h"
#import "LearnDetailViewController.h"

static float noteViewHeight = 100;
static float headerViewHeight = 50;
static float lineSpacing = 1;
static NSString *cellNoteIdentifier = @"CELL_NOTE";
static NSString *cellHeaderIdentifier = @"CELL_HEADER";

@interface AboutViewController () {
    
    NSMutableArray* cellTypes;
    NSMutableArray* sections;
    CGRect noteRect;
}

@end

@implementation AboutViewController

@synthesize contentTableView;

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
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:[AboutSection title]
                    bkgFileName:[AboutSection navBarBkg]
                      textColor:[AboutSection navBarTextColor]
                 isBackVisibile: NO
     ];
    
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    [self.mm_drawerController setMaximumRightDrawerWidth:200.0];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    noteRect = CGRectMake(18, 13, 284, noteViewHeight);
    
    sections = [UCFSUtil noteHeadersFromJson:@"about"];
    [self calculateNoteSize];
    cellTypes = [[NSMutableArray alloc] init];
    [self calculateCellTypes];
/*
    if ([UCFSUtil deviceSystemIOS7]) {
        contentTableView.frame = CGRectMake(contentTableView.frame.origin.x, contentTableView.frame.origin.y, contentTableView.frame.size.width, contentTableView.frame.size.height+30);
    }
*/
    
    self.screenName = @"About Screen";
    

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [contentTableView reloadData];
    
}

-(void)setupLeftMenuButton{
    [self.navigationItem setLeftBarButtonItem:[UCFSUtil getNavigationBarMenuDarkButton:nil withTarget:self action:@selector(menuAction:)] animated:YES];
}

- (IBAction)menuAction:(UIButton*)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)setupRightMenuButton{
}

-(void)calculateNoteSize {
    for (int i=0; i<[sections count]; i++) {
        FTNoteHeader* noteHeader = [sections objectAtIndex:i];
        if (noteHeader!=nil && noteHeader.notes!=nil) {
            for (int j=0; j<[noteHeader.notes count]; j++) {
                FTNote* note = [noteHeader.notes objectAtIndex:j];
                
                RTLabel* rtLabel = [[RTLabel alloc] initWithFrame:noteRect];
                rtLabel.lineSpacing = lineSpacing;
                rtLabel.text = note.note;
                note.size = [rtLabel optimumSize];
            }
        }
    }
}

-(void)calculateCellTypes {
    [cellTypes removeAllObjects];
    for (int i=0; i<[sections count]; i++) {
        
        FTNoteHeader* noteHeader = [sections objectAtIndex:i];
        if (noteHeader!=nil && noteHeader.isExpanded) {
            [cellTypes addObject:[NSNumber numberWithInt:2]]; //OPENED HEADER + CHILDREN
            int children =  (int)[noteHeader.notes count];
            for (int j=0; j<children; j++)
                [cellTypes addObject:[NSNumber numberWithInt:0]]; //NOTE
        }
        else
            [cellTypes addObject:[NSNumber numberWithInt:1]]; //CLOSED HEADER
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FTNoteHeader* noteHeader = [sections objectAtIndex:section];
    if (noteHeader!=nil && [noteHeader.notes count]>0) {
        if (noteHeader.isExpanded) {
            return [noteHeader.notes count]+1;
        }
        else
            return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0)
        return headerViewHeight;
    else {
        FTNoteHeader* noteHeader = [sections objectAtIndex:indexPath.section];
        if (noteHeader!=nil) {
            if (noteHeader.notes!=nil && indexPath.row<=[noteHeader.notes count]) {
                FTNote* note = [noteHeader.notes objectAtIndex:indexPath.row-1];
                return note.size.height+30;
            }
        }
        return noteViewHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        //SECTION
        NSString* idStr = [cellHeaderIdentifier stringByAppendingString:[NSString stringWithFormat:@"%li", (long)indexPath.section] ];
        UITableViewCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:idStr];
        FTNoteHeaderView* headerView = nil;
        FTNoteHeader* noteHeader = [sections objectAtIndex:indexPath.section];
        if (cellHeader == nil) {
            cellHeader = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
            UIColor* textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1];
           
            CGRect headerRect = CGRectMake(0, 0, 320, headerViewHeight);
            headerView = [[FTNoteHeaderView alloc] initWithFrame:headerRect withLabel:noteHeader.label withLabelColor:textColor];
            headerView.delegate = self;
            headerView.section = (int)indexPath.section;
            headerView.tag = 1;
            [cellHeader.contentView addSubview:headerView];
            
        }
        else {
            headerView = (FTNoteHeaderView*)[cellHeader.contentView viewWithTag:1];
        }
        if (noteHeader.uniqueId==4)
            [headerView hideArrow];
        
        if (noteHeader.isExpanded==YES) {
            [headerView setAsOpened];
        }
        else {
            [headerView setAsClosed];
        }

        [cellHeader setBackgroundColor:[UIColor clearColor]];
        return cellHeader;
    }
    else {
        NSString* idStr = [cellNoteIdentifier stringByAppendingString:[NSString stringWithFormat:@"%i-%li", (int)indexPath.section, (long)indexPath.row] ];
        UITableViewCell *cellNote = [tableView dequeueReusableCellWithIdentifier:idStr];
        RTLabel* rtLabel = nil;
        if (cellNote == nil) {
            cellNote = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
            
            FTNoteHeader* noteHeader = [sections objectAtIndex:indexPath.section];
            FTNote* note = [noteHeader.notes objectAtIndex:(indexPath.row-1)];

            rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(noteRect.origin.x, noteRect.origin.y, noteRect.size.width, note.size.height)];
            rtLabel.lineSpacing = 1.0;
            rtLabel.text = note.note;
            rtLabel.tag = 1;
            [rtLabel setDelegate:self];
            
            if (UIAccessibilityIsVoiceOverRunning()) {
                if ([noteHeader.label isEqualToString:@"Links"]==NO) {
                    [rtLabel setIsAccessibilityElement:YES];
                    [rtLabel setAccessibilityValue:note.noteAcc];
                    
                    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
                    [rtLabel addGestureRecognizer:tapRecognizer];
                    
                }
            }

            
            [cellNote.contentView addSubview:rtLabel];
            
        }
        if (rtLabel==nil)
            rtLabel = (RTLabel*)[cellNote.contentView viewWithTag:1];
        
        [cellNote setBackgroundColor:[UIColor clearColor]];
        [cellNote setSelectedBackgroundView:nil];
        [cellNote setAccessibilityValue:rtLabel.text];
        [cellNote setUserInteractionEnabled:YES];
        
        return cellNote;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)clickHeaderView:(UIView*)headerView withSection:(int)section {
    FTNoteHeader* noteHeader = [sections objectAtIndex:section];
    if (noteHeader.uniqueId!=4) {
        /*
        noteHeader.isExpanded=!noteHeader.isExpanded;
        [self calculateCellTypes];
        [contentTableView reloadData];
        if (UIAccessibilityIsVoiceOverRunning()==NO) {
            [contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            
        }
         */
        FTNote* note = [noteHeader.notes objectAtIndex:0];
        LearnDetailViewController* controller = [[LearnDetailViewController alloc] initWithNibName:@"LearnMoreDetailView" bundle:nil withNote:note withSectionName:noteHeader.label];
        [self.navigationController pushViewController:controller animated:YES];

    }
    else {
        UIViewController* viewController = [[TutorialViewController alloc] initWithNibName:@"TutorialView" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
    }

    
}

- (void)expandItemAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    FTNoteHeader* noteHeader = [sections objectAtIndex:index];
    int insertPos = index + 1;
    for (int i = 0; i < [noteHeader.notes count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    [contentTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)collapseSubItemsAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    FTNoteHeader* noteHeader = [sections objectAtIndex:index];
    for (int i = index + 1; i <= index + [noteHeader.notes count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [contentTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    [[UIApplication sharedApplication] openURL:url];
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
