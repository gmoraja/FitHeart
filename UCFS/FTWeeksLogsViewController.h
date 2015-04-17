//
//  FTWeeksLogsViewController.h
//  FitHeart
//
//  Created by Bitgears on 01/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "FTGoalData.h"
#import "FTWeeksLogCellView.h"


@interface FTWeeksLogsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, FTWeeksLogCellProtocol> {
    Class<FTSection> currentSection;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withGoalData:(FTGoalData*)goalData withLogNibName:(NSString*)logNib;

@end
