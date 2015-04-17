//
//  FTGoalHistoryViewController.h
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "GAITrackedViewController.h"


@interface FTGoalHistoryViewController : GAITrackedViewController<UITableViewDelegate, UITableViewDataSource> {
    Class<FTSection> currentSection;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withLogNibName:(NSString*)logNib;

@end
