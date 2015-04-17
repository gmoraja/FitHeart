//
//  AboutViewController.h
//  FitHeart
//
//  Created by Bitgears on 16/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTNoteHeaderView.h"
#import "RTLabel.h"
#import "GAITrackedViewController.h"
#import "ScreenMaskView.h"

@interface AboutViewController : GAITrackedViewController<FTNoteHeaderDelegate, RTLabelDelegate, UITableViewDataSource,UITableViewDelegate> {
    ScreenMaskView* screenMaskView;
}

@property (strong, nonatomic) IBOutlet UITableView *contentTableView;

-(void)enableScreen;
-(void)disableScreen;

@end
