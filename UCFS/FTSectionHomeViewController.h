//
//  FTSectionHomeViewController.h
//  FitHeart
//
//  Created by Bitgears on 29/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "FTMainSelector.h"
#import "FTCircularView.h"
#import "FTHomeView.h"
#import "FTBannerView.h"
#import "FTDialogView.h"
#import "FTHomeActionDialogView.h"
#import "GAITrackedViewController.h"
#import "ScreenMaskView.h"


@interface FTSectionHomeViewController : GAITrackedViewController<FTHomeViewDelegate, FTDialogDelegate, FTHomeActionDialogViewDelegate> {
    Class<FTSection> currentSection;
    
    //FTCircularView *homeView;
    FTHomeActionDialogView* actionDialog;
    FTHomeView *homeView;
    NSTimer* mainSelectorTimer;
    NSString* logNibName;
    NSString* goalNibName;
    
    UIView *containerView;
    CGFloat contentStartY;
    float containerViewHeight;
    float maxY;
    float minY;
    CGRect topRect;
    CGRect bottomRect;
    float swipeValue;
    float bannerHeight;
    float bannerY;
    BOOL isSwipeEnabled;
    
    UIImageView *dottedLineView;
    UIImage *dottedLine;
    
    int currentDateType;
    
    BOOL showHomeView;
    BOOL showLeftMenuBtn;
    BOOL showRightMenuBtn;
    BOOL reached;
    
    UITapGestureRecognizer* navBarTap;
    UISwipeGestureRecognizer *navBarSwipeDown;
    
    ScreenMaskView* screenMaskView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withGoalNibName:(NSString*)goalNib withLogNibName:(NSString*)logNib;
-(void)setupLeftMenuButton;
-(void)setupRightMenuButton;
-(void)loadEntriesWithGoal:(int)goal withDateType:(int)dateType;
-(void)editGoal;
-(void)addLog;
-(void)goToScreen:(int)screen;
-(void)openHistory;
-(IBAction)openDialogAction:(UIButton*)sender;
-(void)enableScreen;
-(void)disableScreen;
- (IBAction)menuAction:(UIButton*)sender;

@end
