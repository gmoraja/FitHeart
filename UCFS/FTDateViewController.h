//
//  FitnessDateViewController.h
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "AFPickerView.h"

@interface FTDateViewController : UIViewController<AFPickerViewDelegate, AFPickerViewDataSource> {
    Class<FTSection> currentSection;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withStartDate:(NSDate*)date withLogData:(FTLogData*)log withSection:(Class<FTSection>)section;

@end
