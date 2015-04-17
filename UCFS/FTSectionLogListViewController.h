//
//  FTSectionLogListViewController.h
//  FitHeart
//
//  Created by Bitgears on 05/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "FTLogListContainerView.h"


@interface FTSectionLogListViewController : UIViewController<FTLogListContainerDelegate> {
    Class<FTSection> currentSection;
    FTLogListContainerView *containerView;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withLogNibName:(NSString*)logNib;


@end
