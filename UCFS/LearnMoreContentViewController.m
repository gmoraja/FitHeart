//
//  LearnMoreContentViewController.m
//  FitHeart
//
//  Created by Bitgears on 17/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "LearnMoreContentViewController.h"
#import "LearnMoreSection.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTNote.h"
#import "FTNoteHeader.h"
#import "FTNoteHeaderView.h"
#import "RTLabel.h"
#import "LearnDetailViewController.h"

static float noteViewHeight = 100;
static float headerViewHeight = 50;
static float lineSpacing = 1;
static NSString *cellNoteIdentifier = @"CELL_NOTE";
static NSString *cellHeaderIdentifier = @"CELL_HEADER";

@interface LearnMoreContentViewController () {
    NSMutableArray* cellTypes;
    NSMutableArray* sections;
    CGRect noteRect;
    
}

@end

@implementation LearnMoreContentViewController

@synthesize contentTableView;
@synthesize sectionId;
@synthesize headerId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        headerId = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    
    NSString* filename = nil;
    NSString* sectionName = nil;
    switch (sectionId) {
        case SECTION_FITNESS:
            filename = @"learnmore_fitness";
            sectionName = [NSString stringWithFormat:@"%@ - %@", [LearnMoreSection title], @"FITNESS"];
            break;
        case SECTION_HEALTH:
            filename = @"learnmore_health";
            sectionName = [NSString stringWithFormat:@"%@ - %@", [LearnMoreSection title], @"HEALTH"];
            break;
        case 4:
            filename = @"learnmore_nutrition";
            sectionName = [NSString stringWithFormat:@"%@ - %@", [LearnMoreSection title], @"NUTRITION"];
            break;
        case SECTION_MOOD:
            filename = @"learnmore_mood";
            sectionName = [NSString stringWithFormat:@"%@ - %@", [LearnMoreSection title], @"MOOD"];
            break;
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:sectionName
                    bkgFileName:[LearnMoreSection navBarBkg]
                      textColor:[LearnMoreSection navBarTextColor]
                 isBackVisibile: NO
     ];
    
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    [self.mm_drawerController setMaximumRightDrawerWidth:200.0];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    noteRect = CGRectMake(20, 13, 280, noteViewHeight);
    
    sections = [UCFSUtil noteHeadersFromJson:filename];
    
    if (headerId>=0 && headerId<[sections count]) {
        //open section header
        FTNoteHeader* noteHeader = [sections objectAtIndex:headerId];
        noteHeader.isExpanded = true;
    }
    
    [self calculateNoteSize];
    cellTypes = [[NSMutableArray alloc] init];
    [self calculateCellTypes];
    
   
    self.screenName = [NSString stringWithFormat:@"Learn More %@ Screen", [UCFSUtil sectionName:sectionId withGoal:-1] ];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [contentTableView reloadData];
    
    if (headerId>=0 && headerId<[sections count]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:headerId];
        [contentTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        headerId = -1;
    }
    
}


-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(backAction:) withTextColor:[LearnMoreSection navBarTextColor]];
}

-(void)setupRightMenuButton{
}

- (IBAction)backAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated: YES];
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
                
                /*
                UIWebView* webView = [[UIWebView alloc] initWithFrame:noteRect];
                [webView loadHTMLString:note.note baseURL:nil];
                webView.scrollView.bounces = NO;
                [webView sizeToFit];
                note.size = [webView sizeThatFits:CGSizeZero];
                 */
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
            int children = [noteHeader.notes count];
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
        NSString* idStr = [cellHeaderIdentifier stringByAppendingString:[NSString stringWithFormat:@"%i", indexPath.section] ];
        UITableViewCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:idStr];
        FTNoteHeaderView* headerView = nil;
        FTNoteHeader* noteHeader = [sections objectAtIndex:indexPath.section];
        if (cellHeader == nil) {
            cellHeader = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
            
            UIColor* textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1];
            CGRect headerRect = CGRectMake(0, 0, 320, headerViewHeight);
            headerView = [[FTNoteHeaderView alloc] initWithFrame:headerRect withLabel:noteHeader.label withLabelColor:textColor];
            headerView.delegate = self;
            headerView.section = indexPath.section;
            headerView.tag = 1;
            [cellHeader.contentView addSubview:headerView];
        }
        else {
            headerView = (FTNoteHeaderView*)[cellHeader.contentView viewWithTag:1];
        }
        if (noteHeader.isExpanded==YES)
            [headerView setAsOpened];
        else
            [headerView setAsClosed];
        
        [cellHeader setBackgroundColor:[UIColor clearColor]];
        return cellHeader;
    }
    else {
        NSString* idStr = [cellNoteIdentifier stringByAppendingString:[NSString stringWithFormat:@"%i-%i", indexPath.section, indexPath.row] ];
        UITableViewCell *cellNote = [tableView dequeueReusableCellWithIdentifier:idStr];
        //RTLabel* rtLabel = nil;
        UIWebView* webView = nil;
        if (cellNote == nil) {
            cellNote = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
            
            FTNoteHeader* noteHeader = [sections objectAtIndex:indexPath.section];
            FTNote* note = [noteHeader.notes objectAtIndex:(indexPath.row-1)];
            /*
            rtLabel = [[RTLabel alloc] initWithFrame:CGRectMake(noteRect.origin.x, noteRect.origin.y, noteRect.size.width, note.size.height)];
            rtLabel.lineSpacing = 1.0;
            rtLabel.text = note.note;
            rtLabel.tag = 1;
            rtLabel.objectData = note;
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
             */
            
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(noteRect.origin.x, noteRect.origin.y, noteRect.size.width, note.size.height+50)];
            NSString* content = [UCFSUtil htmlFromBodyString:note.note textFont:[UIFont fontWithName:@"SourceSansPro-Bold" size:18.0] textColor:[UIColor blackColor]];
            [webView loadHTMLString:content baseURL:nil];
            webView.delegate = self;
            [cellNote.contentView addSubview:webView];
            
            
        }
        //if (rtLabel==nil)
        //    rtLabel = (RTLabel*)[cellNote.contentView viewWithTag:1];
        
        [cellNote setBackgroundColor:[UIColor clearColor]];
        [cellNote setSelectedBackgroundView:nil];
        
        return cellNote;
    }

}

-(IBAction)didTap:(id)sender {
    UITapGestureRecognizer* gesture = (UITapGestureRecognizer*)sender;
    RTLabel* label = (RTLabel*)gesture.view;
    NSObject* obj = label.objectData;
    if (obj!=nil) {
        FTNote* note = (FTNote*)obj;
        
        if (note.linkAcc!=nil) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:note.linkAcc]];
        }
    }

}



- (void)clickHeaderView:(UIView*)headerView withSection:(int)section {
    FTNoteHeader* noteHeader = [sections objectAtIndex:section];
    /*
    noteHeader.isExpanded=!noteHeader.isExpanded;
    [self calculateCellTypes];
    [contentTableView reloadData];
    if (UIAccessibilityIsVoiceOverRunning()==NO) {
        [contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
    }
     */
    FTNote* note = [noteHeader.notes objectAtIndex:0];
    LearnDetailViewController* controller = [[LearnDetailViewController alloc] initWithNibName:@"LearnMoreDetailView" bundle:nil withNote:note withSectionName:noteHeader.label];
    [self.navigationController pushViewController:controller animated:YES];
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

@end
