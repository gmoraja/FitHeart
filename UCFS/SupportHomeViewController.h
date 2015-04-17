//
//  SupportHomeViewController.h
//  FitHeart
//
//  Created by Bitgears on 12/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "ScreenMaskView.h"

enum {
    MENU_SUPPORT_MINDFULNESSAUDIO        = 0,
    MENU_SUPPORT_MINDFULNESSMEDITATION   = 1,
    MENU_SUPPORT_COMPASSIONMEDITATION    = 2,
    MENU_SUPPORT_STRESSREDUCTIONVIDEO    = 3,
    MENU_SUPPORT_PEOPLELIKEYOU           = 4,
    MENU_SUPPORT_FAMILY                  = 5,
    MENU_SUPPORT_HEALTHPROVIDERS         = 6
    
}; typedef NSUInteger FTSupportMenuItemType;

@interface SupportHomeViewController : GAITrackedViewController<UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *menuItems;
    ScreenMaskView* screenMaskView;
    
}

@property (strong, nonatomic) IBOutlet UITableView *menuTableView;
-(void)enableScreen;
-(void)disableScreen;


@end
