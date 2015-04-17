//
//  LearnMoreContentViewController.h
//  FitHeart
//
//  Created by Bitgears on 17/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTNoteHeaderView.h"
#import "RTLabel.h"
#import "GAITrackedViewController.h"


@interface LearnMoreContentViewController : GAITrackedViewController<FTNoteHeaderDelegate, RTLabelDelegate, UITableViewDataSource,UITableViewDelegate> {
    int sectionId;
    int headerId;
}

@property (assign, nonatomic) int sectionId;
@property (assign, nonatomic) int headerId;
@property (strong, nonatomic) IBOutlet UITableView *contentTableView;

@end
