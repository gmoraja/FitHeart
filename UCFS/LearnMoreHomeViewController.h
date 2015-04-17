//
//  LearnMoreHomeViewController.h
//  FitHeart
//
//  Created by Bitgears on 17/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "ScreenMaskView.h"

enum {
    MENU_LEARNMORE_FITNESS             = 0,
    MENU_LEARNMORE_HEALTH              = 1,
    MENU_LEARNMORE_NUTRITION           = 2,
    MENU_LEARNMORE_MOOD                = 3
    
}; typedef NSUInteger FTLearnMoreMenuItemType;

@interface LearnMoreHomeViewController : GAITrackedViewController<UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *menuItems;
    ScreenMaskView* screenMaskView;
}

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

-(void)enableScreen;
-(void)disableScreen;

@end
