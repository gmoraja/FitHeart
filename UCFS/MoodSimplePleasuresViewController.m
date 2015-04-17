//
//  MoodSimplePleasuresViewController.m
//  FitHeart
//
//  Created by Bitgears on 23/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "MoodSimplePleasuresViewController.h"
#import "MoodSection.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTOptionGroupView.h"



//static float headerHeight = 36;
static float noteViewHeight = 100;
static float headerViewHeight = 50;
static NSString *cellNoteIdentifier = @"CELL_NOTE";
static NSString *cellHeaderIdentifier = @"CELL_HEADER";


@interface MoodSimplePleasuresViewController () {
    UIFont* headerItemFont;

    NSArray* simplePleasureTypes;
    FTNoteHeader* positiveEventsHeader;
    FTNoteHeader* gratitudeHeader;
    FTNoteHeader* silverLiningHeader;
    FTNoteHeader* personalStrenghtsHeader;
    FTNoteHeader* actOfKindnessHeader;
    
    NSMutableArray* cellTypes;
    UIView* headerBgColorView;
}

@end

@implementation MoodSimplePleasuresViewController

@synthesize noteTableView;
@synthesize firstUseLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        positiveEventsHeader = [[FTNoteHeader alloc] initWithId:0 withLabel:@"POSITIVE EVENTS"];
        gratitudeHeader = [[FTNoteHeader alloc] initWithId:1 withLabel:@"GRATITUDE"];
        silverLiningHeader = [[FTNoteHeader alloc] initWithId:2 withLabel:@"SILVER LINING"];
        personalStrenghtsHeader = [[FTNoteHeader alloc] initWithId:3 withLabel:@"PERSONAL STRENGTHS"];
        actOfKindnessHeader = [[FTNoteHeader alloc] initWithId:4 withLabel:@"ACTS OF KINDNESS"];

        simplePleasureTypes = [[NSArray alloc] initWithObjects:
                                positiveEventsHeader,
                                gratitudeHeader,
                                silverLiningHeader,
                                personalStrenghtsHeader,
                                actOfKindnessHeader,
                                nil
                               ];

        cellTypes = [[NSMutableArray alloc] init];
        [self calculateCellTypes];
        
        headerItemFont = [UIFont fontWithName:@"Futura-CondensedMedium" size:16.0];
        headerBgColorView = [[UIView alloc] init];
        headerBgColorView.backgroundColor = [UIColor clearColor];
        
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
                          title:UCFS_MoodSimplePleasureView_NavBar_Title
                    bkgFileName:[MoodSection navBarBkg:0]
                      tintColor:[MoodSection mainColor:0]
                 isBackVisibile: YES
     ];
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self reloadNotes];
    [self calculateCellTypes];
    [noteTableView reloadData];
    
}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarBackButtonWithTarget:self action:@selector(backAction:)];
}

-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarAddButton:nil withTarget:self action:@selector(addAction:)];
}

- (IBAction)backAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (IBAction)addAction:(UIButton*)sender {
    
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    
    MoodAddNoteViewController *viewController = [[MoodAddNoteViewController alloc] initWithNibName:@"MoodAddNoteView" bundle:nil withSimplePleasure:TRUE];
    
    [self.navigationController pushViewController:viewController animated:NO];
}

-(void)reloadNotes {
    positiveEventsHeader.notes = [MoodSection loadAllSimplePleasuresWithType:MOOD_SIMPLEPLEASURE_POSITIVEEVENTS];
    gratitudeHeader.notes = [MoodSection loadAllSimplePleasuresWithType:MOOD_SIMPLEPLEASURE_GRATITUDE];
    silverLiningHeader.notes = [MoodSection loadAllSimplePleasuresWithType:MOOD_SIMPLEPLEASURE_SILVERLINING];
    personalStrenghtsHeader.notes = [MoodSection loadAllSimplePleasuresWithType:MOOD_SIMPLEPLEASURE_PERSONALSTRENGHTS];
    actOfKindnessHeader.notes = [MoodSection loadAllSimplePleasuresWithType:MOOD_SIMPLEPLEASURE_ACTSOFKINDNESS];
    
    bool firstUse = (   (positiveEventsHeader.notes==nil || [positiveEventsHeader.notes count]==0) &&
                        (gratitudeHeader.notes==nil || [gratitudeHeader.notes count]==0) &&
                        (silverLiningHeader.notes==nil || [silverLiningHeader.notes count]==0) &&
                        (personalStrenghtsHeader.notes==nil || [personalStrenghtsHeader.notes count]==0) &&
                        (actOfKindnessHeader.notes==nil || [actOfKindnessHeader.notes count]==0)
                     );
    
    if (!firstUse) {

        firstUseLabel.hidden = YES;
        noteTableView.hidden = NO;
    }
    else {
        firstUseLabel.hidden = NO;
        noteTableView.hidden = YES;
    }
}

-(void)calculateCellTypes {
    [cellTypes removeAllObjects];
    for (int i=0; i<[simplePleasureTypes count]; i++) {
        
        FTNoteHeader* noteHeader = [simplePleasureTypes objectAtIndex:i];
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
    return [simplePleasureTypes count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FTNoteHeader* noteHeader = [simplePleasureTypes objectAtIndex:section];
    if (noteHeader!=nil && [noteHeader.notes count]>0) {
        if (noteHeader.isExpanded) {
            return [noteHeader.notes count]+1;
        }
        else
            return 1;
    }
    
    return 0;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0)
        return headerViewHeight;
    else
        return noteViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.row==0) {
        //SECTION
        NSString* idStr = [cellHeaderIdentifier stringByAppendingString:[NSString stringWithFormat:@"%i", indexPath.section] ];
        UITableViewCell *cellHeader = [tableView dequeueReusableCellWithIdentifier:idStr];
        FTNoteHeaderView* headerView = nil;
        FTNoteHeader* noteHeader = [simplePleasureTypes objectAtIndex:indexPath.section];
        if (cellHeader == nil) {
            cellHeader = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
            
            CGRect headerRect = CGRectMake(0, 0, 320, headerViewHeight);
            headerView = [[FTNoteHeaderView alloc] initWithFrame:headerRect withLabel:noteHeader.label withLabelColor:[MoodSection darkColor:0]];
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
        //[cellHeader changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        //[cellHeader setSelectedBackgroundView:headerBgColorView];
        [cellHeader setBackgroundColor:[UIColor clearColor]];
        return cellHeader;
    }
    else {
        FTNoteHeader* noteHeader = [simplePleasureTypes objectAtIndex:indexPath.section];
        FTNoteData* note = [noteHeader.notes objectAtIndex:(indexPath.row-1)];
        
        NSString* idStr = [cellNoteIdentifier stringByAppendingString:[NSString stringWithFormat:@"%i-%i", indexPath.section, indexPath.row] ];
        UITableViewCell *cellNote = [tableView dequeueReusableCellWithIdentifier:idStr];
        MoodNoteView* noteView = nil;
        if (cellNote == nil) {
            cellNote = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idStr];
            CGRect noteRect = CGRectMake(0, 0, 320, noteViewHeight);

            noteView = [[MoodNoteView alloc] initWithFrame:noteRect withNote:note];
            noteView.delegate = self;
            noteView.tag = 1;
            
            [cellNote.contentView addSubview:noteView];
            
        }
        
        if (noteView==nil)
            noteView = (MoodNoteView*)[cellNote.contentView viewWithTag:1];
        [noteView updateWithNote:note];
        
        [cellNote setBackgroundColor:[UIColor clearColor]];
        [cellNote setSelectedBackgroundView:nil];
        
        return cellNote;
    }

}

- (void)clickHeaderView:(UIView*)headerView withSection:(int)section {
    FTNoteHeader* noteHeader = [simplePleasureTypes objectAtIndex:section];
    noteHeader.isExpanded=!noteHeader.isExpanded;
    [self calculateCellTypes];
    [noteTableView reloadData];
}

- (void)expandItemAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    FTNoteHeader* noteHeader = [simplePleasureTypes objectAtIndex:index];
    int insertPos = index + 1;
    for (int i = 0; i < [noteHeader.notes count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    [noteTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)collapseSubItemsAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    FTNoteHeader* noteHeader = [simplePleasureTypes objectAtIndex:index];
    for (int i = index + 1; i <= index + [noteHeader.notes count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [noteTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

- (void)deleteNote:(FTNoteData*)note withView:(UIView *)view {
    //show loading
    /*
    FTDialogView *dialogView = [[FTDialogView alloc] initFullscreen];
    dialogView.delegate = self;
    [self.parentViewController.view addSubview:dialogView];
     */
    //delete data
    [MoodSection deleteNote:note];
    MoodNoteView* moodNoteView = (MoodNoteView*)view;
    [moodNoteView closeDelete];
    //[dialogView popupText:@"Successfully Deleted"];
    [self reloadNotes];
    [self calculateCellTypes];
    [noteTableView reloadData];
}

- (void)dialogPopupFinished:(UIView*)dialogView {
    //hide loading
    [dialogView removeFromSuperview];
    [self reloadNotes];
    [self calculateCellTypes];
    [noteTableView reloadData];
}

- (void)editNote:(FTNoteData*)note withView:(UIView *)view {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    
    MoodAddNoteViewController *viewController = [[MoodAddNoteViewController alloc] initWithNibName:@"MoodAddNoteView" bundle:nil withSimplePleasure:TRUE withNote:note];
    
    
    [self.navigationController pushViewController:viewController animated:NO];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
