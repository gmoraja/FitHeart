//
//  MoodWriteanoteViewController.m
//  FitHeart
//
//  Created by Bitgears on 23/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "MoodWriteanoteViewController.h"
#import "MoodSection.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "MoodAddNoteViewController.h"
#import "MoodNoteView.h"


static float noteViewHeight = 100;


@interface MoodWriteanoteViewController () {
    
    NSArray* notes;
    UIView* contentView;
}

@end

@implementation MoodWriteanoteViewController

@synthesize contentScrollView;
@synthesize firstUseLabel;

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
                          title:UCFS_MoodVWriteANoteView_NavBar_Title
                    bkgFileName:[MoodSection navBarBkg:0]
                      tintColor:[MoodSection mainColor:0]
                 isBackVisibile: YES
     ];
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self reloadNotes];

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
        
        
        MoodAddNoteViewController *viewController = [[MoodAddNoteViewController alloc] initWithNibName:@"MoodAddNoteView" bundle:nil withSimplePleasure:FALSE];
        
        [self.navigationController pushViewController:viewController animated:NO];
}

-(void)reloadNotes {
    notes = [MoodSection loadAllNotes];
    if ( (notes!=nil) && ([notes count]>0) ) {
        
        //remove old views
        if (contentView!=nil) {
            NSArray* subViews = [contentView  subviews];
            if ( (subViews!=nil) && ([subViews count]>0) ) {
                for (int i=0; i<[subViews count]; i++) {
                    [subViews[i] removeFromSuperview];
                }
            }
            [contentView removeFromSuperview];
        }


        contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, noteViewHeight*[notes count])];
        contentView.backgroundColor = [UIColor clearColor];
        
        //add note view
        for (int i=0; i<[notes count]; i++) {
            CGRect noteRect = CGRectMake(0, noteViewHeight*i, 320, noteViewHeight);
            MoodNoteView* noteView = [[MoodNoteView alloc] initWithFrame:noteRect withNote:notes[i]];
            noteView.delegate = self;
            [contentView addSubview:noteView];
        }
        [contentScrollView addSubview:contentView];
        if ([UCFSUtil deviceSystemIOS7]==NO) {
            UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 40, 0.0);
            contentScrollView.contentInset = contentInsets;
            contentScrollView.scrollIndicatorInsets = contentInsets;
        }

        //contentScrollView.contentSize = contentView.bounds.size;
        [contentScrollView setContentSize:CGSizeMake(contentView.frame.size.width,contentView.frame.size.height)];
        [contentScrollView layoutIfNeeded];
        
        
        firstUseLabel.hidden = YES;
        contentScrollView.hidden = NO;
    }
    else {
        firstUseLabel.hidden = NO;
        contentScrollView.hidden = YES;
    }
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
    //[dialogView popupText:@"Successfully Deleted"];
        [self reloadNotes];

}

- (void)dialogPopupFinished:(UIView*)dialogView {
    //hide loading
    [dialogView removeFromSuperview];
    [self reloadNotes];
    
}

- (void)editNote:(FTNoteData*)note withView:(UIView *)view {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    
    MoodAddNoteViewController *viewController = [[MoodAddNoteViewController alloc] initWithNibName:@"MoodAddNoteView" bundle:nil withSimplePleasure:FALSE withNote:note];

    
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
