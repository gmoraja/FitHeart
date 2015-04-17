//
//  LearnDetailViewController.m
//  FitHeart
//
//  Created by Bitgears on 29/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "LearnDetailViewController.h"
#import "UCFSUtil.h"
#import "FTNote.h"
#import "LearnMoreSection.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface LearnDetailViewController () {
    FTNote* currentNote;
    NSString* currentSectionName;
}

@end

@implementation LearnDetailViewController

@synthesize detailWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withNote:(FTNote*)note withSectionName:(NSString*)sectionName {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentNote = note;
        currentSectionName = sectionName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.wantsFullScreenLayout = YES;
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:currentSectionName
                    bkgFileName:[LearnMoreSection navBarBkg]
                      textColor:[LearnMoreSection navBarTextColor]
                 isBackVisibile: NO
     ];
    
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    [self.mm_drawerController setMaximumRightDrawerWidth:200.0];
    [self.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
 
    
    self.screenName = [NSString stringWithFormat:@"Learn More %@ Screen", currentSectionName ];
    
    
    NSString* content = [UCFSUtil htmlFromBodyString:currentNote.note textFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:18.0] textColor:[UIColor blackColor]];
    [detailWebView loadHTMLString:content baseURL:nil];
    detailWebView.delegate = self;

}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(backAction:) withTextColor:[LearnMoreSection navBarTextColor]];
}

-(void)setupRightMenuButton{
}

- (IBAction)backAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated: YES];
}


-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
