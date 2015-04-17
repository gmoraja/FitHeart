//
//  LateralMenuViewController.h
//  FitHeart
//
//  Created by Bitgears on 12/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>


enum {
    MENU_FITNESS                = 0,
    MENU_HEALTH                 = 1,
    MENU_MOOD                   = 2,
    MENU_LEARNMORE              = 3,
    MENU_SUPPORT                = 4,
    MENU_ABOUT                  = 5,
    MENU_SETTING                = 6,
    MENU_NONE                   = 7
    
}; typedef NSUInteger FTMenuItemType;

@interface LateralMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {

    NSMutableArray *items;
    UIFont *itemFont;
    UIView *bgColorView;
    UIView *bgEmptyView;
    UIImageView *separator;
}

@property (strong, nonatomic) IBOutlet UITableView *menuTableView;

-(void)replaceSectionMenuItem:(int)section;
-(void)selectMenuItem:(int)item;

@end
