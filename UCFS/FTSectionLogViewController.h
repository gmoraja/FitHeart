//
//  FTSectionLogViewController.h
//  FitHeart
//
//  Created by Bitgears on 30/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "FTDialogView.h"
#import "FTLogContainerView.h"
#import "GAITrackedViewController.h"


@interface FTSectionLogViewController : GAITrackedViewController<FTLogContainerDelegate, FTDialogDelegate> {
    Class<FTSection> currentSection;
    FTLogContainerView *logContainerView;
    BOOL isEditing;
    BOOL useTimer;
    FTLogData* editableLogData;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withLogData:(FTLogData*)logData;


@end
