//
//  MoodHistoryViewController.h
//  FitHeart
//
//  Created by Bitgears on 06/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"



@interface MoodHistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
    Class<FTSection> currentSection;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section;


@end
